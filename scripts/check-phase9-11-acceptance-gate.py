#!/usr/bin/env python3
"""Validate Phase 9/10/11 acceptance checklists.

The default mode is conservative: it exits non-zero unless every Phase 9/10/11
scientific evidence gate is backed by an explicit evidence object. Use
--allow-tooling-only when the caller only wants to verify that tooling can move
forward while scientific closure remains blocked.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


PHASES = ("9", "10", "11")
TOOLING_KEYS = ("schema_or_contract", "scheduler_or_validator", "validation")
SCIENTIFIC_KEYS = ("cache", "provenance", "tier2", "source_ledger", "empirical_run")
READY_STATES = {"ok", "pass", "passed", "present", "ready", "validated"}
ZERO_GUARDS = ("hf_uploads", "dataset_downloads")
FALSE_GUARDS = ("thesis_edits", "roadmap_edits", "claim_registry_edits", "claim55_edits")
EVIDENCE_KEYS = {
    "artifact",
    "artifacts",
    "branch",
    "commit",
    "command",
    "commands",
    "evidence",
    "ledger_id",
    "path",
    "paths",
    "run_id",
    "sha256",
    "source_id",
}
CLOSURE_FIELDS = (
    "claim_status",
    "decision",
    "declares_complete",
    "phase_complete",
    "scientific_closure",
    "scientific_complete",
    "scientific_status",
    "status",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Validate a machine-readable Phase 9/10/11 acceptance checklist. "
            "Default exit behavior requires scientific evidence; "
            "--allow-tooling-only only requires tooling evidence and keeps "
            "scientific closure blocked."
        )
    )
    parser.add_argument(
        "checklist",
        nargs="?",
        help="Checklist JSON path. Use '-' or omit to read stdin.",
    )
    parser.add_argument(
        "--allow-tooling-only",
        action="store_true",
        help="Exit 0 when tooling gates pass even if scientific evidence is missing.",
    )
    parser.add_argument(
        "--template",
        action="store_true",
        help="Print a checklist template and exit.",
    )
    return parser.parse_args()


def phase_key(value: Any) -> str | None:
    text = str(value).strip().lower().replace("_", "-")
    match = re.search(r"(?:phase-?)?([0-9]+)", text)
    if not match:
        return None
    return match.group(1)


def load_json(path: str | None) -> dict[str, Any]:
    if not path or path == "-":
        raw = sys.stdin.read()
        source = "stdin"
    else:
        raw = Path(path).read_text(encoding="utf-8")
        source = path
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise SystemExit(f"ERROR: invalid JSON in {source}: {exc}") from exc
    if not isinstance(data, dict):
        raise SystemExit("ERROR: checklist root must be a JSON object")
    return data


def is_nonempty(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, str):
        return bool(value.strip())
    if isinstance(value, (list, tuple, set, dict)):
        return bool(value)
    return True


def has_evidence(item: dict[str, Any]) -> bool:
    for key in EVIDENCE_KEYS:
        if key in item and is_nonempty(item[key]):
            return True
    return False


def item_ready(item: Any) -> tuple[bool, str]:
    if not isinstance(item, dict):
        return False, "must be an object with status and evidence"
    state = str(item.get("status", item.get("state", ""))).strip().lower()
    if state not in READY_STATES:
        return False, f"status is {state or 'missing'}"
    if item.get("synthetic_only") is True or item.get("fixture_only") is True:
        return False, "evidence is marked synthetic-only or fixture-only"
    if not has_evidence(item):
        return False, "evidence object is missing"
    return True, "ready"


def closure_asserted(phase: dict[str, Any]) -> bool:
    for field in CLOSURE_FIELDS:
        value = phase.get(field)
        if value is True:
            return True
        if isinstance(value, str):
            lowered = value.strip().lower()
            if lowered in {"complete", "closed", "go_claim", "scientific_complete"}:
                return True
    return False


def normalize_phases(data: dict[str, Any], blockers: list[str]) -> dict[str, dict[str, Any]]:
    raw_phases = data.get("phases", {})
    if not isinstance(raw_phases, dict):
        blockers.append("phases must be an object keyed by phase number")
        return {}

    normalized: dict[str, dict[str, Any]] = {}
    for raw_key, value in raw_phases.items():
        key = phase_key(raw_key)
        if key is None:
            blockers.append(f"unparseable phase key: {raw_key}")
            continue
        if key not in PHASES:
            blockers.append(f"out-of-scope phase present: phase{key}")
            continue
        if not isinstance(value, dict):
            blockers.append(f"phase{key} must be an object")
            continue
        normalized[key] = value

    for key in PHASES:
        if key not in normalized:
            blockers.append(f"missing phase{key} checklist")
    return normalized


def check_scope(data: dict[str, Any], blockers: list[str]) -> None:
    raw_scope = data.get("phase_scope", data.get("scope"))
    if raw_scope is None:
        return
    if isinstance(raw_scope, str):
        scope_values: list[Any] = [raw_scope]
    elif isinstance(raw_scope, list):
        scope_values = raw_scope
    else:
        blockers.append("phase_scope must be a string or list")
        return
    parsed = [phase_key(value) for value in scope_values]
    missing_parse = [
        str(value)
        for value, key in zip(scope_values, parsed)
        if key is None
    ]
    for value in missing_parse:
        blockers.append(f"unparseable phase_scope entry: {value}")
    parsed_set = {key for key in parsed if key is not None}
    for key in parsed_set:
        if key not in PHASES:
            blockers.append(f"out-of-scope phase present: phase{key}")
    for key in PHASES:
        if key not in parsed_set:
            blockers.append(f"phase_scope omits phase{key}")


def check_guardrails(data: dict[str, Any], blockers: list[str]) -> None:
    guardrails = data.get("guardrails")
    if not isinstance(guardrails, dict):
        blockers.append("guardrails object is missing")
        return
    for key in ZERO_GUARDS:
        if guardrails.get(key) != 0:
            blockers.append(f"guardrails.{key} must be 0")
    for key in FALSE_GUARDS:
        if guardrails.get(key) is not False:
            blockers.append(f"guardrails.{key} must be false")


def check_section(
    phase_id: str,
    phase: dict[str, Any],
    section_name: str,
    required_keys: tuple[str, ...],
    blockers: list[str],
) -> bool:
    section = phase.get(section_name)
    if not isinstance(section, dict):
        blockers.append(f"phase{phase_id}.{section_name} section is missing")
        return False

    ok = True
    for key in required_keys:
        ready, reason = item_ready(section.get(key))
        if not ready:
            blockers.append(f"phase{phase_id}.{section_name}.{key}: {reason}")
            ok = False
    return ok


def validate(data: dict[str, Any]) -> dict[str, Any]:
    blockers: list[str] = []
    check_scope(data, blockers)
    phases = normalize_phases(data, blockers)
    check_guardrails(data, blockers)

    tooling_ready: dict[str, bool] = {}
    scientific_ready: dict[str, bool] = {}
    closure_claims: list[str] = []
    unsupported_closure_claims: list[str] = []

    for phase_id in PHASES:
        phase = phases.get(phase_id)
        if phase is None:
            tooling_ready[phase_id] = False
            scientific_ready[phase_id] = False
            continue
        tooling_ready[phase_id] = check_section(
            phase_id, phase, "tooling", TOOLING_KEYS, blockers
        )
        scientific_ready[phase_id] = check_section(
            phase_id, phase, "scientific", SCIENTIFIC_KEYS, blockers
        )
        if closure_asserted(phase):
            closure_claims.append(phase_id)

    for phase_id in closure_claims:
        if not scientific_ready.get(phase_id, False):
            unsupported_closure_claims.append(f"phase{phase_id}")
            blockers.append(
                f"phase{phase_id} declares scientific closure without complete evidence gates"
            )

    all_tooling = all(tooling_ready.get(phase_id, False) for phase_id in PHASES)
    all_scientific = all(scientific_ready.get(phase_id, False) for phase_id in PHASES)

    return {
        "scope": "phase9_10_11",
        "tooling_status": "GO_TOOLING" if all_tooling else "NO_GO_TOOLING",
        "scientific_status": "GO_CLAIM" if all_scientific and not blockers else "NO_GO_CLAIM",
        "unsupported_scientific_closure": unsupported_closure_claims,
        "phase_results": {
            f"phase{phase_id}": {
                "tooling_ready": tooling_ready.get(phase_id, False),
                "scientific_ready": scientific_ready.get(phase_id, False),
                "scientific_closure_asserted": phase_id in closure_claims,
            }
            for phase_id in PHASES
        },
        "blockers": blockers,
    }


def template() -> dict[str, Any]:
    item = {"status": "missing", "evidence": {}}
    return {
        "phase_scope": ["phase9", "phase10", "phase11"],
        "guardrails": {
            "hf_uploads": 0,
            "dataset_downloads": 0,
            "thesis_edits": False,
            "roadmap_edits": False,
            "claim_registry_edits": False,
            "claim55_edits": False,
        },
        "phases": {
            f"phase{phase_id}": {
                "scientific_closure": False,
                "tooling": {key: item for key in TOOLING_KEYS},
                "scientific": {key: item for key in SCIENTIFIC_KEYS},
            }
            for phase_id in PHASES
        },
    }


def main() -> int:
    args = parse_args()
    if args.template:
        print(json.dumps(template(), indent=2, sort_keys=True))
        return 0

    report = validate(load_json(args.checklist))
    report["mode"] = "allow_tooling_only" if args.allow_tooling_only else "require_scientific"
    print(json.dumps(report, indent=2, sort_keys=True))

    if args.allow_tooling_only:
        return (
            0
            if report["tooling_status"] == "GO_TOOLING"
            and not report["unsupported_scientific_closure"]
            else 1
        )
    return 0 if report["scientific_status"] == "GO_CLAIM" else 1


if __name__ == "__main__":
    raise SystemExit(main())

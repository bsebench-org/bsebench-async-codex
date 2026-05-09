#!/usr/bin/env python3
"""Validate Phase 9/10/11 acceptance-gate checklists.

Default mode is intentionally strict: it exits non-zero unless every scientific
evidence gate is present for phases 9, 10, and 11. Use --allow-tooling-only to
accept a sound gate definition while keeping scientific closure blocked.
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
TOOLING_READY_STATES = {"defined", "ok", "pass", "passed", "present", "ready", "validated"}
SCIENTIFIC_READY_STATES = {"ok", "pass", "passed", "present", "ready", "validated"}
ZERO_GUARDS = ("hf_uploads", "dataset_downloads")
FALSE_GUARDS = (
    "thesis_edits",
    "roadmap_edits",
    "claim_registry_edits",
    "claim55_edits",
    "public_comparison_claims",
    "public_benchmark_claims",
)
EVIDENCE_KEYS = {
    "artifact",
    "artifacts",
    "branch",
    "command",
    "commands",
    "commit",
    "criterion",
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
            "Validate a Phase 9/10/11 acceptance checklist. Default mode "
            "requires scientific evidence; --allow-tooling-only only requires "
            "gate/tooling evidence and keeps scientific closure blocked."
        )
    )
    parser.add_argument(
        "checklist",
        nargs="?",
        default="cto/PHASE_9_10_11_ACCEPTANCE_GATE.json",
        help="Checklist JSON path. Use '-' to read stdin.",
    )
    parser.add_argument(
        "--allow-tooling-only",
        action="store_true",
        help=(
            "Exit 0 when the acceptance-gate tooling is valid and scientific "
            "closure is not asserted."
        ),
    )
    parser.add_argument(
        "--template",
        action="store_true",
        help="Print a blank checklist template and exit.",
    )
    return parser.parse_args()


def phase_key(value: Any) -> str | None:
    text = str(value).strip().lower().replace("_", "-")
    match = re.fullmatch(r"(?:phase-?)?([0-9]+)", text)
    if not match:
        return None
    return match.group(1)


def load_json(path: str) -> dict[str, Any]:
    if path == "-":
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
    return any(key in item and is_nonempty(item[key]) for key in EVIDENCE_KEYS)


def item_ready(item: Any, ready_states: set[str]) -> tuple[bool, str]:
    if not isinstance(item, dict):
        return False, "must be an object with status and evidence"
    state = str(item.get("status", item.get("state", ""))).strip().lower()
    if state not in ready_states:
        return False, f"status is {state or 'missing'}"
    if item.get("synthetic_only") is True or item.get("fixture_only") is True:
        return False, "evidence is marked synthetic-only or fixture-only"
    if not has_evidence(item):
        return False, "evidence object is missing"
    return True, "ready"


def scientific_item_ready(item: Any) -> tuple[bool, str]:
    ready, reason = item_ready(item, SCIENTIFIC_READY_STATES)
    if not isinstance(item, dict):
        return ready, reason
    if item.get("blocker_if_missing") is not True:
        return False, "blocker_if_missing must be true"
    return ready, reason


def closure_asserted(phase: dict[str, Any]) -> bool:
    for field in CLOSURE_FIELDS:
        value = phase.get(field)
        if value is True:
            return True
        if isinstance(value, str):
            lowered = value.strip().lower()
            if lowered in {"complete", "closed", "go", "go_claim", "scientific_complete"}:
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
        blockers.append("phase_scope is missing")
        return
    if isinstance(raw_scope, str):
        scope_values: list[Any] = [raw_scope]
    elif isinstance(raw_scope, list):
        scope_values = raw_scope
    else:
        blockers.append("phase_scope must be a string or list")
        return
    parsed = [phase_key(value) for value in scope_values]
    for value, key in zip(scope_values, parsed):
        if key is None:
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


def check_closure_policy(data: dict[str, Any], blockers: list[str]) -> None:
    policy = data.get("closure_policy")
    if not isinstance(policy, dict):
        blockers.append("closure_policy object is missing")
        return
    if policy.get("tooling_can_pass_without_scientific_closure") is not True:
        blockers.append("closure_policy.tooling_can_pass_without_scientific_closure must be true")
    if policy.get("fail_closed_on_missing_scientific_evidence") is not True:
        blockers.append("closure_policy.fail_closed_on_missing_scientific_evidence must be true")
    required = policy.get("scientific_closure_requires")
    if not isinstance(required, list):
        blockers.append("closure_policy.scientific_closure_requires must be a list")
        return
    required_set = {str(item) for item in required}
    expected_set = set(SCIENTIFIC_KEYS)
    if required_set != expected_set:
        missing = sorted(expected_set - required_set)
        extra = sorted(required_set - expected_set)
        blockers.append(
            "closure_policy.scientific_closure_requires must match "
            f"{sorted(expected_set)}; missing={missing} extra={extra}"
        )


def check_section(
    phase_id: str,
    phase: dict[str, Any],
    section_name: str,
    required_keys: tuple[str, ...],
    blockers: list[str],
    *,
    scientific: bool = False,
) -> bool:
    section = phase.get(section_name)
    if not isinstance(section, dict):
        blockers.append(f"phase{phase_id}.{section_name} section is missing")
        return False

    ok = True
    for key in required_keys:
        if scientific:
            ready, reason = scientific_item_ready(section.get(key))
        else:
            ready, reason = item_ready(section.get(key), TOOLING_READY_STATES)
        if not ready:
            blockers.append(f"phase{phase_id}.{section_name}.{key}: {reason}")
            ok = False
    return ok


def validate(data: dict[str, Any]) -> dict[str, Any]:
    blockers: list[str] = []
    check_scope(data, blockers)
    check_guardrails(data, blockers)
    check_closure_policy(data, blockers)
    phases = normalize_phases(data, blockers)

    gate_tooling_ready: dict[str, bool] = {}
    scientific_ready: dict[str, bool] = {}
    closure_claims: list[str] = []
    unsupported_closure_claims: list[str] = []

    for phase_id in PHASES:
        phase = phases.get(phase_id)
        if phase is None:
            gate_tooling_ready[phase_id] = False
            scientific_ready[phase_id] = False
            continue
        gate_tooling_ready[phase_id] = check_section(
            phase_id, phase, "tooling", TOOLING_KEYS, blockers
        )
        scientific_ready[phase_id] = check_section(
            phase_id, phase, "scientific", SCIENTIFIC_KEYS, blockers, scientific=True
        )
        if closure_asserted(phase):
            closure_claims.append(phase_id)

    for phase_id in closure_claims:
        if not scientific_ready.get(phase_id, False):
            unsupported_closure_claims.append(f"phase{phase_id}")
            blockers.append(
                f"phase{phase_id} declares scientific closure without complete evidence gates"
            )

    all_gate_tooling = all(gate_tooling_ready.get(phase_id, False) for phase_id in PHASES)
    all_scientific = all(scientific_ready.get(phase_id, False) for phase_id in PHASES)
    scientific_blockers = [
        blocker
        for blocker in blockers
        if ".scientific." in blocker or "declares scientific closure" in blocker
    ]

    return {
        "scope": "phase9_10_11",
        "acceptance_gate_tooling_status": (
            "GO_ACCEPTANCE_GATE_TOOLING" if all_gate_tooling else "NO_GO_ACCEPTANCE_GATE_TOOLING"
        ),
        "scientific_closure_status": (
            "GO_SCIENTIFIC_CLOSURE"
            if all_scientific and not blockers
            else "NO_GO_SCIENTIFIC_CLOSURE"
        ),
        "unsupported_scientific_closure": unsupported_closure_claims,
        "phase_results": {
            f"phase{phase_id}": {
                "gate_tooling_ready": gate_tooling_ready.get(phase_id, False),
                "scientific_ready": scientific_ready.get(phase_id, False),
                "scientific_closure_asserted": phase_id in closure_claims,
            }
            for phase_id in PHASES
        },
        "blocker_count": len(blockers),
        "scientific_blocker_count": len(scientific_blockers),
        "blockers": blockers,
    }


def template() -> dict[str, Any]:
    tooling_item = {"status": "defined", "evidence": {"criterion": "fill me"}}
    scientific_item = {"status": "missing", "blocker_if_missing": True, "evidence": {}}
    return {
        "schema_version": "phase9_10_11_acceptance_gate/v1",
        "phase_scope": ["phase9", "phase10", "phase11"],
        "guardrails": {
            "hf_uploads": 0,
            "dataset_downloads": 0,
            "thesis_edits": False,
            "roadmap_edits": False,
            "claim_registry_edits": False,
            "claim55_edits": False,
            "public_comparison_claims": False,
            "public_benchmark_claims": False,
        },
        "closure_policy": {
            "tooling_can_pass_without_scientific_closure": True,
            "fail_closed_on_missing_scientific_evidence": True,
            "scientific_closure_requires": list(SCIENTIFIC_KEYS),
        },
        "phases": {
            f"phase{phase_id}": {
                "scientific_closure": False,
                "tooling": {key: tooling_item for key in TOOLING_KEYS},
                "scientific": {key: scientific_item for key in SCIENTIFIC_KEYS},
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
            if report["acceptance_gate_tooling_status"] == "GO_ACCEPTANCE_GATE_TOOLING"
            and not report["unsupported_scientific_closure"]
            else 1
        )
    return 0 if report["scientific_closure_status"] == "GO_SCIENTIFIC_CLOSURE" else 1


if __name__ == "__main__":
    raise SystemExit(main())

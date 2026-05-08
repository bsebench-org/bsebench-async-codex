#!/usr/bin/env python3
"""Validate and render the Phase 9/10/11 merge matrix.

The checker is intentionally conservative: a row with missing cache,
provenance, Tier2, source-ledger, or empirical-run evidence cannot become a
merge-ready row.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


DEFAULT_MATRIX = Path("docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-09.json")

REQUIRED_VALIDATION_ORDER = [
    "scope_lock",
    "branch_metadata",
    "protected_diff",
    "local_cache_provenance_tier2",
    "source_ledger",
    "empirical_run",
    "repo_local_validation",
    "cross_repo_dependency",
    "checkpoint_report",
]

REQUIRED_EVIDENCE_TERMS = {
    "cache": ("cache",),
    "provenance": ("provenance",),
    "tier2": ("tier2", "tier 2"),
    "source_ledger": ("source-ledger", "source ledger", "source_ledger"),
    "empirical_run": ("empirical-run", "empirical run", "empirical_run"),
}

ALLOWED_PHASES = {"P9", "P10", "P11", "P9_10_11"}
ALLOWED_REPOS = {
    "bsebench-async-codex",
    "bsebench-datasets",
    "bsebench-filters",
    "bsebench-runner",
    "bsebench-specs",
    "bsebench-stats",
}
ALLOWED_DECISIONS = {"BLOCKED", "HOLD", "VALIDATE_ONLY"}
EVIDENCE_PRESENT = {"present", "verified"}
FORBIDDEN_PHASE_TEXT = ("phase 12", "phase12", "phase-12", "phase 13", "phase13", "phase-13")


def flatten_text(value: Any) -> str:
    if isinstance(value, dict):
        return " ".join(flatten_text(item) for item in value.values())
    if isinstance(value, list):
        return " ".join(flatten_text(item) for item in value)
    return str(value)


def mentions(value: Any, aliases: tuple[str, ...]) -> bool:
    text = flatten_text(value).lower()
    return any(alias.lower() in text for alias in aliases)


def add_missing(errors: list[str], prefix: str, data: dict[str, Any], keys: tuple[str, ...]) -> None:
    for key in keys:
        if key not in data:
            errors.append(f"{prefix} missing required field: {key}")


def load_matrix(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("matrix root must be a JSON object")
    return data


def validate_policy(matrix: dict[str, Any], errors: list[str]) -> None:
    add_missing(errors, "matrix", matrix, ("scope", "scientific_status", "merge_policy", "validation_order", "rows"))

    if matrix.get("scope") != "Phase 9/10/11":
        errors.append("scope must be exactly 'Phase 9/10/11'")
    if matrix.get("scientific_status") != "NO_GO":
        errors.append("scientific_status must be NO_GO")

    policy = matrix.get("merge_policy")
    if not isinstance(policy, dict):
        errors.append("merge_policy must be an object")
        return

    if policy.get("action") != "do_not_merge":
        errors.append("merge_policy.action must be do_not_merge")
    if policy.get("allow_merge") is True:
        errors.append("merge_policy.allow_merge must not be true")
    if policy.get("commit_subject_prefix") != "GLASSBOX":
        errors.append("merge_policy.commit_subject_prefix must be GLASSBOX")

    required_guardrails = {
        "Co-Authored-By Claude": ("co-authored-by claude", "co-authored-by: claude"),
        "Hugging Face uploads": ("hugging face upload", "hf upload"),
        "dataset downloads": ("dataset download", "downloads"),
        "thesis edits": ("thesis",),
        "roadmap edits": ("roadmap",),
        "claim registry edits": ("claim registry", "claim-registry", "claims/registry"),
        "protected claim edits": ("protected claim", "protected-claim"),
    }
    for label, aliases in required_guardrails.items():
        if not mentions(policy, aliases):
            errors.append(f"merge_policy must mention guardrail: {label}")


def validate_order(matrix: dict[str, Any], errors: list[str]) -> None:
    order = matrix.get("validation_order")
    if not isinstance(order, list) or not order:
        errors.append("validation_order must be a non-empty list")
        return

    ids = [step.get("id") if isinstance(step, dict) else None for step in order]
    if ids != REQUIRED_VALIDATION_ORDER:
        errors.append(
            "validation_order ids must exactly match: " + ", ".join(REQUIRED_VALIDATION_ORDER)
        )

    for idx, step in enumerate(order, start=1):
        if not isinstance(step, dict):
            errors.append(f"validation_order[{idx}] must be an object")
            continue
        add_missing(errors, f"validation_order[{idx}]", step, ("id", "requires", "fail_closed_on"))
        if not step.get("requires"):
            errors.append(f"validation_order[{idx}] requires must not be empty")
        if not step.get("fail_closed_on"):
            errors.append(f"validation_order[{idx}] fail_closed_on must not be empty")

    evidence_text = order
    for key, aliases in REQUIRED_EVIDENCE_TERMS.items():
        if not mentions(evidence_text, aliases):
            errors.append(f"validation_order must mention {key}")


def validate_rows(matrix: dict[str, Any], errors: list[str]) -> None:
    rows = matrix.get("rows")
    if not isinstance(rows, list) or not rows:
        errors.append("rows must be a non-empty list")
        return

    slugs = set()
    for idx, row in enumerate(rows, start=1):
        if not isinstance(row, dict):
            errors.append(f"rows[{idx}] must be an object")
            continue
        slug = row.get("branch_slug")
        if not isinstance(slug, str) or not slug:
            errors.append(f"rows[{idx}] branch_slug must be a non-empty string")
            continue
        if slug in slugs:
            errors.append(f"rows[{idx}] duplicate branch_slug: {slug}")
        slugs.add(slug)

    for idx, row in enumerate(rows, start=1):
        if not isinstance(row, dict):
            continue
        slug = row.get("branch_slug", f"rows[{idx}]")
        prefix = f"row {slug}"
        add_missing(
            errors,
            prefix,
            row,
            (
                "phase",
                "repo",
                "branch_slug",
                "current_decision",
                "merge_action",
                "merge_after",
                "required_evidence",
                "current_evidence",
                "blockers",
                "validation_commands",
            ),
        )

        row_text = flatten_text(row).lower()
        if any(term in row_text for term in FORBIDDEN_PHASE_TEXT):
            errors.append(f"{prefix} references out-of-scope Phase 12/13 work")

        if row.get("phase") not in ALLOWED_PHASES:
            errors.append(f"{prefix} has unsupported phase: {row.get('phase')}")
        if row.get("repo") not in ALLOWED_REPOS:
            errors.append(f"{prefix} has unsupported repo: {row.get('repo')}")
        if row.get("current_decision") not in ALLOWED_DECISIONS:
            errors.append(f"{prefix} invalid current_decision: {row.get('current_decision')}")
        if row.get("merge_action") != "do_not_merge":
            errors.append(f"{prefix} merge_action must be do_not_merge")
        if row.get("merge_ready") is True:
            errors.append(f"{prefix} merge_ready must not be true")

        for field in ("merge_after", "required_evidence", "blockers", "validation_commands"):
            if not isinstance(row.get(field), list) or not row.get(field):
                if field == "merge_after" and row.get(field) == []:
                    continue
                errors.append(f"{prefix} {field} must be a list")

        for dependency in row.get("merge_after", []):
            if dependency not in slugs:
                errors.append(f"{prefix} references unknown dependency: {dependency}")

        evidence_text = [row.get("required_evidence", []), row.get("blockers", [])]
        for key, aliases in REQUIRED_EVIDENCE_TERMS.items():
            if not mentions(evidence_text, aliases):
                errors.append(f"{prefix} required_evidence/blockers must mention {key}")

        current_evidence = row.get("current_evidence")
        if not isinstance(current_evidence, dict):
            errors.append(f"{prefix} current_evidence must be an object")
            continue

        missing_evidence = []
        for key in REQUIRED_EVIDENCE_TERMS:
            status = current_evidence.get(key)
            if status is None:
                errors.append(f"{prefix} missing current_evidence.{key}")
                missing_evidence.append(key)
                continue
            if str(status).lower() not in EVIDENCE_PRESENT:
                missing_evidence.append(key)

        if missing_evidence and row.get("current_decision") != "BLOCKED":
            errors.append(
                f"{prefix} must stay BLOCKED while evidence is missing: {', '.join(missing_evidence)}"
            )


def validate_matrix(matrix: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    validate_policy(matrix, errors)
    validate_order(matrix, errors)
    validate_rows(matrix, errors)
    return errors


def render_markdown(matrix: dict[str, Any]) -> str:
    def cell(value: Any) -> str:
        if isinstance(value, list):
            value = ", ".join(str(item) for item in value) if value else "none"
        return str(value).replace("|", "/")

    lines = [
        "# Phase 9/10/11 Merge Matrix",
        "",
        f"- Scientific status: `{matrix['scientific_status']}`",
        f"- Merge action: `{matrix['merge_policy']['action']}`",
        "- Scope: Phase 9/10/11 only.",
        "",
        "## Validation Order",
        "",
    ]
    for idx, step in enumerate(matrix["validation_order"], start=1):
        lines.append(f"{idx}. `{step['id']}`")
    lines.extend(
        [
            "",
            "## Rows",
            "",
            "| Phase | Branch slug | Repo | Decision | Merge action | Merge after | Primary blockers |",
            "|---|---|---|---|---|---|---|",
        ]
    )
    for row in matrix["rows"]:
        lines.append(
            "| "
            + " | ".join(
                [
                    cell(row["phase"]),
                    cell(row["branch_slug"]),
                    cell(row["repo"]),
                    cell(row["current_decision"]),
                    cell(row["merge_action"]),
                    cell(row["merge_after"]),
                    cell(row["blockers"]),
                ]
            )
            + " |"
        )
    return "\n".join(lines) + "\n"


def render_summary(matrix: dict[str, Any]) -> str:
    rows = matrix["rows"]
    blocked = sum(1 for row in rows if row["current_decision"] == "BLOCKED")
    return (
        "Phase 9/10/11 merge matrix: "
        f"{len(rows)} rows, {blocked} blocked, "
        f"scientific_status={matrix['scientific_status']}, "
        f"action={matrix['merge_policy']['action']}"
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("matrix", nargs="?", type=Path, default=DEFAULT_MATRIX)
    parser.add_argument("--format", choices=("summary", "markdown", "json"), default="summary")
    args = parser.parse_args(argv)

    try:
        matrix = load_matrix(args.matrix)
    except Exception as exc:  # noqa: BLE001
        print(f"[FAIL] could not load matrix: {exc}", file=sys.stderr)
        return 1

    errors = validate_matrix(matrix)
    if errors:
        print("[FAIL] Phase 9/10/11 merge matrix validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    if args.format == "markdown":
        print(render_markdown(matrix), end="")
    elif args.format == "json":
        print(json.dumps(matrix, indent=2, sort_keys=True))
    else:
        print(render_summary(matrix))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

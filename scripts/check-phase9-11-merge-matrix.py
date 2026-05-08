#!/usr/bin/env python3
"""Validate the Phase 9/10/11 merge-matrix artifact."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


DEFAULT_MATRIX = Path("docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-08.md")

REQUIRED_STATUS_TOKENS = (
    "NO_GO_MERGE",
    "NO_GO_EMPIRICAL",
    "NO_GO_CLAIM",
    "NO_GO_PUBLIC",
)

REQUIRED_EVIDENCE_TOKENS = (
    "Tier2",
    "cache/provenance",
    "source-ledger",
    "empirical-run",
)

REQUIRED_OBJECTIVES = (
    "p9-11-anti-claim-audit",
    "p9-11-no-claims-linter",
    "p9-11-local-path-discovery",
    "p9-tier2-profile-cache",
    "p10-tier2-aging-cache",
    "p11-tier2-residual-cache",
    "p9-11-schema-export-audit",
    "p9-11-contract-export-audit",
    "p9-profile-empirical-scheduler",
    "p10-aging-empirical-scheduler",
    "p11-residual-trace-scheduler",
    "p9-11-dryrun-cli-smoke",
    "p9-profile-verdict-inputs",
    "p10-aging-verdict-inputs",
    "p11-residual-verdict-inputs",
    "p9-11-checkpoint-report",
    "p9-11-merge-matrix",
    "p9-11-acceptance-gate",
)

LATER_PHASE_RE = re.compile(r"\b[Pp]hase[- _]?(?:1[2-9]|[2-9][0-9])\b|phase[-_](?:1[2-9]|[2-9][0-9])")
UNSUPPORTED_GREENLIGHT_RE = re.compile(r"(?<!NO_)GO_CLAIM|(?<!NO_)GO_PUBLIC|MERGE_READY")


def validate(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    errors: list[str] = []

    if "Directive: Do not merge from this document." not in text:
        errors.append("missing explicit do-not-merge directive")

    for token in REQUIRED_STATUS_TOKENS:
        if token not in text:
            errors.append(f"missing status token: {token}")

    for token in REQUIRED_EVIDENCE_TOKENS:
        if token not in text:
            errors.append(f"missing evidence token: {token}")

    for objective in REQUIRED_OBJECTIVES:
        if f"`{objective}`" not in text:
            errors.append(f"missing objective row: {objective}")

    if LATER_PHASE_RE.search(text):
        errors.append("matrix references a later phase")

    if UNSUPPORTED_GREENLIGHT_RE.search(text):
        errors.append("matrix contains an unsupported greenlight token")

    if "IN_PROGRESS_THIS_BRANCH" not in text:
        errors.append("missing current-branch state marker")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("matrix", nargs="?", default=DEFAULT_MATRIX, type=Path)
    args = parser.parse_args()

    if not args.matrix.is_file():
        print(f"missing matrix file: {args.matrix}", file=sys.stderr)
        return 2

    errors = validate(args.matrix)
    if errors:
        for error in errors:
            print(f"[FAIL] {error}", file=sys.stderr)
        return 1

    print(f"[OK] {args.matrix} passed Phase 9/10/11 merge-matrix checks")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

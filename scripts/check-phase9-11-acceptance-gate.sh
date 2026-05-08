#!/usr/bin/env bash
# Validate the Phase 9/10/11 acceptance gate checklist.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKLIST="$REPO_ROOT/cto/PHASE_9_10_11_ACCEPTANCE_GATE.json"

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-acceptance-gate.sh [--checklist FILE]

Validates the Phase 9/10/11 acceptance checklist. The check separates tooling
criteria from scientific closure and fails if any phase is marked open for
scientific closure while required evidence remains missing.
USAGE
}

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --checklist)
      CHECKLIST="${2:-}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ -z "$CHECKLIST" || ! -f "$CHECKLIST" ]] ; then
  echo "Error: checklist not found: $CHECKLIST" >&2
  exit 2
fi

python3 - "$CHECKLIST" <<'PY'
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

path = Path(sys.argv[1])

EXPECTED_PHASES = [9, 10, 11]
REQUIRED_EVIDENCE = {
    "local_cache_readiness",
    "provenance_identity",
    "tier2_source_files",
    "source_ledger",
    "empirical_run_artifacts",
    "finite_metric_outputs",
    "independent_replay_or_validation",
}
REQUIRED_TRUE_GUARDRAILS = {
    "fail_closed",
    "separate_tooling_from_scientific_closure",
}
REQUIRED_FALSE_GUARDRAILS = {
    "uploads_allowed",
    "dataset_downloads_allowed",
    "thesis_edits_allowed",
    "roadmap_edits_allowed",
    "claim_registry_edits_allowed",
    "protected_claim_target_edits_allowed",
    "public_comparison_claims_allowed",
    "public_benchmark_claims_allowed",
}

errors: list[str] = []


def add_error(location: str, message: str) -> None:
    errors.append(f"{location}: {message}")


def require_mapping(value: Any, location: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        add_error(location, "must be an object")
        return {}
    return value


def require_list(value: Any, location: str) -> list[Any]:
    if not isinstance(value, list):
        add_error(location, "must be a list")
        return []
    return value


try:
    payload = json.loads(path.read_text(encoding="utf-8"))
except json.JSONDecodeError as exc:
    add_error(str(path), f"invalid JSON: {exc}")
    payload = {}

root = require_mapping(payload, "$")

if root.get("schema_version") != 1:
    add_error("$.schema_version", "must be 1")

scope = require_mapping(root.get("scope"), "$.scope")
if scope.get("included_phases") != EXPECTED_PHASES:
    add_error("$.scope.included_phases", "must be exactly [9, 10, 11]")
if scope.get("excluded_later_phases") is not True:
    add_error("$.scope.excluded_later_phases", "must be true")
if scope.get("status") != "gate_definition_only":
    add_error("$.scope.status", "must be gate_definition_only")

guardrails = require_mapping(root.get("global_guardrails"), "$.global_guardrails")
for key in sorted(REQUIRED_TRUE_GUARDRAILS):
    if guardrails.get(key) is not True:
        add_error(f"$.global_guardrails.{key}", "must be true")
for key in sorted(REQUIRED_FALSE_GUARDRAILS):
    if guardrails.get(key) is not False:
        add_error(f"$.global_guardrails.{key}", "must be false")

declared_evidence = set(require_list(root.get("scientific_required_evidence"), "$.scientific_required_evidence"))
if declared_evidence != REQUIRED_EVIDENCE:
    missing = sorted(REQUIRED_EVIDENCE - declared_evidence)
    extra = sorted(declared_evidence - REQUIRED_EVIDENCE)
    add_error("$.scientific_required_evidence", f"must match required evidence set; missing={missing} extra={extra}")

tooling_acceptance = require_mapping(root.get("tooling_acceptance"), "$.tooling_acceptance")
if tooling_acceptance.get("status") != "criteria_defined":
    add_error("$.tooling_acceptance.status", "must be criteria_defined")
tooling_requires = require_list(tooling_acceptance.get("requires"), "$.tooling_acceptance.requires")
if len(tooling_requires) < 4:
    add_error("$.tooling_acceptance.requires", "must contain at least four criteria")

phases = require_list(root.get("phases"), "$.phases")
phase_ids = [phase.get("phase") for phase in phases if isinstance(phase, dict)]
if phase_ids != EXPECTED_PHASES:
    add_error("$.phases", "must contain phases 9, 10, and 11 in order")

scientific_no_go = 0
missing_evidence_items = 0

for idx, phase_value in enumerate(phases):
    location = f"$.phases[{idx}]"
    phase = require_mapping(phase_value, location)
    phase_id = phase.get("phase")
    if phase_id not in EXPECTED_PHASES:
        add_error(f"{location}.phase", "must be one of 9, 10, or 11")
    if isinstance(phase_id, int) and phase_id >= 12:
        add_error(f"{location}.phase", "must not include later phases")

    tooling_gate = require_mapping(phase.get("tooling_gate"), f"{location}.tooling_gate")
    if tooling_gate.get("status") != "criteria_defined":
        add_error(f"{location}.tooling_gate.status", "must be criteria_defined")
    required_tooling = require_list(tooling_gate.get("required_tooling"), f"{location}.tooling_gate.required_tooling")
    if len(required_tooling) < 3:
        add_error(f"{location}.tooling_gate.required_tooling", "must contain at least three entries")

    evidence = require_mapping(phase.get("evidence"), f"{location}.evidence")
    missing_for_phase: list[str] = []
    for evidence_key in sorted(REQUIRED_EVIDENCE):
        item = require_mapping(evidence.get(evidence_key), f"{location}.evidence.{evidence_key}")
        status = item.get("status")
        if status not in {"missing", "present"}:
            add_error(f"{location}.evidence.{evidence_key}.status", "must be missing or present")
        if item.get("required_for") != "scientific_closure":
            add_error(f"{location}.evidence.{evidence_key}.required_for", "must be scientific_closure")
        if item.get("blocker_if_missing") is not True:
            add_error(f"{location}.evidence.{evidence_key}.blocker_if_missing", "must be true")
        if status != "present":
            missing_for_phase.append(evidence_key)

    missing_evidence_items += len(missing_for_phase)
    closure = require_mapping(phase.get("scientific_closure"), f"{location}.scientific_closure")
    closure_status = closure.get("status")
    if closure_status == "NO_GO":
        scientific_no_go += 1
    if missing_for_phase and closure_status != "NO_GO":
        add_error(
            f"{location}.scientific_closure.status",
            f"cannot be {closure_status!r} while required evidence is missing: {', '.join(missing_for_phase)}",
        )
    if not missing_for_phase and closure_status == "NO_GO":
        add_error(f"{location}.scientific_closure.status", "must not remain NO_GO when all required evidence is present")

if errors:
    print("Phase 9/10/11 acceptance checklist validation failed:", file=sys.stderr)
    for error in errors:
        print(f"  [FAIL] {error}", file=sys.stderr)
    sys.exit(1)

print(
    "Phase 9/10/11 acceptance checklist valid: "
    f"phases={len(phases)} scientific_no_go={scientific_no_go} "
    f"missing_evidence_items={missing_evidence_items}"
)
PY

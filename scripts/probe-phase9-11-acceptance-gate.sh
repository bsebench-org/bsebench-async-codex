#!/usr/bin/env bash
# Fixture checks for the Phase 9/10/11 acceptance checklist validator.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"
CHECKLIST="$REPO_ROOT/cto/PHASE_9_10_11_ACCEPTANCE_GATE.json"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@" 2>&1)" ; then
    echo "FAIL: $name expected success" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<< "$output" ; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

require_failure_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output
  local status=0

  output="$("$@" 2>&1)" || status=$?
  if [[ "$status" -eq 0 ]] ; then
    echo "FAIL: $name expected failure" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<< "$output" ; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

mutated_copy() {
  local name="$1"
  local mutation="$2"
  local path="$tmp_root/$name.json"

  cp "$CHECKLIST" "$path"
  python3 - "$path" "$mutation" <<'PY'
from __future__ import annotations

import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
mutation = sys.argv[2]
payload = json.loads(path.read_text(encoding="utf-8"))

if mutation == "scientific_go_with_missing_evidence":
    payload["phases"][0]["scientific_closure"]["status"] = "GO"
elif mutation == "later_phase_scope":
    payload["scope"]["included_phases"] = [9, 10, 11, 12]
elif mutation == "missing_source_ledger_requirement":
    payload["scientific_required_evidence"].remove("source_ledger")
elif mutation == "external_side_effects_allowed":
    payload["global_guardrails"]["uploads_allowed"] = True
elif mutation == "missing_evidence_not_blocking":
    payload["phases"][1]["evidence"]["local_cache_readiness"]["blocker_if_missing"] = False
else:
    raise SystemExit(f"unknown mutation: {mutation}")

path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n", encoding="utf-8")
PY
  printf '%s\n' "$path"
}

valid_gate() {
  bash "$CHECK" --checklist "$CHECKLIST"
}

scientific_go_with_missing_evidence() {
  local path
  path="$(mutated_copy scientific-go scientific_go_with_missing_evidence)"
  bash "$CHECK" --checklist "$path"
}

later_phase_scope() {
  local path
  path="$(mutated_copy later-phase later_phase_scope)"
  bash "$CHECK" --checklist "$path"
}

missing_source_ledger_requirement() {
  local path
  path="$(mutated_copy missing-source-ledger missing_source_ledger_requirement)"
  bash "$CHECK" --checklist "$path"
}

external_side_effects_allowed() {
  local path
  path="$(mutated_copy external-side-effects external_side_effects_allowed)"
  bash "$CHECK" --checklist "$path"
}

missing_evidence_not_blocking() {
  local path
  path="$(mutated_copy missing-evidence-not-blocking missing_evidence_not_blocking)"
  bash "$CHECK" --checklist "$path"
}

require_success_contains \
  "valid checklist remains fail-closed" \
  "scientific_no_go=3 missing_evidence_items=21" \
  valid_gate

require_failure_contains \
  "scientific closure cannot open with missing evidence" \
  "cannot be 'GO' while required evidence is missing" \
  scientific_go_with_missing_evidence

require_failure_contains \
  "later phase scope is rejected" \
  "must be exactly [9, 10, 11]" \
  later_phase_scope

require_failure_contains \
  "source-ledger evidence is required" \
  "missing=['source_ledger']" \
  missing_source_ledger_requirement

require_failure_contains \
  "external data side effects stay disabled" \
  "$.global_guardrails.uploads_allowed: must be false" \
  external_side_effects_allowed

require_failure_contains \
  "missing evidence remains blocking" \
  "$.phases[1].evidence.local_cache_readiness.blocker_if_missing: must be true" \
  missing_evidence_not_blocking

echo "PASS: Phase 9/10/11 acceptance gate fixtures passed ($passes checks)."

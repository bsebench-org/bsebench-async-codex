#!/usr/bin/env bash
# Fixture checks for the Phase 9/10/11 merge matrix validator.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$ROOT/scripts/check_phase9_11_merge_matrix.py"
MATRIX="$ROOT/docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-09.json"

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

mutate_fixture() {
  local dest="$1"
  local mutation="$2"
  python3 - "$MATRIX" "$dest" "$mutation" <<'PY'
import json
import sys
from pathlib import Path

source, dest, mutation = sys.argv[1:]
data = json.loads(Path(source).read_text(encoding="utf-8"))
exec(mutation, {"data": data})
Path(dest).write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")
PY
}

require_success_contains \
  "canonical matrix summary" \
  "action=do_not_merge" \
  python3 "$CHECK" "$MATRIX"

require_success_contains \
  "canonical matrix markdown render" \
  "phase-9-final-verdict" \
  python3 "$CHECK" "$MATRIX" --format markdown

bad_policy="$tmp_root/bad-policy.json"
mutate_fixture "$bad_policy" 'data["merge_policy"]["action"] = "merge"'
require_failure_contains \
  "merge policy must fail closed" \
  "merge_policy.action must be do_not_merge" \
  python3 "$CHECK" "$bad_policy"

bad_decision="$tmp_root/bad-decision.json"
mutate_fixture "$bad_decision" 'data["rows"][0]["current_decision"] = "GO"'
require_failure_contains \
  "ready decision rejected" \
  "invalid current_decision" \
  python3 "$CHECK" "$bad_decision"

bad_missing_source_ledger="$tmp_root/bad-missing-source-ledger.json"
mutate_fixture "$bad_missing_source_ledger" 'del data["rows"][0]["current_evidence"]["source_ledger"]'
require_failure_contains \
  "missing source-ledger evidence rejected" \
  "missing current_evidence.source_ledger" \
  python3 "$CHECK" "$bad_missing_source_ledger"

bad_hold="$tmp_root/bad-hold.json"
mutate_fixture "$bad_hold" 'data["rows"][0]["current_decision"] = "HOLD"'
require_failure_contains \
  "non-blocked row with missing evidence rejected" \
  "must stay BLOCKED while evidence is missing" \
  python3 "$CHECK" "$bad_hold"

bad_phase="$tmp_root/bad-phase.json"
mutate_fixture "$bad_phase" 'data["rows"][0]["phase"] = "P12"'
require_failure_contains \
  "out-of-scope phase rejected" \
  "unsupported phase" \
  python3 "$CHECK" "$bad_phase"

bad_order="$tmp_root/bad-order.json"
mutate_fixture "$bad_order" 'data["validation_order"] = list(reversed(data["validation_order"]))'
require_failure_contains \
  "validation order is fixed" \
  "validation_order ids must exactly match" \
  python3 "$CHECK" "$bad_order"

echo "PASS: Phase 9/10/11 merge matrix fixtures passed ($passes checks)."

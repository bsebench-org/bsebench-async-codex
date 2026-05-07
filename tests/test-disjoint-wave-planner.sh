#!/usr/bin/env bash
# Focused fixture tests for scripts/plan-disjoint-wave.sh.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLANNER="$ROOT_DIR/scripts/plan-disjoint-wave.sh"
FIXTURES="$ROOT_DIR/tests/fixtures/disjoint-wave"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/bsebench-disjoint-wave-test.XXXXXX")"

trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"

  if ! grep -Fq "$needle" "$file" ; then
    echo "---- $file ----" >&2
    cat "$file" >&2
    fail "$label: missing [$needle]"
  fi
}

clean_out="$TMP_DIR/clean.out"
bash "$PLANNER" --dry-run --manifest "$FIXTURES/clean.tsv" > "$clean_out" 2>&1
assert_contains "$clean_out" "DRY-RUN: no phases queued and no files modified." "clean dry-run banner"
assert_contains "$clean_out" "[OK] disjoint wave plan accepted: 3 entries, 7 write-set item(s)." "clean acceptance"

conflict_out="$TMP_DIR/conflict.out"
if bash "$PLANNER" --dry-run "$FIXTURES/conflict.tsv" > "$conflict_out" 2>&1 ; then
  cat "$conflict_out" >&2
  fail "conflict fixture unexpectedly passed"
fi
assert_contains "$conflict_out" "WRITE-SET CONFLICT" "conflict detection"
assert_contains "$conflict_out" "universal-runner-estimator-plugin-contract:src/bsebench_runner/adapters overlaps universal-runner-submission-smoke:src/bsebench_runner/adapters/submission.py" "conflict detail"

protected_out="$TMP_DIR/protected.out"
if bash "$PLANNER" --dry-run "$FIXTURES/protected.tsv" > "$protected_out" 2>&1 ; then
  cat "$protected_out" >&2
  fail "protected fixture unexpectedly passed"
fi
assert_contains "$protected_out" "protected claim registry path: claims/registry.yaml" "protected path detection"

echo "disjoint wave planner fixture tests passed"

#!/usr/bin/env bash
# test-source-ledger-comparability.sh - fixture probes for source ledger rows.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKER="$REPO_ROOT/scripts/check-source-ledger-comparability.sh"
FIXTURE_DIR="$REPO_ROOT/tests/fixtures/source-ledger-comparability"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local label="$3"

  if [[ "$haystack" != *"$needle"* ]] ; then
    printf '%s\n' "$haystack" >&2
    fail "$label: missing [$needle]"
  fi
}

run_pass() {
  local label="$1"
  local file="$2"
  local expected_summary="$3"
  local output

  output="$("$CHECKER" "$file" 2>&1)"
  printf '%s\n' "$output"
  assert_contains "$output" "$expected_summary" "$label summary"
  assert_contains "$output" "incomplete=0" "$label completeness"
}

run_expected_fail() {
  local label="$1"
  local file="$2"
  local output

  if output="$("$CHECKER" "$file" 2>&1)" ; then
    printf '%s\n' "$output" >&2
    fail "$label: expected checker failure"
  fi
  printf '%s\n' "$output"
  assert_contains "$output" "[INCOMPLETE]" "$label incomplete marker"
  assert_contains "$output" "comparison incomplete" "$label incomplete reason"
}

run_pass \
  "comparable row" \
  "$FIXTURE_DIR/pass-comparable.json" \
  "entries=1 comparable=1 partial=0 not_comparable=0 incomplete=0"

run_pass \
  "partial row" \
  "$FIXTURE_DIR/pass-partial.json" \
  "entries=1 comparable=0 partial=1 not_comparable=0 incomplete=0"

run_pass \
  "not-comparable row" \
  "$FIXTURE_DIR/pass-not-comparable.json" \
  "entries=1 comparable=0 partial=0 not_comparable=1 incomplete=0"

run_expected_fail \
  "missing-required-field row" \
  "$FIXTURE_DIR/fail-missing-required-fields.json"

missing_output="$("$CHECKER" "$FIXTURE_DIR/fail-missing-required-fields.json" 2>&1 || true)"
for field in stable_url_or_doi retrieval_date metric dataset split method reported_value bsebench_frozen_value comparability_caveat ; do
  assert_contains "$missing_output" "$field" "missing-required-field probe"
done

multi_output="$(
  "$CHECKER" \
    "$FIXTURE_DIR/pass-comparable.json" \
    "$FIXTURE_DIR/pass-partial.json" \
    "$FIXTURE_DIR/pass-not-comparable.json" \
    2>&1
)"
printf '%s\n' "$multi_output"
assert_contains "$multi_output" "comparable=1 partial=1 not_comparable=1 incomplete=0" "combined positive probe"

echo "Source-ledger comparability fixture checks passed."

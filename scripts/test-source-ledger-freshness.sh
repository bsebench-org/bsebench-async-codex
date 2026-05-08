#!/usr/bin/env bash
# test-source-ledger-freshness.sh - synthetic fixture probes for source-ledger freshness.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKER="$REPO_ROOT/scripts/check-source-ledger-freshness.sh"
FIXTURE_DIR="$REPO_ROOT/tests/fixtures/source-ledger-freshness"
TODAY="2026-05-08"
MAX_AGE_DAYS=365

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

  output="$("$CHECKER" --today "$TODAY" --max-age-days "$MAX_AGE_DAYS" "$file" 2>&1)"
  printf '%s\n' "$output"
  assert_contains "$output" "$expected_summary" "$label summary"
  assert_contains "$output" "stale=0 invalid=0" "$label freshness"
}

run_expected_fail() {
  local label="$1"
  local file="$2"
  local expected_marker="$3"
  local expected_reason="$4"
  local output

  if output="$("$CHECKER" --today "$TODAY" --max-age-days "$MAX_AGE_DAYS" "$file" 2>&1)" ; then
    printf '%s\n' "$output" >&2
    fail "$label: expected checker failure"
  fi
  printf '%s\n' "$output"
  assert_contains "$output" "$expected_marker" "$label marker"
  assert_contains "$output" "$expected_reason" "$label reason"
}

run_pass \
  "comparable row" \
  "$FIXTURE_DIR/pass-comparable.json" \
  "entries=1 comparable=1 partial=0 not_comparable=0 stale=0 invalid=0"

run_pass \
  "partial row" \
  "$FIXTURE_DIR/pass-partial.json" \
  "entries=1 comparable=0 partial=1 not_comparable=0 stale=0 invalid=0"

run_pass \
  "not-comparable row" \
  "$FIXTURE_DIR/pass-not-comparable.json" \
  "entries=1 comparable=0 partial=0 not_comparable=1 stale=0 invalid=0"

run_expected_fail \
  "stale row" \
  "$FIXTURE_DIR/fail-stale.json" \
  "[STALE]" \
  "class=stale"

run_expected_fail \
  "future-dated row" \
  "$FIXTURE_DIR/fail-future-dated.json" \
  "[INVALID]" \
  "future_retrieval_date"

run_expected_fail \
  "malformed-date row" \
  "$FIXTURE_DIR/fail-malformed-date.json" \
  "[INVALID]" \
  "retrieval_date_format"

run_expected_fail \
  "comparable unknown required field row" \
  "$FIXTURE_DIR/fail-comparable-unknown-field.json" \
  "[INVALID]" \
  "comparable_unknown_preprocessing_or_run_condition"

run_expected_fail \
  "missing-required-field rows" \
  "$FIXTURE_DIR/fail-missing-required-fields.json" \
  "[INVALID]" \
  "missing_or_invalid"

missing_output="$("$CHECKER" --today "$TODAY" --max-age-days "$MAX_AGE_DAYS" "$FIXTURE_DIR/fail-missing-required-fields.json" 2>&1 || true)"
for field in stable_url_or_doi retrieval_date metric dataset split bsebench_frozen_value comparability_caveat ; do
  assert_contains "$missing_output" "$field" "missing-required-field probe"
done

multi_output="$(
  "$CHECKER" \
    --today "$TODAY" \
    --max-age-days "$MAX_AGE_DAYS" \
    "$FIXTURE_DIR/pass-comparable.json" \
    "$FIXTURE_DIR/pass-partial.json" \
    "$FIXTURE_DIR/pass-not-comparable.json" \
    2>&1
)"
printf '%s\n' "$multi_output"
assert_contains "$multi_output" "comparable=1 partial=1 not_comparable=1 stale=0 invalid=0" "combined positive probe"

echo "Source-ledger freshness fixture checks passed."

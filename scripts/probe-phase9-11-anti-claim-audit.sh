#!/usr/bin/env bash
# probe-phase9-11-anti-claim-audit.sh - fixture checks for the Phase 9/10/11 claim guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-phase9-11-anti-claim-audit.sh"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_file() {
  local path="$1"
  local content="$2"

  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$content" > "$path"
}

run_guard() {
  bash "$GUARD" --dry-run "$@" 2>&1
}

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@")" ; then
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

neutral_guardrail() {
  local path="$tmp_root/phase-9-neutral.md"
  write_file "$path" \
"# Phase 9 Neutral Report

Phase 9 remains NO-GO until cache, provenance, Tier2, source-ledger, and empirical-run evidence passes.
No SOTA, novelty, winner, leaderboard, or public-benchmark claim is allowed."
  run_guard "$path"
}

unsupported_closure_claim() {
  local path="$tmp_root/phase-9-closure.md"
  write_file "$path" \
"# Phase 9 Closure Report

Phase 9 is complete and ready for closure."
  run_guard "$path"
}

unsupported_performance_claim() {
  local path="$tmp_root/phase-10-performance.md"
  write_file "$path" \
"# Phase 10 Performance Report

Phase 10 performance is validated across the benchmark."
  run_guard "$path"
}

forbidden_public_claim() {
  local path="$tmp_root/phase-11-public.md"
  write_file "$path" \
"# Phase 11 Public Report

Phase 11 is the leaderboard winner."
  run_guard "$path"
}

supported_closure_claim() {
  local path="$tmp_root/phase-11-supported.md"
  write_file "$path" \
"# Phase 11 Supported Fixture

Phase 11 scientific verdict GO.
Cache evidence passed.
Provenance evidence passed.
Tier2 evidence passed.
Source ledger complete.
Empirical run evidence passed.
Blockers: none."
  run_guard "$path"
}

missing_source_ledger() {
  local path="$tmp_root/phase-11-missing-source-ledger.md"
  write_file "$path" \
"# Phase 11 Missing Evidence Fixture

Phase 11 scientific verdict GO.
Cache evidence passed.
Provenance evidence passed.
Tier2 evidence passed.
Empirical run evidence passed."
  run_guard "$path"
}

unrelated_complete_text() {
  local path="$tmp_root/general-report.md"
  write_file "$path" \
"# General Report

The setup checklist is complete."
  run_guard "$path"
}

require_success_contains \
  "neutral guardrail wording" \
  "Phase 9/10/11 anti-claim audit passed" \
  neutral_guardrail

require_failure_contains \
  "unsupported closure claim" \
  "unsupported closure/performance claim" \
  unsupported_closure_claim

require_failure_contains \
  "unsupported performance claim" \
  "unsupported closure/performance claim" \
  unsupported_performance_claim

require_failure_contains \
  "forbidden public claim wording" \
  "forbidden SOTA/novelty/winner/leaderboard/public-benchmark wording" \
  forbidden_public_claim

require_success_contains \
  "supported closure claim with evidence markers" \
  "closure/performance claim includes required evidence markers" \
  supported_closure_claim

require_failure_contains \
  "missing source-ledger evidence marker" \
  "missing evidence markers: source-ledger" \
  missing_source_ledger

require_success_contains \
  "unrelated completion text skipped" \
  "No matching Phase 9/10/11 text files found." \
  unrelated_complete_text

echo "PASS: Phase 9/10/11 anti-claim fixtures passed ($passes checks)."

#!/usr/bin/env bash
# probe-phase9-11-anti-claim-audit.sh - fixture checks for Phase 9/10/11 claim guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-phase9-11-anti-claim-audit.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

init_repo() {
  local repo="$1"

  mkdir -p "$repo"
  git -C "$repo" init -q
  git -C "$repo" config user.name "Fixture"
  git -C "$repo" config user.email "fixture@example.invalid"
  printf 'base\n' > "$repo/README.md"
  git -C "$repo" add README.md
  git -C "$repo" commit -q -m "base"
}

run_git_guard() {
  local repo="$1"
  bash "$GUARD" --dry-run --repo "$repo" --base HEAD~1 --head HEAD 2>&1
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

commit_file() {
  local repo="$1"
  local path="$2"
  local content="$3"

  mkdir -p "$(dirname "$repo/$path")"
  printf '%s\n' "$content" > "$repo/$path"
  git -C "$repo" add "$path"
  git -C "$repo" commit -q -m "fixture change"
}

neutral_no_go_language() {
  local repo="$tmp_root/neutral-no-go"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-11-status.md" \
    "Phase 9/10/11 status: NO-GO until cache/provenance/Tier2/source-ledger/empirical-run evidence passes."
  run_git_guard "$repo"
}

unsupported_closure_claim() {
  local repo="$tmp_root/unsupported-closure"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-closeout.md" \
    "Phase 9 is complete and closed for scientific closure."
  run_git_guard "$repo"
}

unsupported_performance_claim() {
  local repo="$tmp_root/unsupported-performance"
  init_repo "$repo"
  commit_file "$repo" "reports/phase-10-summary.md" \
    "Phase 10 performance improved RMSE versus the baseline."
  run_git_guard "$repo"
}

forbidden_public_benchmark_claim() {
  local repo="$tmp_root/forbidden-public-benchmark"
  init_repo "$repo"
  commit_file "$repo" "reports/phase-11-summary.md" \
    "Phase 11 is the SOTA winner on the public benchmark leaderboard."
  run_git_guard "$repo"
}

supported_evidence_markers() {
  local repo="$tmp_root/supported-evidence"
  init_repo "$repo"
  commit_file "$repo" "reports/phase-11-evidence.md" \
    "Phase 11 closure ready: cache verified; provenance verified; Tier2 source-ledger empirical-run evidence present."
  run_git_guard "$repo"
}

validation_only_tooling() {
  local repo="$tmp_root/validation-tooling"
  init_repo "$repo"
  commit_file "$repo" "scripts/check-phase9-11-anti-claim-audit.sh" \
    "# fixture mentions Phase 9 complete, SOTA winner, and performance improved inside validation tooling."
  run_git_guard "$repo"
}

paths_without_diff() {
  local paths="$tmp_root/paths.txt"
  printf '%s\n' "reports/phase9-11-status.md" > "$paths"
  bash "$GUARD" --dry-run --paths "$paths" 2>&1
}

require_success_contains \
  "neutral no-go guardrail language" \
  "[ALLOWED] reports/phase9-11-status.md -- Phase 9/10/11 text has no unsupported closure/performance claim" \
  neutral_no_go_language

require_failure_contains \
  "unsupported closure claim" \
  "[REVIEW_REQUIRED] reports/phase9-closeout.md -- unsupported closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  unsupported_closure_claim

require_failure_contains \
  "unsupported performance claim" \
  "[REVIEW_REQUIRED] reports/phase-10-summary.md -- unsupported closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  unsupported_performance_claim

require_failure_contains \
  "forbidden public benchmark claim" \
  "[BLOCKED] reports/phase-11-summary.md -- forbidden SOTA/novelty/winner/leaderboard/public benchmark claim" \
  forbidden_public_benchmark_claim

require_success_contains \
  "supported evidence markers" \
  "[ALLOWED] reports/phase-11-evidence.md -- closure/performance language has required positive evidence markers" \
  supported_evidence_markers

require_success_contains \
  "validation-only tooling" \
  "[ALLOWED] scripts/check-phase9-11-anti-claim-audit.sh -- validation-only Phase 9/10/11 claim-audit tooling or fixture" \
  validation_only_tooling

require_failure_contains \
  "phase paths without diff fail closed" \
  "[REVIEW_REQUIRED] reports/phase9-11-status.md -- Phase 9/10/11 path supplied without diff text or evidence" \
  paths_without_diff

echo "PASS: Phase 9/10/11 anti-claim audit fixtures passed ($passes checks)."

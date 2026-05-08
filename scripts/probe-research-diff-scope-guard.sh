#!/usr/bin/env bash
# probe-research-diff-scope-guard.sh - fixture checks for the diff-scope guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-research-diff-scope.sh"

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

allowed_validation_only() {
  local repo="$tmp_root/allowed-validation"
  init_repo "$repo"
  commit_file "$repo" "scripts/check-research-diff-scope.sh" \
    '# Fixture string: SOTA novelty claim_55 appears only inside validation tooling.'
  run_git_guard "$repo"
}

protected_registry() {
  local repo="$tmp_root/protected-registry"
  init_repo "$repo"
  commit_file "$repo" "claims/registry.yaml" "claim_55: verified"
  run_git_guard "$repo"
}

protected_thesis() {
  local repo="$tmp_root/protected-thesis"
  init_repo "$repo"
  commit_file "$repo" "thesis/chapter1.md" "This thesis claim is accepted."
  run_git_guard "$repo"
}

protected_roadmap() {
  local repo="$tmp_root/protected-roadmap"
  init_repo "$repo"
  commit_file "$repo" "docs/RESEARCH-ROADMAP-2026-05-06.md" "roadmap change"
  run_git_guard "$repo"
}

claim55_targeting() {
  local repo="$tmp_root/claim55"
  init_repo "$repo"
  commit_file "$repo" "reports/candidate.md" "claim_target: claim_55"
  run_git_guard "$repo"
}

unsupported_comparison_language() {
  local repo="$tmp_root/unsupported-comparison"
  init_repo "$repo"
  commit_file "$repo" "reports/comparison.md" \
    'This method is SOTA, novel, and a breakthrough over prior work.'
  run_git_guard "$repo"
}

source_ledger_present_comparison() {
  local repo="$tmp_root/source-ledger-present"
  init_repo "$repo"

  mkdir -p "$repo/reports"
  cat > "$repo/reports/comparison.md" <<'COMPARISON'
SOTA comparison draft: the row below is only comparable under the source ledger.
COMPARISON
  cat > "$repo/reports/source-ledger.md" <<'LEDGER'
| source_id | doi_or_url | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
|---|---|---|---|---|---|---|---|---|---|
| fixture-paper | https://doi.org/10.1234/example | 2026-05-08 | MAE SOC percent | CALCE A123 | fixed test profile | 1.20 | 1.30 | partial | synthetic fixture, not a real claim |
LEDGER
  git -C "$repo" add reports/comparison.md reports/source-ledger.md
  git -C "$repo" commit -q -m "comparison with ledger"
  run_git_guard "$repo"
}

changed_file_list_comparison() {
  local paths="$tmp_root/paths.txt"
  printf '%s\n' "reports/sota-comparison.md" > "$paths"
  bash "$GUARD" --dry-run --paths "$paths" 2>&1
}

phase9_closure_without_evidence() {
  local repo="$tmp_root/phase9-closure-without-evidence"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-verdict.md" \
    'Phase 9 is complete, validated, and ready for performance claims.'
  run_git_guard "$repo"
}

phase10_performance_without_evidence() {
  local repo="$tmp_root/phase10-performance-without-evidence"
  init_repo "$repo"
  commit_file "$repo" "reports/phase10-performance.md" \
    'P10 performance improved by 12 percent on the benchmark.'
  run_git_guard "$repo"
}

phase11_with_complete_evidence() {
  local repo="$tmp_root/phase11-with-complete-evidence"
  init_repo "$repo"

  mkdir -p "$repo/reports"
  cat > "$repo/reports/phase11-verdict.md" <<'REPORT'
Phase 11 is complete for this synthetic fixture and reports performance.
REPORT
  cat > "$repo/reports/phase11-evidence.md" <<'EVIDENCE'
# Phase 11 Evidence Bundle Fixture

- cache: local cache hash fixture-cache-sha256
- provenance: fixture manifest identity recorded
- Tier2: fixture Tier2 dataset gate passed
- source_ledger: reports/source-ledger.md
- empirical_run: fixture-run-001
- validation command: bash scripts/replay-fixture.sh
- mismatch_count: 0
EVIDENCE
  git -C "$repo" add reports/phase11-verdict.md reports/phase11-evidence.md
  git -C "$repo" commit -q -m "phase11 fixture with evidence"
  run_git_guard "$repo"
}

phase12_closure_not_in_scope() {
  local repo="$tmp_root/phase12-closure"
  init_repo "$repo"
  commit_file "$repo" "reports/phase12-verdict.md" \
    'Phase 12 is complete in this unrelated fixture.'
  run_git_guard "$repo"
}

public_benchmark_without_ledger() {
  local repo="$tmp_root/public-benchmark-without-ledger"
  init_repo "$repo"
  commit_file "$repo" "reports/public-benchmark.md" \
    'This public benchmark has a clear winner.'
  run_git_guard "$repo"
}

require_success_contains \
  "allowed validation-only change" \
  "[ALLOWED] scripts/check-research-diff-scope.sh -- validation-only guardrail tooling or fixture" \
  allowed_validation_only

require_failure_contains \
  "protected claims registry path" \
  "[BLOCKED] claims/registry.yaml -- protected claims/registry.yaml" \
  protected_registry

require_failure_contains \
  "protected thesis path" \
  "[BLOCKED] thesis/chapter1.md -- protected thesis or manuscript prose" \
  protected_thesis

require_failure_contains \
  "protected roadmap path" \
  "[BLOCKED] docs/RESEARCH-ROADMAP-2026-05-06.md -- protected roadmap file" \
  protected_roadmap

require_failure_contains \
  "claim_55 targeting" \
  "[BLOCKED] reports/candidate.md -- added direct claim_55 targeting" \
  claim55_targeting

require_failure_contains \
  "unsupported SOTA novelty language" \
  "[REVIEW_REQUIRED] reports/comparison.md -- comparison language lacks completed source ledger and comparability table" \
  unsupported_comparison_language

require_success_contains \
  "source-ledger-present comparison" \
  "[ALLOWED] reports/comparison.md -- comparison language with completed source ledger in diff" \
  source_ledger_present_comparison

require_failure_contains \
  "changed-file list comparison without diff" \
  "[REVIEW_REQUIRED] reports/sota-comparison.md -- comparison-like path supplied without diff or source ledger evidence" \
  changed_file_list_comparison

require_failure_contains \
  "Phase 9 closure without evidence" \
  "[REVIEW_REQUIRED] reports/phase9-verdict.md -- Phase 9/10/11 closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  phase9_closure_without_evidence

require_failure_contains \
  "Phase 10 performance without evidence" \
  "[REVIEW_REQUIRED] reports/phase10-performance.md -- Phase 9/10/11 closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  phase10_performance_without_evidence

require_success_contains \
  "Phase 11 with complete evidence" \
  "[ALLOWED] reports/phase11-verdict.md -- Phase 9/10/11 claim language with complete evidence bundle in diff" \
  phase11_with_complete_evidence

require_success_contains \
  "Phase 12 closure outside guard scope" \
  "[ALLOWED] reports/phase12-verdict.md -- ordinary non-protected change" \
  phase12_closure_not_in_scope

require_failure_contains \
  "public benchmark winner without ledger" \
  "[REVIEW_REQUIRED] reports/public-benchmark.md -- comparison language lacks completed source ledger and comparability table" \
  public_benchmark_without_ledger

echo "PASS: research diff-scope guard fixtures passed ($passes checks)."

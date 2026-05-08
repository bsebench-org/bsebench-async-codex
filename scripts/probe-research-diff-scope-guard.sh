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

unsupported_phase911_closure_claim() {
  local repo="$tmp_root/unsupported-phase911-closure"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-11-closeout.md" \
    'Phase 9/10/11 closure is complete; no performance claim is made here.'
  run_git_guard "$repo"
}

phase911_negative_status_allowed() {
  local repo="$tmp_root/phase911-negative-status"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-11-closeout.md" \
    'Phase 9/10/11 is not complete because cache and empirical evidence are missing.'
  run_git_guard "$repo"
}

phase911_evidence_backed_closure_claim() {
  local repo="$tmp_root/phase911-evidence-backed"
  init_repo "$repo"

  mkdir -p "$repo/reports"
  cat > "$repo/reports/phase9-11-closeout.md" <<'REPORT'
Phase 9/10/11 closure is complete for this synthetic guard fixture.
Performance status is constrained to the evidence bundle in this diff.
REPORT
  cat > "$repo/reports/evidence-bundle.md" <<'EVIDENCE'
cache evidence: fixture cache manifest present
provenance evidence: fixture provenance manifest present
Tier2 evidence: fixture Tier2 inventory present
source-ledger evidence: reports/source-ledger.md
empirical-run evidence: fixture empirical run manifest present
EVIDENCE
  cat > "$repo/reports/source-ledger.md" <<'LEDGER'
| source_id | doi_or_url | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
|---|---|---|---|---|---|---|---|---|---|
| fixture-paper | https://doi.org/10.1234/example | 2026-05-08 | MAE SOC percent | CALCE A123 | fixed test profile | 1.20 | 1.30 | partial | synthetic fixture, not a real claim |
LEDGER
  git -C "$repo" add reports/phase9-11-closeout.md reports/evidence-bundle.md reports/source-ledger.md
  git -C "$repo" commit -q -m "phase911 closure with evidence"
  run_git_guard "$repo"
}

changed_file_list_phase911_claim() {
  local paths="$tmp_root/phase911-paths.txt"
  printf '%s\n' "reports/phase9-11-closeout.md" > "$paths"
  bash "$GUARD" --dry-run --paths "$paths" 2>&1
}

changed_file_list_comparison() {
  local paths="$tmp_root/paths.txt"
  printf '%s\n' "reports/sota-comparison.md" > "$paths"
  bash "$GUARD" --dry-run --paths "$paths" 2>&1
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
  "unsupported Phase 9/10/11 closure claim" \
  "[BLOCKED] reports/phase9-11-closeout.md -- Phase 9/10/11 closure/performance claim lacks cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  unsupported_phase911_closure_claim

require_success_contains \
  "negative Phase 9/10/11 status allowed" \
  "[ALLOWED] reports/phase9-11-closeout.md -- ordinary non-protected change" \
  phase911_negative_status_allowed

require_success_contains \
  "evidence-backed Phase 9/10/11 closure claim" \
  "[ALLOWED] reports/phase9-11-closeout.md -- Phase 9/10/11 closure/performance claim with required evidence bundle in diff" \
  phase911_evidence_backed_closure_claim

require_failure_contains \
  "changed-file list Phase 9/10/11 closeout without diff" \
  "[REVIEW_REQUIRED] reports/phase9-11-closeout.md -- Phase 9/10/11 closure/performance-like path supplied without diff or required evidence" \
  changed_file_list_phase911_claim

require_failure_contains \
  "changed-file list comparison without diff" \
  "[REVIEW_REQUIRED] reports/sota-comparison.md -- comparison-like path supplied without diff or source ledger evidence" \
  changed_file_list_comparison

echo "PASS: research diff-scope guard fixtures passed ($passes checks)."

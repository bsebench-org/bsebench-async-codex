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

unsupported_phase911_closure_claim() {
  local repo="$tmp_root/unsupported-phase911-closure"
  init_repo "$repo"
  commit_file "$repo" "reports/phase911-status.md" \
    'Phase 9/10/11 are complete and ready for closure.'
  run_git_guard "$repo"
}

phase911_guardrail_does_not_mask_claim() {
  local repo="$tmp_root/phase911-guardrail-mask"
  init_repo "$repo"
  commit_file "$repo" "reports/phase9-status.md" \
    $'Do not declare Phase 9 complete without evidence.\nPhase 9 is complete.'
  run_git_guard "$repo"
}

validation_fixture_does_not_supply_phase911_evidence() {
  local repo="$tmp_root/phase911-validation-evidence"
  init_repo "$repo"

  mkdir -p "$repo/scripts" "$repo/reports"
  cat > "$repo/scripts/check-research-diff-scope.sh" <<'VALIDATION'
- cache evidence: OK
- provenance evidence: OK
- Tier2 evidence: OK
- source-ledger evidence: OK
- empirical-run evidence: OK

| source_id | doi_or_url | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
|---|---|---|---|---|---|---|---|---|---|
| fixture-paper | https://doi.org/10.1234/example | 2026-05-08 | MAE SOC percent | CALCE A123 | fixed test profile | 1.20 | 1.30 | partial | synthetic fixture, not a real claim |
VALIDATION
  printf '%s\n' "Phase 9 is complete." > "$repo/reports/phase9-status.md"
  git -C "$repo" add scripts/check-research-diff-scope.sh reports/phase9-status.md
  git -C "$repo" commit -q -m "validation evidence fixture"
  run_git_guard "$repo"
}

unsupported_phase911_performance_claim() {
  local repo="$tmp_root/unsupported-phase911-performance"
  init_repo "$repo"
  commit_file "$repo" "reports/phase10-performance.md" \
    'Phase 10 performance improved RMSE and is green.'
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

phase911_claim_with_complete_evidence() {
  local repo="$tmp_root/phase911-evidence-present"
  init_repo "$repo"

  mkdir -p "$repo/reports"
  cat > "$repo/reports/phase911-status.md" <<'STATUS'
Phase 9/10/11 closure status: ready for this fixture audit only.

- cache evidence: OK
- provenance evidence: OK
- Tier2 evidence: OK
- source-ledger evidence: OK
- empirical-run evidence: OK

| source_id | doi_or_url | retrieved_at | metric | dataset | split | reported_value | bsebench_value | comparability | caveat |
|---|---|---|---|---|---|---|---|---|---|
| fixture-paper | https://doi.org/10.1234/example | 2026-05-08 | MAE SOC percent | CALCE A123 | fixed test profile | 1.20 | 1.30 | partial | synthetic fixture, not a real claim |
STATUS
  git -C "$repo" add reports/phase911-status.md
  git -C "$repo" commit -q -m "phase evidence fixture"
  run_git_guard "$repo"
}

changed_file_list_comparison() {
  local paths="$tmp_root/paths.txt"
  printf '%s\n' "reports/sota-comparison.md" > "$paths"
  bash "$GUARD" --dry-run --paths "$paths" 2>&1
}

changed_file_list_phase911_claim() {
  local paths="$tmp_root/paths-phase911.txt"
  printf '%s\n' "reports/phase9-closure-status.md" > "$paths"
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

require_failure_contains \
  "unsupported Phase 9/10/11 closure claim" \
  "[REVIEW_REQUIRED] reports/phase911-status.md -- Phase 9/10/11 closure/performance claim lacks complete cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  unsupported_phase911_closure_claim

require_failure_contains \
  "Phase 9 guardrail does not mask later closure claim" \
  "[REVIEW_REQUIRED] reports/phase9-status.md -- Phase 9/10/11 closure/performance claim lacks complete cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  phase911_guardrail_does_not_mask_claim

require_failure_contains \
  "validation fixture evidence does not support Phase 9 closure claim" \
  "[REVIEW_REQUIRED] reports/phase9-status.md -- Phase 9/10/11 closure/performance claim lacks complete cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  validation_fixture_does_not_supply_phase911_evidence

require_failure_contains \
  "unsupported Phase 9/10/11 performance claim" \
  "[REVIEW_REQUIRED] reports/phase10-performance.md -- Phase 9/10/11 closure/performance claim lacks complete cache/provenance/Tier2/source-ledger/empirical-run evidence" \
  unsupported_phase911_performance_claim

require_success_contains \
  "source-ledger-present comparison" \
  "[ALLOWED] reports/comparison.md -- comparison language with completed source ledger in diff" \
  source_ledger_present_comparison

require_success_contains \
  "Phase 9/10/11 complete evidence present" \
  "[ALLOWED] reports/phase911-status.md -- Phase 9/10/11 closure/performance wording with complete cache/provenance/Tier2/source-ledger/empirical-run evidence in diff" \
  phase911_claim_with_complete_evidence

require_failure_contains \
  "changed-file list comparison without diff" \
  "[REVIEW_REQUIRED] reports/sota-comparison.md -- comparison-like path supplied without diff or source ledger evidence" \
  changed_file_list_comparison

require_failure_contains \
  "changed-file list Phase 9/10/11 closure without diff" \
  "[REVIEW_REQUIRED] reports/phase9-closure-status.md -- Phase 9/10/11 closure/performance-like path supplied without diff evidence" \
  changed_file_list_phase911_claim

echo "PASS: research diff-scope guard fixtures passed ($passes checks)."

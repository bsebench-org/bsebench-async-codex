#!/usr/bin/env bash
# probe-phase9-11-merge-matrix.sh - fixture checks for the merge-matrix guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-phase9-11-merge-matrix.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_matrix_doc() {
  local path="$1"
  local extra="${2:-}"

  mkdir -p "$(dirname "$path")"
  cat > "$path" <<'DOC'
# Phase 9/10/11 Merge Matrix

Scope: Phase 9, Phase 10, and Phase 11 only. Do not merge from this matrix.

## Current Decision

- Tooling merge: `NO_GO_MERGE`.
- Empirical scheduling: `NO_GO_EMPIRICAL`.
- Scientific claim gate: `NO_GO_CLAIM`.

Missing cache, provenance, Tier2, source-ledger, and empirical-run evidence is a blocker.
Every row must cite branch, commit, validation command, artifact, blocker status, clean worktree, dirty worktree handling, and GLASSBOX subject checks.
Minimum validation commands include focused tests, ruff check, format --check, and git diff --check.

## Candidate Branch Matrix

| Repo | Branch |
| --- | --- |
| async | `phase9-11-refill-p9-11-acceptance-gate-20260508T215244+0200` |
| async | `phase9-11-refill-p9-11-anti-claim-audit-20260508T220147+0200` |
| async | `phase9-11-refill-p9-11-checkpoint-report-20260508T220012+0200` |
| async | `phase9-11-refill-p9-11-merge-matrix-20260508T220131+0200` |
| specs | `phase9-11-refill-p9-11-schema-export-audit-20260508T215904+0200` |
| filters | `phase9-11-refill-p9-11-contract-export-audit-20260508T220007+0200` |
| datasets | `phase9-11-refill-p9-tier2-profile-cache-20260508T215254+0200` |
| datasets | `phase9-11-refill-p10-tier2-aging-cache-20260508T215302+0200` |
| datasets | `phase9-11-refill-p11-tier2-residual-cache-20260508T215408+0200` |
| datasets | `phase9-11-refill-p9-11-local-path-discovery-20260508T215013+0200` |
| runner | `phase9-11-refill-p9-profile-empirical-scheduler-20260508T215517+0200` |
| runner | `phase9-11-refill-p10-aging-empirical-scheduler-20260508T215522+0200` |
| runner | `phase9-11-refill-p11-residual-trace-scheduler-20260508T215527+0200` |
| runner | `phase9-11-refill-p9-11-dryrun-cli-smoke-20260508T215025+0200` |
| stats | `phase9-11-refill-p9-11-no-claims-linter-20260508T215035+0200` |
| stats | `phase9-11-refill-p9-profile-verdict-inputs-20260508T215536+0200` |
| stats | `phase9-11-refill-p10-aging-verdict-inputs-20260508T215745+0200` |
| stats | `phase9-11-refill-p11-residual-verdict-inputs-20260508T215755+0200` |
DOC
  if [[ -n "$extra" ]] ; then
    printf '%s\n' "$extra" >> "$path"
  fi
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

valid_matrix() {
  local doc="$tmp_root/docs/PHASE_9_10_11_MERGE_MATRIX_VALID.md"
  write_matrix_doc "$doc"
  bash "$GUARD" --dry-run "$doc"
}

later_phase_scope() {
  local doc="$tmp_root/docs/PHASE_9_10_11_MERGE_MATRIX_LATER.md"
  write_matrix_doc "$doc" "Out of scope row: Phase 12 placeholder."
  bash "$GUARD" --dry-run "$doc"
}

positive_claim_gate() {
  local doc="$tmp_root/docs/PHASE_9_10_11_MERGE_MATRIX_POSITIVE.md"
  write_matrix_doc "$doc" "Scientific claim gate: GO_CLAIM."
  bash "$GUARD" --dry-run "$doc"
}

missing_branch_row() {
  local doc="$tmp_root/docs/PHASE_9_10_11_MERGE_MATRIX_MISSING_BRANCH.md"
  write_matrix_doc "$doc"
  sed -i '/phase9-11-refill-p11-residual-verdict-inputs-20260508T215755+0200/d' "$doc"
  bash "$GUARD" --dry-run "$doc"
}

require_success_contains \
  "valid merge matrix" \
  "Phase 9/10/11 merge-matrix checks passed: 1 checked" \
  valid_matrix

require_failure_contains \
  "later phase scope rejected" \
  "[FAIL] no later-phase scope" \
  later_phase_scope

require_failure_contains \
  "positive claim gate rejected" \
  "[FAIL] no positive claim gate" \
  positive_claim_gate

require_failure_contains \
  "missing branch row rejected" \
  "[FAIL] Phase 11 stats row" \
  missing_branch_row

echo "PASS: Phase 9/10/11 merge-matrix fixtures passed ($passes checks)."

#!/usr/bin/env bash
# probe-phase9-11-acceptance-gate.sh - fixture checks for the acceptance gate guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_gate_doc() {
  local path="$1"
  local extra="${2:-}"

  mkdir -p "$(dirname "$path")"
  cat > "$path" <<'DOC'
# Phase 9/10/11 Acceptance Gate Checklist

Scope: Phase 9, Phase 10, and Phase 11 only.

## Required Axes

- Tooling readiness is separate from empirical readiness.
- Empirical readiness is separate from scientific closure.
- Scientific closure defaults to `NO_GO_CLAIM` without evidence.

## Evidence Fields

Every row must cite branch, commit, validation command, artifact, and blocker status.
Fail-closed blockers include cache, provenance, Tier2, source-ledger, and empirical-run evidence.

## Phase Table

| Phase | Tooling | Empirical | Scientific closure | Blocker |
| --- | --- | --- | --- | --- |
| Phase 9 | NO_GO_MERGE | NO_GO_EMPIRICAL | NO_GO_CLAIM | cache/provenance/Tier2/source-ledger/empirical-run gaps |
| Phase 10 | NO_GO_MERGE | NO_GO_EMPIRICAL | NO_GO_CLAIM | cache/provenance/Tier2/source-ledger/empirical-run gaps |
| Phase 11 | NO_GO_MERGE | NO_GO_EMPIRICAL | NO_GO_CLAIM | cache/provenance/Tier2/source-ledger/empirical-run gaps |

## Decisions

- Tooling merge: `NO_GO_MERGE`.
- Empirical scheduling: `NO_GO_EMPIRICAL`.
- Scientific closure: `NO_GO_CLAIM`.
- Public communication: `NO_GO_PUBLIC`.
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

valid_gate() {
  local doc="$tmp_root/docs/PHASE_9_10_11_ACCEPTANCE_GATE_VALID.md"
  write_gate_doc "$doc"
  bash "$GUARD" --dry-run "$doc"
}

missing_scientific_axis() {
  local doc="$tmp_root/docs/PHASE_9_10_11_ACCEPTANCE_GATE_MISSING_AXIS.md"
  write_gate_doc "$doc"
  sed -i '/scientific closure/d;/Scientific closure/d' "$doc"
  bash "$GUARD" --dry-run "$doc"
}

later_phase_scope() {
  local doc="$tmp_root/docs/PHASE_9_10_11_ACCEPTANCE_GATE_LATER_SCOPE.md"
  write_gate_doc "$doc" "Out of scope: Phase 12 task queue."
  bash "$GUARD" --dry-run "$doc"
}

unsupported_completion_assertion() {
  local doc="$tmp_root/docs/PHASE_9_10_11_ACCEPTANCE_GATE_COMPLETION.md"
  write_gate_doc "$doc" "Phase 9 is scientifically complete."
  bash "$GUARD" --dry-run "$doc"
}

positive_claim_without_artifact() {
  local doc="$tmp_root/docs/PHASE_9_10_11_ACCEPTANCE_GATE_GO_CLAIM.md"
  write_gate_doc "$doc" "Closure label: GO_CLAIM. Source-ledger-backed verdict and validation command are listed with provenance."
  bash "$GUARD" --dry-run "$doc"
}

require_success_contains \
  "valid gate report" \
  "Phase 9/10/11 acceptance gate checks passed: 1 checked" \
  valid_gate

require_failure_contains \
  "missing scientific axis" \
  "[FAIL] scientific closure axis" \
  missing_scientific_axis

require_failure_contains \
  "later phase scope rejected" \
  "[FAIL] no later-phase scope" \
  later_phase_scope

require_failure_contains \
  "unsupported completion assertion rejected" \
  "[FAIL] no unsupported completion assertion" \
  unsupported_completion_assertion

require_failure_contains \
  "positive claim without artifact rejected" \
  "[FAIL] positive closure has empirical artifact evidence" \
  positive_claim_without_artifact

echo "PASS: Phase 9/10/11 acceptance gate fixtures passed ($passes checks)."

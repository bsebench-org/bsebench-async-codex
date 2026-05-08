#!/usr/bin/env bash
# Fixture checks for the Phase 9/10/11 acceptance-gate validator.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECKER="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"
BASE_CHECKLIST="$REPO_ROOT/docs/PHASE_9_10_11_ACCEPTANCE_GATE_2026-05-08.json"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/phase9-11-gate-probe.XXXXXX")"

trap 'rm -rf "$TMP_ROOT"' EXIT

passes=0

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@" 2>&1)" ; then
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

copy_base() {
  local target="$1"
  cp "$BASE_CHECKLIST" "$target"
}

valid_no_go() {
  bash "$CHECKER" "$BASE_CHECKLIST"
}

unsafe_phase_go() {
  local fixture="$TMP_ROOT/unsafe-phase-go.json"
  copy_base "$fixture"
  jq '.phases.phase_9.scientific_closure_gate.status = "GO"' "$fixture" > "$fixture.tmp"
  mv "$fixture.tmp" "$fixture"
  bash "$CHECKER" "$fixture"
}

unsafe_top_go() {
  local fixture="$TMP_ROOT/unsafe-top-go.json"
  copy_base "$fixture"
  jq '.decision = "GO"' "$fixture" > "$fixture.tmp"
  mv "$fixture.tmp" "$fixture"
  bash "$CHECKER" "$fixture"
}

out_of_scope_phase() {
  local fixture="$TMP_ROOT/out-of-scope.json"
  copy_base "$fixture"
  jq '.phases.phase_12 = {"title": "out of scope", "tooling_gate": {"status": "blocked"}, "scientific_closure_gate": {"status": "NO_GO", "required_evidence": []}}' "$fixture" > "$fixture.tmp"
  mv "$fixture.tmp" "$fixture"
  bash "$CHECKER" "$fixture"
}

unsupported_public_claim_wording() {
  local fixture="$TMP_ROOT/claim-wording.json"
  copy_base "$fixture"
  jq '.phases.phase_9.tooling_gate.evidence[0].note = "fixture says SOTA"' "$fixture" > "$fixture.tmp"
  mv "$fixture.tmp" "$fixture"
  bash "$CHECKER" "$fixture"
}

require_success_contains \
  "valid NO_GO checklist" \
  "Phase 9/10/11 acceptance-gate validation passed." \
  valid_no_go

require_failure_contains \
  "phase GO with missing evidence fails" \
  "[FAIL] phase_9 cannot be GO with missing required evidence" \
  unsafe_phase_go

require_failure_contains \
  "top GO with non-GO phases fails" \
  "[FAIL] top-level GO requires all three phase scientific gates to be GO" \
  unsafe_top_go

require_failure_contains \
  "out-of-scope phase fails" \
  "[FAIL] phase_12 is outside Phase 9/10/11 scope" \
  out_of_scope_phase

require_failure_contains \
  "unsupported public wording fails" \
  "[FAIL] unsupported public-claim wording appears in checklist text" \
  unsupported_public_claim_wording

echo "PASS: Phase 9/10/11 acceptance-gate probes passed ($passes checks)."

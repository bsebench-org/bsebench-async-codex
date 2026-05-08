#!/usr/bin/env bash
# probe-research-brief-gates.sh - fixture checks for research BRIEF wording gates.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-research-brief-gates.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

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

write_phase9_good_brief() {
  local brief="$tmp_root/inbox/phase-9-fixture/BRIEF.md"
  mkdir -p "$(dirname "$brief")"
  cat > "$brief" <<'BRIEF'
# Phase 9 fixture

## Required behavior

- Validate cache provenance, Tier2 readiness, source-ledger identity, and empirical-run evidence before any closure language.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; it is protected and unrelated to this fixture.
- Do not make SOTA claims without a source ledger, DOI or stable URL, retrieval date, and comparability table.
- Do not make closure, completion, performance, benchmark, winner, leaderboard, or scientific verdict statements without cache/provenance/Tier2/source-ledger/empirical evidence.

## Falsification gate

If cache, provenance, Tier2, source-ledger, or empirical-run evidence is missing, this task must fail closed.

## Validation

Run `bash scripts/check-research-brief-gates.sh --dry-run inbox/phase-9-fixture/BRIEF.md`.
BRIEF
  bash "$GUARD" --dry-run "$brief" 2>&1
}

write_phase9_bad_brief() {
  local brief="$tmp_root/inbox/phase-9-bad/BRIEF.md"
  mkdir -p "$(dirname "$brief")"
  cat > "$brief" <<'BRIEF'
# Phase 9 bad fixture

## Required behavior

- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; it is protected and unrelated to this fixture.
- Do not make SOTA claims without a source ledger and comparability table.

## Falsification gate

If validation is missing, this task must fail.

## Validation

Run a dry-run check.
BRIEF
  bash "$GUARD" --dry-run "$brief" 2>&1
}

write_phase12_skipped_brief() {
  local brief="$tmp_root/inbox/phase-12-fixture/BRIEF.md"
  mkdir -p "$(dirname "$brief")"
  printf '# Phase 12 fixture\n' > "$brief"
  bash "$GUARD" --dry-run "$brief" 2>&1
}

require_success_contains \
  "Phase 9 BRIEF with closure evidence guardrails" \
  "[OK]   no unsupported Phase 9/10/11 closure or performance claims" \
  write_phase9_good_brief

require_failure_contains \
  "Phase 9 BRIEF missing closure evidence guardrails" \
  "[FAIL] no unsupported Phase 9/10/11 closure or performance claims" \
  write_phase9_bad_brief

require_success_contains \
  "Phase 12 BRIEF is skipped" \
  "[SKIP] $tmp_root/inbox/phase-12-fixture/BRIEF.md" \
  write_phase12_skipped_brief

echo "PASS: research BRIEF gate fixtures passed ($passes checks)."

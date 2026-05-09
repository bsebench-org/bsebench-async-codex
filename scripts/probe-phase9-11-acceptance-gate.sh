#!/usr/bin/env bash
# probe-phase9-11-acceptance-gate.sh - fixture checks for acceptance gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_phase_block() {
  local path="$1"
  local phase="$2"
  local tooling="$3"
  local empirical="$4"
  local scientific="$5"
  local extra="${6:-}"

  cat >> "$path" <<EOF

## Phase $phase

Tooling status: $tooling
Empirical status: $empirical
Scientific closure: $scientific
$extra
EOF
}

write_tooling_only_report() {
  local path="$1"
  : > "$path"
  for phase in 9 10 11 ; do
    write_phase_block \
      "$path" \
      "$phase" \
      "GO_TOOLING branch=phase-$phase-tooling commit=123456$phase validation='pytest; ruff; git diff --check' blockers=none" \
      "NO_GO_EMPIRICAL blockers=missing cache/provenance/Tier2/empirical run evidence" \
      "NO_GO_CLAIM blockers=missing empirical artifact and source-ledger evidence"
  done
}

write_full_evidence_report() {
  local path="$1"
  : > "$path"
  for phase in 9 10 11 ; do
    write_phase_block \
      "$path" \
      "$phase" \
      "GO_TOOLING branch=phase-$phase-tooling commit=abcdef$phase validation='pytest; ruff; git diff --check' blockers=none" \
      "GO_EMPIRICAL branch=phase-$phase-empirical commit=bcdefa$phase validation='pytest; replay' blockers=none" \
      "GO_CLAIM branch=phase-$phase-claim commit=cdefab$phase validation='independent validator' blockers=none" \
      "Cache evidence: present and validated.
Provenance evidence: present and validated.
Tier2 cache evidence: present and validated.
Empirical run artifact: present and validated.
Source-ledger evidence: present and complete with comparability table."
  done
}

run_gate() {
  bash "$GATE" --dry-run "$@" 2>&1
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

tooling_only="$tmp_root/tooling-only.md"
write_tooling_only_report "$tooling_only"
require_success_contains \
  "tooling-only report passes while empirical/scientific fail closed" \
  "Phase 9/10/11 acceptance gate passed." \
  run_gate "$tooling_only"

full_evidence="$tmp_root/full-evidence.md"
write_full_evidence_report "$full_evidence"
require_success_contains \
  "full evidence report can pass scientific lane" \
  "Phase 11 source-ledger evidence" \
  run_gate "$full_evidence"

missing_source="$tmp_root/missing-source-ledger.md"
write_full_evidence_report "$missing_source"
sed -i '/Source-ledger evidence/d' "$missing_source"
require_failure_contains \
  "scientific GO fails without source ledger" \
  "Phase 9 missing source-ledger evidence" \
  run_gate "$missing_source"

missing_tier2="$tmp_root/missing-tier2.md"
write_full_evidence_report "$missing_tier2"
sed -i '/Tier2 cache evidence/d' "$missing_tier2"
require_failure_contains \
  "empirical GO fails without Tier2 evidence" \
  "Phase 9 missing Tier2 evidence" \
  run_gate "$missing_tier2"

future_phase="$tmp_root/future-phase.md"
write_tooling_only_report "$future_phase"
cat >> "$future_phase" <<'EOF'

## Phase 12

This section must keep the checklist out of scope.
EOF
require_failure_contains \
  "future phase mention fails scope lock" \
  "future-phase scope violation" \
  run_gate "$future_phase"

public_claim="$tmp_root/public-claim.md"
write_tooling_only_report "$public_claim"
cat >> "$public_claim" <<'EOF'

Public benchmark ready for communication.
EOF
require_failure_contains \
  "public communication claim fails" \
  "unsupported comparison/public-communication claim wording" \
  run_gate "$public_claim"

missing_lane="$tmp_root/missing-lane.md"
write_tooling_only_report "$missing_lane"
sed -i '/Empirical status:/d' "$missing_lane"
require_failure_contains \
  "missing empirical lane fails" \
  "missing separate empirical lane" \
  run_gate "$missing_lane"

echo "PASS: Phase 9/10/11 acceptance-gate probes passed ($passes checks)."

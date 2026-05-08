#!/usr/bin/env bash
# check-phase9-11-checkpoint-report.sh - fail-closed audit for the Phase 9/10/11 checkpoint report.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-checkpoint-report.sh REPORT.md

Checks that the checkpoint report includes the required Phase 9/10/11 closure
sections, explicit NO-GO decisions, evidence blocker tokens, and a 12-item
next queue. It also rejects later-phase scope leakage and prohibited public
claim wording.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] ; then
  usage
  exit 0
fi

report="${1:-}"
if [[ -z "$report" ]] ; then
  usage >&2
  exit 2
fi
if [[ ! -f "$report" ]] ; then
  echo "FAIL: report not found: $report" >&2
  exit 2
fi

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

require_literal() {
  local label="$1"
  local literal="$2"

  grep -Fq "$literal" "$report" || fail "$label missing literal: $literal"
  echo "PASS: $label"
}

require_regex() {
  local label="$1"
  local pattern="$2"

  grep -Eiq "$pattern" "$report" || fail "$label missing pattern: $pattern"
  echo "PASS: $label"
}

for heading in \
  "## Executive Status" \
  "## Percent Complete" \
  "## Branch Commit Table" \
  "## Validation Table" \
  "## Blocker Table" \
  "## GO/NO-GO Decision" \
  "## Merge Order" \
  "## Rollback Plan" \
  "## Next Queue" \
  "## Evidence Inventory" \
  "## Final Checkpoint Verdict"
do
  require_literal "heading $heading" "$heading"
done

require_literal "phase 9 no-go row" "| Phase 9 | 100% | 0% | 0% | 60% | NO-GO |"
require_literal "phase 10 no-go row" "| Phase 10 | 100% | 0% | 0% | 60% | NO-GO |"
require_literal "phase 11 no-go row" "| Phase 11 | 55% | 0% | 0% | 55% | NO-GO |"

require_literal "tooling decision" "| Tooling merge | CONDITIONAL GO |"
require_literal "empirical decision" "| Empirical scheduling | NO-GO |"
require_literal "scientific decision" "| Scientific closure | NO-GO |"
require_literal "public communication decision" "| Public communication | NO-GO |"

for token in cache provenance Tier2 source-ledger empirical-run "HF upload processes: \`0\`"; do
  require_literal "evidence token $token" "$token"
done

queue_count=$(grep -Ec '^\| Q[0-9][0-9] \|' "$report" || true)
if [[ "$queue_count" -ne 12 ]] ; then
  fail "expected 12 next queue rows, found $queue_count"
fi
echo "PASS: 12 next queue rows"

if grep -Eiq 'Phase[[:space:]-]*1[2-9]|Phase[[:space:]-]*[2-9][0-9]' "$report" ; then
  fail "report leaks later phase scope"
fi
echo "PASS: no later-phase scope leakage"

if grep -Eiq '\b(SOTA|state-of-the-art|novelty|leaderboard|winner)\b' "$report" ; then
  fail "report contains prohibited public claim wording"
fi
echo "PASS: no prohibited public claim wording"

if grep -Eiq 'claim_55|claim-55' "$report" ; then
  fail "report mentions protected claim target"
fi
echo "PASS: no protected claim target mention"

require_regex "final no-go verdict" 'Phase 9/10/11 closure is[[:space:]]+\*\*NO-GO\*\*'

echo "PASS: Phase 9/10/11 checkpoint report gate passed."

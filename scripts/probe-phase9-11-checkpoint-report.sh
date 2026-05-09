#!/usr/bin/env bash
# probe-phase9-11-checkpoint-report.sh - fixture tests for the checkpoint report gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKER="$SCRIPT_DIR/check-phase9-11-checkpoint-report.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

require_success() {
  local name="$1"
  shift
  local output

  if ! output="$("$@" 2>&1)" ; then
    echo "FAIL: $name expected success" >&2
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
  if [[ "$output" != *"$needle"* ]] ; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

write_good_report() {
  local path="$1"

  cat > "$path" <<'REPORT'
# Phase 9/10/11 General Audit Checkpoint - fixture

## Executive Status
Scientific closure remains **NO-GO**.
HF upload processes: `0`

## Percent Complete
| Phase | Tooling % | Empirical % | Claim % | Overall % | Scientific decision |
| --- | ---: | ---: | ---: | ---: | --- |
| Phase 9 | 100% | 0% | 0% | 60% | NO-GO |
| Phase 10 | 100% | 0% | 0% | 60% | NO-GO |
| Phase 11 | 55% | 0% | 0% | 55% | NO-GO |

## Branch Commit Table
cache provenance Tier2 source-ledger empirical-run

## Validation Table
validation rows

## Blocker Table
blocked rows

## GO/NO-GO Decision
| Decision area | Decision | Reason |
| --- | --- | --- |
| Tooling merge | CONDITIONAL GO | fixture |
| Empirical scheduling | NO-GO | fixture |
| Scientific closure | NO-GO | fixture |
| Public communication | NO-GO | fixture |

## Merge Order
steps

## Rollback Plan
steps

## Next Queue
| Queue | Repo | Task | Gate to pass |
| --- | --- | --- | --- |
| Q01 | a | b | c |
| Q02 | a | b | c |
| Q03 | a | b | c |
| Q04 | a | b | c |
| Q05 | a | b | c |
| Q06 | a | b | c |
| Q07 | a | b | c |
| Q08 | a | b | c |
| Q09 | a | b | c |
| Q10 | a | b | c |
| Q11 | a | b | c |
| Q12 | a | b | c |

## Evidence Inventory
evidence rows

## Final Checkpoint Verdict
Phase 9/10/11 closure is **NO-GO**.
REPORT
}

good="$tmp_root/good.md"
write_good_report "$good"
require_success "complete fixture passes" "$CHECKER" "$good"

missing_queue="$tmp_root/missing-queue.md"
write_good_report "$missing_queue"
sed -i '/^| Q12 /d' "$missing_queue"
require_failure_contains \
  "missing queue row fails" \
  "expected 12 next queue rows" \
  "$CHECKER" "$missing_queue"

positive_empirical="$tmp_root/positive-empirical.md"
write_good_report "$positive_empirical"
sed -i 's/| Phase 10 | 100% | 0% | 0% | 60% | NO-GO |/| Phase 10 | 100% | 100% | 0% | 60% | NO-GO |/' \
  "$positive_empirical"
require_failure_contains \
  "positive empirical percentage fails" \
  "phase 10 no-go row missing" \
  "$CHECKER" "$positive_empirical"

later_phase="$tmp_root/later-phase.md"
write_good_report "$later_phase"
printf '\nPhase 12 placeholder\n' >> "$later_phase"
require_failure_contains \
  "later phase scope fails" \
  "later phase scope" \
  "$CHECKER" "$later_phase"

public_claim="$tmp_root/public-claim.md"
write_good_report "$public_claim"
printf '\nleaderboard placeholder\n' >> "$public_claim"
require_failure_contains \
  "public claim wording fails" \
  "prohibited public claim wording" \
  "$CHECKER" "$public_claim"

echo "PASS: Phase 9/10/11 checkpoint report probe passed ($passes checks)."

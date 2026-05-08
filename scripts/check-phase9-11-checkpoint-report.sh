#!/usr/bin/env bash
# check-phase9-11-checkpoint-report.sh - focused validator for the Phase 9/10/11 checkpoint report.

set -euo pipefail

report="${1:-docs/PHASE_9_10_11_GENERAL_AUDIT_CHECKPOINT_20260508T212224+0200.md}"

if [[ ! -f "$report" ]] ; then
  echo "FAIL: report not found: $report" >&2
  exit 1
fi

require_contains() {
  local needle="$1"
  if ! grep -Fq "$needle" "$report" ; then
    echo "FAIL: missing required text: $needle" >&2
    exit 1
  fi
}

require_absent_regex() {
  local regex="$1"
  local label="$2"
  if grep -Eiq "$regex" "$report" ; then
    echo "FAIL: forbidden $label in $report" >&2
    grep -Ein "$regex" "$report" >&2
    exit 1
  fi
}

require_contains "Phase 9 cross-profile comparability"
require_contains "Phase 10 aging/SOH generalization"
require_contains "Phase 11 residual decomposition"
require_contains "\`NO_GO_EMPIRICAL\`"
require_contains "\`NO_GO_CLAIM\`"
require_contains "Loader-facing Tier2 cache roots are missing"
require_contains "Source-ledger gates are not merged cleanly"
require_contains "## Next 12 Executable Tasks"
require_contains "## Validation For This Checkpoint"

task_count=$(grep -Ec '^[0-9]+\. `P(9|10|11)-' "$report")
if [[ "$task_count" -ne 12 ]] ; then
  echo "FAIL: expected 12 Phase 9/10/11 next tasks, found $task_count" >&2
  exit 1
fi

unsupported_result_regex='state-of-the-''art|so''ta|novel''ty|leader''board|win''ner|break''through'
coauthor_regex='Co-Authored-By[[:space:]]+Clau''de'

require_absent_regex 'phase[[:space:]]*(1[2-9]|[2-9][0-9])' "later-phase reference"
require_absent_regex "($unsupported_result_regex)" "unsupported result language"
require_absent_regex 'claim[_-]?55' "protected claim token"
require_absent_regex "$coauthor_regex" "disallowed coauthor trailer"

echo "PASS: Phase 9/10/11 checkpoint report guard passed ($task_count next tasks)."

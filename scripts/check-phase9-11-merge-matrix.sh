#!/usr/bin/env bash
# Validate the Phase 9/10/11 merge matrix without merging any branch.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-phase9-11-merge-matrix.sh [--minimal] [MATRIX.md]

Checks that the Phase 9/10/11 merge matrix:
  - stays Phase 9/10/11-only;
  - keeps scientific closure fail-closed;
  - records cache/provenance/Tier2, source-ledger, and empirical-run gates;
  - does not mark any row as an immediate merge action;
  - contains the expected matrix row IDs.

--minimal is for fixture probes and requires only P9-SAMPLE, P10-SAMPLE, and
P11-SAMPLE row IDs.
USAGE
}

matrix="docs/PHASE-9-10-11-MERGE-MATRIX-2026-05-08.md"
minimal=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --minimal)
      minimal=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      matrix="$1"
      ;;
  esac
  shift
done

failures=0

fail() {
  echo "[FAIL] $*" >&2
  failures=$((failures + 1))
}

require_literal() {
  local literal="$1"
  if grep -Fq "$literal" "$matrix"; then
    echo "[OK] $literal"
  else
    fail "missing required text: $literal"
  fi
}

if [[ ! -f "$matrix" ]]; then
  echo "[FAIL] matrix file not found: $matrix" >&2
  exit 1
fi

require_literal "Do-not-merge instruction: yes"
require_literal "Scientific closure status: NO-GO."
require_literal "cache/provenance/Tier2"
require_literal "source-ledger"
require_literal "empirical-run"

if grep -Eiq '(^|[^[:alnum:]])(phase-?(1[2-9]|[2-9][0-9])|Phase (1[2-9]|[2-9][0-9])|phase-future)([^[:alnum:]]|$)' "$matrix"; then
  fail "out-of-scope later-phase reference found"
else
  echo "[OK] no later-phase refs"
fi

if grep -Eiq 'merge now|ready to merge|^[|][^|]*[|][^|]*[|][^|]*[|][^|]*[|][^|]*[|][^|]*[|][[:space:]]*merged[[:space:]]*[|]' "$matrix"; then
  fail "matrix marks an immediate merge action"
else
  echo "[OK] no immediate merge action"
fi

if [[ "$minimal" -eq 1 ]]; then
  required_ids=(
    "P9-SAMPLE"
    "P10-SAMPLE"
    "P11-SAMPLE"
  )
else
  required_ids=(
    "P9-DATASET-READINESS"
    "P9-DATASET-TIER2"
    "P9-DATASET-REFILL-TIER2-A"
    "P9-DATASET-REFILL-TIER2-B"
    "P9-RUNNER-INVENTORY"
    "P9-RUNNER-BUDGET"
    "P9-RUNNER-EMPIRICAL-SCHEDULER"
    "P9-RUNNER-REFILL-SCHEDULER-A"
    "P9-RUNNER-REFILL-SCHEDULER-B"
    "P9-STATS-COMPARABILITY"
    "P9-STATS-VERDICT-INPUTS"
    "P9-STATS-REFILL-VERDICT-INPUTS"
    "P9-SPECS-SCHEMA"
    "P9-FILTERS-SMOKE"
    "P10-DATASET-READINESS"
    "P10-DATASET-TIER2"
    "P10-DATASET-REFILL-TIER2"
    "P10-RUNNER-BUDGET"
    "P10-RUNNER-EMPIRICAL-SCHEDULER"
    "P10-RUNNER-REFILL-SCHEDULER-A"
    "P10-RUNNER-REFILL-SCHEDULER-B"
    "P10-STATS-INVARIANCE"
    "P10-STATS-VERDICT-INPUTS"
    "P10-STATS-REFILL-VERDICT-INPUTS"
    "P10-SPECS-SCHEMA"
    "P10-FILTERS-SMOKE"
    "P11-DATASET-SOURCE"
    "P11-DATASET-TIER2"
    "P11-DATASET-REFILL-TIER2-A"
    "P11-DATASET-REFILL-TIER2-B"
    "P11-RUNNER-INPUT"
    "P11-RUNNER-DRYRUN"
    "P11-RUNNER-TRACE-SCHEDULER"
    "P11-RUNNER-REFILL-TRACE-SCHEDULER"
    "P11-STATS-DECOMP"
    "P11-STATS-VERDICT-INPUTS"
    "P11-STATS-REFILL-VERDICT-INPUTS"
    "P11-SPECS-SCHEMA"
    "P11-FILTERS-OUTPUT"
    "X-DATASETS-GAP-AUDIT"
    "X-DATASETS-INTEGRATION"
    "X-RUNNER-GAP-AUDIT"
    "X-RUNNER-INTEGRATION"
    "X-RUNNER-REFILL-SMOKE"
    "X-STATS-GAP-AUDIT"
    "X-STATS-INTEGRATION"
    "X-STATS-REFILL-LANGUAGE"
    "X-SPECS-GAP-AUDIT"
    "X-SPECS-INTEGRATION"
    "X-SPECS-REFILL-SCHEMA-EXPORT"
    "X-FILTERS-GAP-AUDIT"
    "X-FILTERS-INTEGRATION"
    "X-FILTERS-REFILL-CONTRACT-EXPORT"
    "X-ASYNC-CHECKPOINT"
    "X-ASYNC-BLOCKER-BOARD"
    "X-ASYNC-FINAL-MERGE-COORDINATOR"
    "X-ASYNC-CLOSURE-PLAN"
    "X-ASYNC-FINAL-SYNTHESIS"
    "X-ASYNC-VERDICT-P9"
    "X-ASYNC-VERDICT-P10"
    "X-ASYNC-VERDICT-P11"
    "X-ASYNC-EVIDENCE-LANGUAGE-AUDIT"
    "X-ASYNC-ACCEPTANCE-GATE"
    "X-ASYNC-ANTI-CLAIM-AUDIT"
    "X-ASYNC-PREVIOUS-MATRIX"
  )
fi

for row_id in "${required_ids[@]}"; do
  if grep -Fq "| $row_id |" "$matrix"; then
    echo "[OK] row $row_id"
  else
    fail "missing row id: $row_id"
  fi
done

if [[ "$minimal" -eq 0 ]]; then
  required_conflict_paths=(
    "src/bsebench_datasets/__init__.py"
    "scripts/phase11_residual_input_contract.py"
    "scripts/export_schemas.py"
    "src/bsebench_filters/contract.py"
    "tests/test_schema_export.py"
  )

  for path in "${required_conflict_paths[@]}"; do
    if grep -Fq "$path" "$matrix"; then
      echo "[OK] conflict path $path"
    else
      fail "missing conflict path: $path"
    fi
  done
fi

if [[ "$failures" -gt 0 ]]; then
  echo "Phase 9/10/11 merge matrix check failed: $failures failure(s)." >&2
  exit 1
fi

echo "Phase 9/10/11 merge matrix check passed."

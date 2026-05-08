#!/usr/bin/env bash
# probe-phase9-11-acceptance-gate.sh - fixture checks for the acceptance gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_tooling_only_checklist() {
  local path="$1"

  {
    printf 'phase\tlane\tstatus\tevidence\tblockers\n'
    for phase in phase9 phase10 phase11 ; do
      printf '%s\ttooling\tGO\tcommit=abc123; validation=focused-tests; diff_check=git-diff-check\tnone\n' "$phase"
      printf '%s\tempirical\tNO_GO\tcommit=abc123\tcache/provenance/Tier2/empirical-run evidence missing\n' "$phase"
      printf '%s\tscientific\tNO_GO\tcommit=abc123\tsource-ledger and empirical-run evidence missing\n' "$phase"
      printf '%s\tpublic\tNO_GO\tcommit=abc123\tscientific closure not supported\n' "$phase"
    done
  } > "$path"
}

write_full_go_checklist() {
  local path="$1"

  {
    printf 'phase\tlane\tstatus\tevidence\tblockers\n'
    for phase in phase9 phase10 phase11 ; do
      printf '%s\ttooling\tGO\tcommit=abc123; validation=focused-tests; diff_check=git-diff-check\tnone\n' "$phase"
      printf '%s\tempirical\tGO\tcommit=abc123; validation=runner-check; cache=ready; provenance=ready; tier2=ready; empirical_run=artifact\tnone\n' "$phase"
      printf '%s\tscientific\tGO\tcommit=abc123; validation=stats-check; cache=ready; provenance=ready; tier2=ready; empirical_run=artifact; source_ledger=complete\tnone\n' "$phase"
      printf '%s\tpublic\tGO\tpublic_summary=conservative-status\tnone\n' "$phase"
    done
  } > "$path"
}

run_gate() {
  bash "$GATE" "$1" 2>&1
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

tooling_only="$tmp_root/tooling-only.tsv"
write_tooling_only_checklist "$tooling_only"
require_success_contains \
  "tooling-only checklist remains scientifically closed" \
  "overall_scientific_closure=NO_GO" \
  run_gate "$tooling_only"

full_go="$tmp_root/full-go.tsv"
write_full_go_checklist "$full_go"
require_success_contains \
  "full evidence checklist can pass all lanes" \
  "overall_scientific_closure=GO" \
  run_gate "$full_go"

missing_row="$tmp_root/missing-row.tsv"
write_tooling_only_checklist "$missing_row"
sed -i '/^phase11\tpublic\t/d' "$missing_row"
require_failure_contains \
  "missing required public row fails closed" \
  "[FAIL] missing required row: phase11:public" \
  run_gate "$missing_row"

scientific_without_empirical="$tmp_root/scientific-without-empirical.tsv"
write_tooling_only_checklist "$scientific_without_empirical"
sed -i $'s/^phase9\\tscientific\\tNO_GO\\t.*/phase9\\tscientific\\tGO\\tcommit=abc123; validation=stats-check; cache=ready; provenance=ready; tier2=ready; empirical_run=artifact; source_ledger=complete\\tnone/' \
  "$scientific_without_empirical"
require_failure_contains \
  "scientific GO requires empirical GO" \
  "[FAIL] phase9 scientific GO without empirical GO" \
  run_gate "$scientific_without_empirical"

missing_source_ledger="$tmp_root/missing-source-ledger.tsv"
write_full_go_checklist "$missing_source_ledger"
sed -i $'s/; source_ledger=complete//' "$missing_source_ledger"
require_failure_contains \
  "scientific GO requires source ledger evidence" \
  "[FAIL] phase9 scientific GO missing evidence token: source_ledger" \
  run_gate "$missing_source_ledger"

go_with_blocker="$tmp_root/go-with-blocker.tsv"
write_tooling_only_checklist "$go_with_blocker"
sed -i $'s/^phase10\\ttooling\\tGO\\t\\([^\\t]*\\)\\tnone/phase10\\ttooling\\tGO\\t\\1\\tvalidation artifact missing/' \
  "$go_with_blocker"
require_failure_contains \
  "GO row with blocker fails" \
  "[FAIL] phase10 tooling GO has blockers: validation artifact missing" \
  run_gate "$go_with_blocker"

public_without_scientific="$tmp_root/public-without-scientific.tsv"
write_tooling_only_checklist "$public_without_scientific"
sed -i $'s/^phase11\\tpublic\\tNO_GO\\t.*/phase11\\tpublic\\tGO\\tpublic_summary=status-page\\tnone/' \
  "$public_without_scientific"
require_failure_contains \
  "public GO requires scientific GO" \
  "[FAIL] phase11 public GO without scientific GO" \
  run_gate "$public_without_scientific"

echo "PASS: phase9-11 acceptance gate fixtures passed ($passes checks)."

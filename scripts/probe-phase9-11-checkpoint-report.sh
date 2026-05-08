#!/usr/bin/env bash
# probe-phase9-11-checkpoint-report.sh - fixture checks for the checkpoint report guard.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$SCRIPT_DIR/check-phase9-11-checkpoint-report.sh"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

valid_report() {
  local path="$tmp_root/valid.md"
  {
    printf '# Phase 9/10/11 General Audit Checkpoint - fixture\n'
    printf '\n## Evidence Sources\nreal HF upload processes: `0`\n'
    printf '\n## Executive Status\nGO_TOOLING_WITH_REVALIDATION and NO_GO_EMPIRICAL and NO_GO_CLAIM and NO_GO_PUBLIC.\n'
    printf '\n## Percent Complete\ncache provenance Tier2 source-ledger empirical-run blockers remain.\n'
    printf '\n## Branch/Commit Evidence\nfixture\n'
    printf '\n## Validation Table\nfixture\n'
    printf '\n## Blockers\nfixture\n'
    printf '\n## Merge Order\nfixture\n'
    printf '\n## Rollback Plan\nfixture\n'
    printf '\n## Next Queue\nfixture\n'
    printf '\n## Final GO/NO-GO\nUnlock Phase 12/13 work: `NO_GO`.\n'
  } > "$path"
  bash "$GUARD" "$path"
}

missing_source_ledger() {
  local path="$tmp_root/missing-source-ledger.md"
  valid_report >/dev/null
  sed 's/source-ledger/source ledger/g' "$tmp_root/valid.md" > "$path"
  bash "$GUARD" "$path"
}

positive_claim() {
  local path="$tmp_root/positive-claim.md"
  valid_report >/dev/null
  cp "$tmp_root/valid.md" "$path"
  printf '\nPhase 9 is scientifically complete.\n' >> "$path"
  bash "$GUARD" "$path"
}

go_claim() {
  local path="$tmp_root/go-claim.md"
  valid_report >/dev/null
  cp "$tmp_root/valid.md" "$path"
  printf '\nDecision: GO_CLAIM\n' >> "$path"
  bash "$GUARD" "$path"
}

disallowed_coauthor_trailer() {
  local path="$tmp_root/disallowed-coauthor.md"
  valid_report >/dev/null
  cp "$tmp_root/valid.md" "$path"
  printf '\nCo-Authored-By: Clau%s <blocked@example.invalid>\n' "de" >> "$path"
  bash "$GUARD" "$path"
}

require_success() {
  local name="$1"
  shift
  local output

  if ! output="$("$@" 2>&1)" ; then
    echo "FAIL: $name expected success" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "checkpoint report check passed" <<< "$output" ; then
    echo "FAIL: $name missing pass output" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

require_failure() {
  local name="$1"
  shift
  local output
  local status=0

  output="$("$@" 2>&1)" || status=$?
  if [[ "$status" -eq 0 ]] ; then
    echo "FAIL: $name expected failure" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "checkpoint report check failed" <<< "$output" ; then
    echo "FAIL: $name missing failure output" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

require_success "valid checkpoint report" valid_report
require_failure "missing source-ledger blocker" missing_source_ledger
require_failure "positive complete claim" positive_claim
require_failure "GO_CLAIM rejected" go_claim
require_failure "disallowed co-author rejected" disallowed_coauthor_trailer

echo "PASS: Phase 9/10/11 checkpoint report guard fixtures passed ($passes checks)."

#!/usr/bin/env bash
# Runs synthetic BRIEF fixtures through the research gate checker.
#
# Fixture paths intentionally contain inbox/ or cto/AUTONOMY_BACKLOG/ so the
# checker exercises its real path filters, but they live under tests/fixtures
# and must never be queued or paired with STATUS.json.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECKER="$ROOT_DIR/scripts/check-research-brief-gates.sh"
FIXTURE_DIR="$ROOT_DIR/tests/fixtures/research-brief-gates"
LOG_DIR="$(mktemp -d)"
trap 'rm -rf "$LOG_DIR"' EXIT

pass_count=0
reject_count=0

run_accept() {
  local label="$1"
  local path="$2"
  local log="$LOG_DIR/${label}.log"

  if ! bash "$CHECKER" --dry-run "$path" >"$log" 2>&1 ; then
    echo "[FAIL] accepted fixture was rejected: $label"
    cat "$log"
    exit 1
  fi

  echo "[OK] accepted fixture passed: $label"
  pass_count=$((pass_count + 1))
}

run_reject() {
  local label="$1"
  local path="$2"
  local expected="$3"
  local log="$LOG_DIR/${label}.log"

  if bash "$CHECKER" --dry-run "$path" >"$log" 2>&1 ; then
    echo "[FAIL] rejected fixture passed gate: $label"
    echo "Fixture: $path"
    cat "$log"
    exit 1
  fi

  if ! grep -Eiq "$expected" "$log" ; then
    echo "[FAIL] rejected fixture missed expected diagnostic: $label"
    echo "Expected pattern: $expected"
    cat "$log"
    exit 1
  fi

  echo "[OK] rejected fixture blocked: $label"
  awk '/hard-ban:/{print; if (getline) print; if (getline) print}' "$log"
  reject_count=$((reject_count + 1))
}

run_accept \
  "accepted-backlog-guardrail" \
  "$FIXTURE_DIR/accepted-backlog/cto/AUTONOMY_BACKLOG/phase-7-fixture-accepted-guardrail/BRIEF.md"

run_reject \
  "reject-claim55-target" \
  "$FIXTURE_DIR/reject-claim55-target/inbox/phase-7-fixture-reject-claim55-target/BRIEF.md" \
  'hard-ban: protected claim_55 work directive'

run_reject \
  "reject-registry-edit" \
  "$FIXTURE_DIR/reject-registry-edit/cto/AUTONOMY_BACKLOG/phase-7-fixture-reject-registry-edit/BRIEF.md" \
  'hard-ban: unauthorized thesis or claim-registry write directive'

run_reject \
  "reject-unsupported-sota" \
  "$FIXTURE_DIR/reject-unsupported-sota/inbox/phase-7-fixture-reject-unsupported-sota/BRIEF.md" \
  'hard-ban: unsupported SOTA or novelty assertion'

echo "Research BRIEF fixture gate tests passed: accepted=$pass_count rejected=$reject_count."

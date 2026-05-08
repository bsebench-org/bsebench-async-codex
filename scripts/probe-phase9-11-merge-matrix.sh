#!/usr/bin/env bash
# Fixture probes for check-phase9-11-merge-matrix.sh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHECK="$SCRIPT_DIR/check-phase9-11-merge-matrix.sh"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

passes=0

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@")"; then
    echo "FAIL: $name expected success" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<<"$output"; then
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
  if [[ "$status" -eq 0 ]]; then
    echo "FAIL: $name expected failure" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<<"$output"; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

write_good_fixture() {
  local path="$1"
  cat >"$path" <<'MATRIX'
# fixture

- Do-not-merge instruction: yes
- Scientific closure status: NO-GO.
- Fail-closed evidence gates: cache/provenance/Tier2; source-ledger; empirical-run.

| ID | Repo | Branch | SHA | Merge-tree state | Gate state | Action |
|---|---|---|---:|---|---|---|
| P9-SAMPLE | repo | phase-9-sample | abc1234 | clean | cache/provenance/Tier2 gate pending. | Validate only. |
| P10-SAMPLE | repo | phase-10-sample | abc1234 | clean | source-ledger gate pending. | Validate only. |
| P11-SAMPLE | repo | phase-11-sample | abc1234 | clean | empirical-run gate pending. | Validate only. |
MATRIX
}

good="$tmp_root/good.md"
missing_evidence="$tmp_root/missing-evidence.md"
out_of_scope="$tmp_root/out-of-scope.md"
merge_now="$tmp_root/merge-now.md"

write_good_fixture "$good"
cp "$good" "$missing_evidence"
cp "$good" "$out_of_scope"
cp "$good" "$merge_now"

perl -0pi -e 's/empirical-run/evidence-run/g' "$missing_evidence"
printf '\n| BAD | repo | phase-12-sample | abc1234 | clean | no | Validate only. |\n' >>"$out_of_scope"
perl -0pi -e 's/Validate only\./Merge now./' "$merge_now"

require_success_contains \
  "valid minimal fixture" \
  "Phase 9/10/11 merge matrix check passed." \
  bash "$CHECK" --minimal "$good"

require_failure_contains \
  "missing empirical evidence gate" \
  "missing required text: empirical-run" \
  bash "$CHECK" --minimal "$missing_evidence"

require_failure_contains \
  "out-of-scope branch ref" \
  "out-of-scope later-phase reference found" \
  bash "$CHECK" --minimal "$out_of_scope"

require_failure_contains \
  "immediate merge action" \
  "matrix marks an immediate merge action" \
  bash "$CHECK" --minimal "$merge_now"

echo "PASS: phase9-11 merge matrix fixtures passed ($passes checks)."

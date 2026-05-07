#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/check-research-brief-gates.sh"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

write_brief() {
  local path="$1"
  local include_universal="$2"

  mkdir -p "$(dirname "$path")"
  {
    cat <<'EOF'
# Guard fixture

## Goal

Exercise the research BRIEF guard on a harmless async fixture.

## Required behavior

- Record validation and dry-run output.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or the roadmap.
- Do not target `claim_55`; it is protected and unrelated to this fixture.
- Do not make unsupported SOTA claims without a source ledger and comparability caveat.
EOF
    if [[ "$include_universal" == "yes" ]] ; then
      cat <<'EOF'
- Universal benchmark value: keeps BSEBench plug-and-play, comparable, leakage-safe, provenance-aware, and monthly-benchmark ready.
EOF
    fi
    cat <<'EOF'

## Falsification gate

This task must fail if the validation command cannot verify the guard output.

## Validation

Run `bash scripts/check-research-brief-gates.sh --dry-run` and record the result.
EOF
  } > "$path"
}

assert_passes() {
  local output

  if ! output="$(bash "$SCRIPT" --dry-run "$@" 2>&1)" ; then
    printf '%s\n' "$output" >&2
    echo "Expected gate to pass." >&2
    exit 1
  fi

  if ! grep -Fq '[OK]   universal benchmark value' <<<"$output" ; then
    printf '%s\n' "$output" >&2
    echo "Expected universal benchmark value check to pass." >&2
    exit 1
  fi
}

assert_fails_without_universal_value() {
  local output

  if output="$(bash "$SCRIPT" --dry-run "$1" 2>&1)" ; then
    printf '%s\n' "$output" >&2
    echo "Expected gate to fail without universal benchmark value." >&2
    exit 1
  fi

  if ! grep -Fq '[FAIL] universal benchmark value' <<<"$output" ; then
    printf '%s\n' "$output" >&2
    echo "Expected universal benchmark value failure." >&2
    exit 1
  fi
}

inbox_good="$TMP_DIR/inbox/phase-8-good/BRIEF.md"
backlog_good="$TMP_DIR/cto/AUTONOMY_BACKLOG/phase-11-good/BRIEF.md"
missing_universal="$TMP_DIR/inbox/phase-8-missing-universal/BRIEF.md"

write_brief "$inbox_good" yes
write_brief "$backlog_good" yes
write_brief "$missing_universal" no

assert_passes "$inbox_good" "$backlog_good"
assert_fails_without_universal_value "$missing_universal"

echo "check-research-brief-gates tests passed."

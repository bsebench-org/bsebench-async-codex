#!/usr/bin/env bash
# Fixture checks for check-claim-language.sh and the BRIEF falsification gate.

set -euo pipefail

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pass_fixtures=(
  tests/fixtures/claim-language/pass-neutral.md
  tests/fixtures/claim-language/pass-quoted-examples.md
)

fail_fixtures=(
  tests/fixtures/claim-language/fail-promote-hinf.md
  tests/fixtures/claim-language/fail-sota-breakthrough.md
)

for fixture in "${pass_fixtures[@]}" ; do
  bash scripts/check-claim-language.sh --dry-run "$fixture" >"$tmp_dir/pass.out"
  echo "[OK] expected pass: $fixture"
done

for fixture in "${fail_fixtures[@]}" ; do
  if bash scripts/check-claim-language.sh --dry-run "$fixture" >"$tmp_dir/fail.out" 2>&1 ; then
    echo "[FAIL] expected lint failure: $fixture" >&2
    cat "$tmp_dir/fail.out" >&2
    exit 1
  fi
  echo "[OK] expected fail: $fixture"
done

brief="$tmp_dir/inbox/phase-7-10-lint-falsification/BRIEF.md"
mkdir -p "$(dirname "$brief")"
cat > "$brief" <<'BRIEF'
# Phase 7.10 lint falsification fixture

## Goal

Promote Hinf to a verified claim and target claim_55 in the worker report.

## Required behavior

- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not make SOTA claims without a source ledger and comparability table.
- Do not target `claim_55`.

## Falsification gate

If the guard can miss forbidden claim language, it must fail validation.

## Validation

Run validation and replay checks.
BRIEF

if bash scripts/check-research-brief-gates.sh --dry-run "$brief" >"$tmp_dir/fail.out" 2>&1 ; then
  echo "[FAIL] expected BRIEF falsification fixture to fail" >&2
  cat "$tmp_dir/fail.out" >&2
  exit 1
fi
echo "[OK] expected fail: BRIEF falsification fixture"

echo "Claim language fixture checks passed."

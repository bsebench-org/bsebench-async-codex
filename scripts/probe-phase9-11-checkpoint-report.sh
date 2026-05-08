#!/usr/bin/env bash
# Focused fixtures for the Phase 9/10/11 checkpoint report checker.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$REPO_ROOT/scripts/check-phase9-11-checkpoint-report.sh"
REPORT="$REPO_ROOT/outbox/phase9-11-refill-p9-11-checkpoint-report-20260508T213201+0200/CHECKPOINT.md"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pass_report="$tmp_dir/pass.md"
missing_empirical="$tmp_dir/missing-empirical.md"
unsafe_go="$tmp_dir/unsafe-go.md"
later_phase="$tmp_dir/later-phase.md"
unsupported_language="$tmp_dir/unsupported-language.md"

write_pass_report() {
  local target="$1"

  cat > "$target" <<'EOF'
# Phase 9/10/11 Checkpoint Report - fixture

## Decision

- Overall scientific closure: NO-GO.
- Queueing decision: GO only for fail-closed preflight workers.
- Empirical-run decision: NO-GO until required evidence exists.
- Scientific verdict decision: NO-GO until required evidence exists.

## Closure Percent

| Phase | Scientific closure | Empirical evidence | Verdict evidence | Tooling status |
| --- | ---: | ---: | ---: | --- |
| 9 | 0% | 0% | 0% | partial |
| 10 | 0% | 0% | 0% | partial |
| 11 | 0% | 0% | 0% | partial |

## Evidence Snapshot

- Active queue evidence: fixture.
- Required evidence chain: Tier2 cache provenance, source-ledger, empirical-run evidence.

## Phase Decisions

| Phase | Decision | Evidence | Blockers |
| --- | --- | --- | --- |
| 9 | NO-GO | fixture | empirical outputs missing |
| 10 | NO-GO | fixture | empirical outputs missing |
| 11 | NO-GO | fixture | empirical outputs missing |

## Blockers

- empirical outputs missing.

## Next Queue

1. keep fail-closed preflight workers active.
2. keep cache inventory workers active.
3. keep scheduler workers blocked on evidence.
4. keep verdict workers blocked on evidence.
5. keep source-ledger checks active.
6. keep provenance checks active.
7. keep integration checks active.
8. keep final gate blocked until evidence exists.

## Validation Notes

- fixture validation only.
EOF
}

expect_fail() {
  local label="$1"
  local target="$2"

  if "$CHECK" "$target" > "$tmp_dir/$label.out" 2>&1 ; then
    echo "[FAIL] expected checker failure for $label" >&2
    cat "$tmp_dir/$label.out" >&2
    exit 1
  fi
  echo "[OK]   rejected $label"
}

write_pass_report "$pass_report"
"$CHECK" "$pass_report"

sed '/empirical-run evidence/d' "$pass_report" > "$missing_empirical"
expect_fail "missing-empirical" "$missing_empirical"

sed 's/Overall scientific closure: NO-GO./Overall scientific closure: GO./' "$pass_report" > "$unsafe_go"
expect_fail "unsafe-go" "$unsafe_go"

later_text='Phase 1''2 is out of scope.'
sed "s/Checkpoint Report - fixture/Checkpoint Report - fixture\\n\\n$later_text/" "$pass_report" > "$later_phase"
expect_fail "later-phase" "$later_phase"

forbidden_word='leader''board'
printf '%s\n' "$(<"$pass_report")" "This fixture uses the $forbidden_word word." > "$unsupported_language"
expect_fail "unsupported-language" "$unsupported_language"

"$CHECK" "$REPORT"

echo "Phase 9/10/11 checkpoint report probe passed."

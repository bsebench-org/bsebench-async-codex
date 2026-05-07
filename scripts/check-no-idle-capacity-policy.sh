#!/usr/bin/env bash
# check-no-idle-capacity-policy.sh - sanity check for the async no-idle worker policy.

set -euo pipefail

DEFAULT_POLICY="docs/BSEBENCH-ASYNC-NO-IDLE-CAPACITY-POLICY-2026-05-07.md"

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-no-idle-capacity-policy.sh [--self-test] [POLICY.md]

Checks the BSEBench async no-idle capacity policy for required operator
guardrails: distinct write sets, active-worker conflict checks, reserve backlog,
falsification and validation gates, source-ledger discipline, protected-file
boundaries, and universal benchmark value.
USAGE
}

has_pattern() {
  local path="$1"
  local pattern="$2"
  grep -Eiq "$pattern" "$path"
}

require_pattern() {
  local path="$1"
  local label="$2"
  local pattern="$3"

  if has_pattern "$path" "$pattern" ; then
    echo "  [OK]   $label"
  else
    echo "  [FAIL] $label"
    failures=$((failures + 1))
  fi
}

check_policy() {
  local path="$1"

  failures=0

  if [[ ! -f "$path" ]] ; then
    echo "[FAIL] $path"
    echo "  [FAIL] file does not exist"
    return 1
  fi

  echo "[CHECK] $path"

  require_pattern \
    "$path" \
    "policy title" \
    '^# BSEBench Async No-Idle Capacity Policy'

  require_pattern \
    "$path" \
    "universal benchmark value" \
    'universal benchmark|plug-and-play|comparable metrics|monthly benchmark'

  require_pattern \
    "$path" \
    "distinct write set" \
    'distinct write set|write_set|owned files'

  require_pattern \
    "$path" \
    "active-worker conflict matrix" \
    'active-worker matrix|conflict_check|conflict notes'

  require_pattern \
    "$path" \
    "duplicate/conflicting work guard" \
    'duplicate|conflicting work|same write set|conflict'

  require_pattern \
    "$path" \
    "reserve backlog for idle capacity" \
    'reserve task|reserve backlog|idle capacity|backlog'

  require_pattern \
    "$path" \
    "falsification gate" \
    'falsification gate|falsification_gate'

  require_pattern \
    "$path" \
    "validation gate or dry-run" \
    'validation gate|validation_gate|dry-run|doc sanity'

  require_pattern \
    "$path" \
    "source ledger guardrail" \
    'source ledger|stable URL|DOI|comparability caveat'

  require_pattern \
    "$path" \
    "protected-file guardrail" \
    'thesis|claim registry|claims/registry\.yaml|claim_55|roadmap'

  require_pattern \
    "$path" \
    "expensive evidence backoff" \
    'expensive empirical|expensive-evidence|evidence budget'

  require_pattern \
    "$path" \
    "stop or backoff condition" \
    'Stop Or Backoff|Pause new worker launch|Backoff'

  if [[ "$failures" -gt 0 ]] ; then
    echo "No-idle capacity policy sanity failed: $failures failure(s)." >&2
    return 1
  fi

  echo "No-idle capacity policy sanity passed."
}

self_test() {
  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN

  local valid="$tmpdir/valid-policy.md"
  local invalid="$tmpdir/invalid-policy.md"

  cat >"$valid" <<'EOF_VALID'
# BSEBench Async No-Idle Capacity Policy

This universal benchmark policy keeps plug-and-play comparable metrics and
monthly benchmark readiness visible.

## Dispatch Rule

Workers need a distinct write set, write_set, active-worker matrix,
conflict_check, falsification gate, falsification_gate, validation gate,
validation_gate, dry-run, reserve task, reserve backlog, idle capacity,
duplicate conflict notes, source ledger with stable URL, DOI, and comparability
caveat. Protected files include thesis, claim registry, claims/registry.yaml,
claim_55, and roadmap. Avoid expensive empirical work and expensive-evidence
without an evidence budget.

## Stop Or Backoff Conditions

Pause new worker launch. Backoff.
EOF_VALID

  cat >"$invalid" <<'EOF_INVALID'
# BSEBench Async No-Idle Capacity Policy

Keep workers busy.
EOF_INVALID

  echo "[SELF-TEST] valid fixture should pass"
  check_policy "$valid" >/dev/null

  echo "[SELF-TEST] invalid fixture should fail"
  if check_policy "$invalid" >/dev/null 2>&1 ; then
    echo "Self-test failed: invalid fixture passed." >&2
    return 1
  fi

  echo "No-idle capacity policy self-test passed."
}

policy_path="$DEFAULT_POLICY"
self_test_only=0

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --self-test)
      self_test_only=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      policy_path="$1"
      ;;
  esac
  shift
done

if [[ "$self_test_only" -eq 1 ]] ; then
  self_test
fi

check_policy "$policy_path"

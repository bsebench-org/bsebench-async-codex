#!/usr/bin/env bash
# probe-phase9-11-acceptance-gate.sh - isolated fixtures for the P9/10/11 gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE="$SCRIPT_DIR/check-phase9-11-acceptance-gate.sh"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/bsebench-p9-11-gate.XXXXXX")"

trap 'rm -rf "$TMP_ROOT"' EXIT

passes=0

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local label="$3"

  if [[ "$haystack" != *"$needle"* ]] ; then
    printf '%s\n' "$haystack" >&2
    fail "$label: missing [$needle]"
  fi
}

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@" 2>&1)" ; then
    echo "$output" >&2
    fail "$name expected success"
  fi
  assert_contains "$output" "$needle" "$name"
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
    echo "$output" >&2
    fail "$name expected failure"
  fi
  assert_contains "$output" "$needle" "$name"
  echo "PASS: $name"
  passes=$((passes + 1))
}

write_evidence() {
  local root="$1"
  local path="$2"
  local kind="$3"
  local phase="$4"

  mkdir -p "$(dirname "$root/$path")"
  case "$kind" in
    preflight_or_contract)
      cat > "$root/$path" <<EOF
Phase $phase preflight contract gate artifact.
validation command: pytest focused contract tests passed.
commit sha: 0123456789abcdef0123456789abcdef01234567
EOF
      ;;
    validation_gates)
      cat > "$root/$path" <<EOF
Phase $phase validation gates.
pytest passed; ruff check passed; ruff format --check passed; git diff --check passed.
artifact hash sha256: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
EOF
      ;;
    tier2_cache)
      cat > "$root/$path" <<EOF
Phase $phase Tier2 cache evidence.
tier2 cache ready and readable for the accepted local matrix.
artifact hash sha256: bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
EOF
      ;;
    provenance)
      cat > "$root/$path" <<EOF
Phase $phase provenance evidence.
provenance manifest source identity includes commit and sha256 hash.
source manifest: manifests/phase-$phase.yaml
EOF
      ;;
    source_ledger)
      cat > "$root/$path" <<EOF
Phase $phase source ledger.
source_id phase-$phase-ledger-row has stable url https://example.invalid/phase-$phase, retrieved_at 2026-05-08.
metric, dataset, split, reported_value, bsebench_value, and comparability table caveat are recorded.
EOF
      ;;
    empirical_run)
      cat > "$root/$path" <<EOF
Phase $phase empirical run evidence.
empirical run artifact output has replay command, run_id phase-$phase-run-001, and sha256 hash.
trace artifact path: outbox/phase-$phase/evidence.json
EOF
      ;;
    *)
      fail "unknown evidence kind: $kind"
      ;;
  esac
}

write_full_checklist() {
  local root="$1"
  local checklist="$root/outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt"
  local phase
  local requirement
  local path

  mkdir -p "$(dirname "$checklist")"
  : > "$checklist"
  for phase in 9 10 11 ; do
    for requirement in preflight_or_contract validation_gates ; do
      path="outbox/phase-$phase/tooling-$requirement.md"
      write_evidence "$root" "$path" "$requirement" "$phase"
      printf 'phase=%s lane=tooling requirement=%s status=pass evidence=%s\n' \
        "$phase" "$requirement" "$path" >> "$checklist"
    done
    for requirement in tier2_cache provenance source_ledger empirical_run ; do
      path="outbox/phase-$phase/scientific-$requirement.md"
      write_evidence "$root" "$path" "$requirement" "$phase"
      printf 'phase=%s lane=scientific requirement=%s status=pass evidence=%s\n' \
        "$phase" "$requirement" "$path" >> "$checklist"
    done
  done
}

make_fixture() {
  local name="$1"
  local root="$TMP_ROOT/$name"

  mkdir -p "$root/outbox"
  printf '%s\n' "$root"
}

run_gate() {
  local root="$1"

  bash "$GATE" --repo "$root" 2>&1
}

all_pass_fixture() {
  local root
  root="$(make_fixture all-pass)"
  write_full_checklist "$root"
  run_gate "$root"
}

tooling_only_fixture() {
  local root
  local checklist
  local phase
  local requirement
  local path

  root="$(make_fixture tooling-only)"
  checklist="$root/outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt"
  mkdir -p "$(dirname "$checklist")"
  : > "$checklist"
  for phase in 9 10 11 ; do
    for requirement in preflight_or_contract validation_gates ; do
      path="outbox/phase-$phase/tooling-$requirement.md"
      write_evidence "$root" "$path" "$requirement" "$phase"
      printf 'phase=%s lane=tooling requirement=%s status=pass evidence=%s\n' \
        "$phase" "$requirement" "$path" >> "$checklist"
    done
  done
  run_gate "$root"
}

empirical_dry_run_fixture() {
  local root
  local evidence

  root="$(make_fixture dry-run-science)"
  write_full_checklist "$root"
  evidence="$root/outbox/phase-10/scientific-empirical_run.md"
  cat > "$evidence" <<'EOF'
Phase 10 empirical dry-run scheduler output.
dry-run only; no empirical artifact exists.
run_id phase-10-dry-run; sha256 hash unavailable.
EOF
  run_gate "$root"
}

phase12_fixture() {
  local root
  local checklist

  root="$(make_fixture phase12)"
  write_full_checklist "$root"
  checklist="$root/outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt"
  printf 'phase=12 lane=scientific requirement=empirical_run status=pass evidence=outbox/phase-12/evidence.md\n' >> "$checklist"
  run_gate "$root"
}

banned_claim_fixture() {
  local root
  local evidence

  root="$(make_fixture banned-claim)"
  write_full_checklist "$root"
  evidence="$root/outbox/phase-9/scientific-source_ledger.md"
  cat > "$evidence" <<'EOF'
This result is SOTA and a public benchmark winner.
source ledger source_id row stable url https://example.invalid, retrieved_at 2026-05-08, metric, dataset, split, reported_value, bsebench_value, comparability table, caveat.
EOF
  run_gate "$root"
}

absolute_evidence_fixture() {
  local root
  local checklist

  root="$(make_fixture absolute-evidence)"
  write_full_checklist "$root"
  checklist="$root/outbox/phase-9-10-11-acceptance-gate/ACCEPTANCE_CHECKLIST.txt"
  sed -i '0,/phase=9 lane=scientific requirement=tier2_cache/{s#evidence=[^ ]*#evidence=/tmp/not-committed.md#}' "$checklist"
  run_gate "$root"
}

require_success_contains \
  "full acceptance fixture" \
  "Overall acceptance: PASS" \
  all_pass_fixture

require_failure_contains \
  "tooling does not imply scientific closure" \
  "Phase 9: tooling=PASS scientific=NO-GO missing_scientific=tier2_cache,provenance,source_ledger,empirical_run" \
  tooling_only_fixture

require_failure_contains \
  "empirical dry-run evidence fails closed" \
  "10|scientific|empirical_run: evidence contains dry-run, synthetic-only, blocked, or missing empirical evidence" \
  empirical_dry_run_fixture

require_failure_contains \
  "phase 12 is rejected" \
  "phase must be one of 9, 10, or 11; got 12" \
  phase12_fixture

require_failure_contains \
  "banned public claim language fails" \
  "evidence contains unsupported public-claim language" \
  banned_claim_fixture

require_failure_contains \
  "absolute evidence path fails" \
  "evidence path must be repo-relative without parent traversal" \
  absolute_evidence_fixture

printf '\nPASS: Phase 9/10/11 acceptance gate probes passed (%d checks).\n' "$passes"

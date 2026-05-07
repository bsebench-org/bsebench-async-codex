#!/usr/bin/env bash
# probe-autonomy-pacer-safety.sh - isolated dry-run probes for pacer guardrails.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/bsebench-pacer-probe.XXXXXX")"

trap 'rm -rf "$TMP_ROOT"' EXIT

FIX_ROOT=""
FIX_ASYNC=""
FIX_ACTIVE=""
FIX_WORKER_2=""
FIX_STATE=""

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

section() {
  printf '\n## %s\n' "$*"
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

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local label="$3"

  if [[ "$haystack" == *"$needle"* ]] ; then
    printf '%s\n' "$haystack" >&2
    fail "$label: unexpected [$needle]"
  fi
}

assert_clean_repo() {
  local status
  status="$(git -C "$FIX_ASYNC" status --short)"
  [[ -z "$status" ]] || fail "fixture repo is dirty: $status"
}

make_fixture() {
  local name="$1"

  FIX_ROOT="$TMP_ROOT/$name/root"
  FIX_ASYNC="$FIX_ROOT/bsebench-async-codex"
  FIX_ACTIVE="$FIX_ROOT/bsebench-async-codex-active"
  FIX_WORKER_2="$FIX_ROOT/bsebench-async-codex-worker-2"
  FIX_STATE="$TMP_ROOT/$name/state"

  mkdir -p \
    "$FIX_ASYNC/scripts" \
    "$FIX_ASYNC/cto/AUTONOMY_BACKLOG" \
    "$FIX_ASYNC/inbox" \
    "$FIX_ASYNC/outbox/_blocks" \
    "$FIX_ACTIVE/scripts" \
    "$FIX_WORKER_2/scripts" \
    "$FIX_STATE"

  cp "$SOURCE_REPO/scripts/cto-autonomy-pacer.sh" "$FIX_ASYNC/scripts/cto-autonomy-pacer.sh"
  cp "$SOURCE_REPO/scripts/check-research-brief-gates.sh" "$FIX_ASYNC/scripts/check-research-brief-gates.sh"
  chmod +x "$FIX_ASYNC/scripts/cto-autonomy-pacer.sh" "$FIX_ASYNC/scripts/check-research-brief-gates.sh"

  printf '#!/usr/bin/env bash\nexit 0\n' > "$FIX_ACTIVE/scripts/worker-daemon.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$FIX_WORKER_2/scripts/worker-daemon.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$FIX_WORKER_2/scripts/chef-daemon.sh"
  chmod +x \
    "$FIX_ACTIVE/scripts/worker-daemon.sh" \
    "$FIX_WORKER_2/scripts/worker-daemon.sh" \
    "$FIX_WORKER_2/scripts/chef-daemon.sh"

  : > "$FIX_ASYNC/HISTORY.md"
  git -C "$FIX_ASYNC" init -q
  git -C "$FIX_ASYNC" config user.email "pacer-probe@example.invalid"
  git -C "$FIX_ASYNC" config user.name "Pacer Probe"
  git -C "$FIX_ASYNC" add .
  git -C "$FIX_ASYNC" commit -qm "initial probe fixture"
}

commit_fixture() {
  git -C "$FIX_ASYNC" add .
  git -C "$FIX_ASYNC" commit -qm "$1"
  assert_clean_repo
}

write_running_status() {
  local phase_id="$1"
  local status="${2:-running}"
  local dir="$FIX_ASYNC/inbox/$phase_id"
  local now
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  mkdir -p "$dir"
  cat > "$dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "$status",
  "ts_queued": "$now",
  "ts_started": "$now",
  "worker_id": "probe"
}
EOF
}

write_good_brief() {
  local phase_id="$1"
  local dir="$FIX_ASYNC/cto/AUTONOMY_BACKLOG/$phase_id"

  mkdir -p "$dir"
  cat > "$dir/BRIEF.md" <<EOF
---
target_repo: $FIX_ROOT/target
target_branch: $phase_id
base_branch: main
hard_wallclock_min: 5
---

# $phase_id

## Goal

Exercise the autonomy pacer guardrails with a harmless validation task.

## Required behavior

- Record a validation command and dry-run output.
- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.
- Universal benchmark value: keeps BSEBench plug-and-play, comparable, leakage-safe, provenance-aware, and monthly-benchmark ready.

## Falsification gate

If the validation command cannot verify the guardrail outcome, this task must fail.

## Validation

Run and record \`bash scripts/check-research-brief-gates.sh --dry-run $dir/BRIEF.md\`.
EOF
}

write_bad_brief() {
  local phase_id="$1"
  local dir="$FIX_ASYNC/cto/AUTONOMY_BACKLOG/$phase_id"

  mkdir -p "$dir"
  cat > "$dir/BRIEF.md" <<EOF
---
target_repo: $FIX_ROOT/target
target_branch: $phase_id
base_branch: main
hard_wallclock_min: 5
---

# $phase_id

## Goal

This intentionally malformed probe lacks the required guardrail wording.

## Required behavior

- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.
EOF
}

run_pacer() {
  env \
    BSEBENCH_ROOT="$FIX_ROOT" \
    ASYNC_REPO="$FIX_ASYNC" \
    ASYNC_ACTIVE="$FIX_ACTIVE" \
    ASYNC_WORKER_2="$FIX_WORKER_2" \
    STATE_DIR="$FIX_STATE" \
    MIN_RUNNING=2 \
    MIN_QUEUED=1 \
    MIN_RESERVE=3 \
    MAX_QUEUE_PER_TICK=3 \
    STALE_RUNNING_MIN=180 \
    bash "$FIX_ASYNC/scripts/cto-autonomy-pacer.sh" --dry-run 2>&1
}

section "status-only running tasks do not satisfy codex capacity"
make_fixture "reserve-waiting"
write_running_status "phase-7-probe-running-a"
write_running_status "phase-7-probe-running-b"
write_good_brief "phase-7-probe-good-a"
write_good_brief "phase-7-probe-good-b"
write_good_brief "phase-7-probe-good-c"
commit_fixture "reserve waiting scenario"
reserve_output="$(run_pacer)"
printf '%s\n' "$reserve_output"
assert_contains "$reserve_output" "codex_exec=0 status_running=2 fresh_running=2 effective_running=0 queued=0 reserve=3 blocks=0 needed=3" "reserve snapshot"
assert_contains "$reserve_output" "QUEUE reserve task: phase-7-probe-good-a" "reserve queue"
assert_contains "$reserve_output" "QUEUE reserve task: phase-7-probe-good-b" "reserve second queue"
assert_contains "$reserve_output" "QUEUE reserve task: phase-7-probe-good-c" "reserve third queue"
assert_contains "$reserve_output" "DRY-RUN would commit queued=phase-7-probe-good-a,phase-7-probe-good-b,phase-7-probe-good-c" "reserve dry run"
assert_clean_repo

section "block queues remediation only"
make_fixture "block-present"
write_good_brief "phase-7-probe-good-a"
write_good_brief "phase-7-probe-good-b"
write_good_brief "phase-7-probe-good-c"
touch "$FIX_ASYNC/outbox/_blocks/probe.block"
commit_fixture "block scenario"
block_output="$(run_pacer)"
printf '%s\n' "$block_output"
assert_contains "$block_output" "blocks=1" "block snapshot"
assert_contains "$block_output" "QUEUE block remediation task" "block remediation queue"
assert_contains "$block_output" "DRY-RUN would commit queued=phase-7-10-y-block-remediation-" "block remediation dry run"
assert_not_contains "$block_output" "QUEUE reserve task" "normal backlog queue while blocked"
assert_clean_repo

section "idle empty reserve bypasses replenishment cooldown"
make_fixture "idle-empty-reserve"
write_running_status "phase-7-10-z-autonomy-backlog-replenishment-19700101T000000Z" "running"
commit_fixture "idle empty reserve scenario"
idle_output="$(run_pacer)"
printf '%s\n' "$idle_output"
assert_contains "$idle_output" "codex_exec=0 status_running=1" "idle reserve snapshot"
assert_contains "$idle_output" "RESERVE_LOW reserve=0 force_replenishment=1 reason=no_real_codex_no_queue" "forced replenishment"
assert_contains "$idle_output" "QUEUE replenishment task: reserve=0" "forced replenishment queue"
assert_contains "$idle_output" "DRY-RUN would commit queued=phase-7-10-z-autonomy-backlog-replenishment-" "forced replenishment dry run"
assert_clean_repo

section "bad brief is skipped before queueing"
make_fixture "bad-brief"
write_running_status "phase-7-probe-running-a"
write_running_status "phase-7-probe-running-b"
write_bad_brief "phase-7-probe-bad-a"
write_bad_brief "phase-6-probe-unsafe"
write_good_brief "phase-7-probe-good-b"
write_good_brief "phase-7-probe-good-c"
write_good_brief "phase-7-probe-good-d"
commit_fixture "bad brief scenario"
bad_output="$(run_pacer)"
printf '%s\n' "$bad_output"
assert_contains "$bad_output" "SKIP research gate failed: phase-7-probe-bad-a" "bad brief gate"
assert_not_contains "$bad_output" "QUEUE reserve task: phase-7-probe-bad-a" "bad brief queue"
assert_not_contains "$bad_output" "phase-6-probe-unsafe" "non-research phase candidate"
assert_contains "$bad_output" "QUEUE reserve task: phase-7-probe-good-b" "good fallback queue"
assert_contains "$bad_output" "QUEUE reserve task: phase-7-probe-good-c" "second good fallback queue"
assert_contains "$bad_output" "QUEUE reserve task: phase-7-probe-good-d" "third good fallback queue"
assert_contains "$bad_output" "DRY-RUN would commit queued=phase-7-probe-good-b,phase-7-probe-good-c,phase-7-probe-good-d" "bad brief dry run"
assert_clean_repo

printf '\nPASS: autonomy pacer dry-run safety probes passed.\n'

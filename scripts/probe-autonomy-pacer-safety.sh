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

assert_line_contains() {
  local haystack="$1"
  local include_a="$2"
  local include_b="$3"
  local label="$4"

  if ! grep -F "$include_a" <<<"$haystack" | grep -F "$include_b" >/dev/null ; then
    printf '%s\n' "$haystack" >&2
    fail "$label: missing line with [$include_a] and [$include_b]"
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

  git -C "$FIX_ROOT" init -q target
  git -C "$FIX_ROOT/target" config user.email "pacer-probe@example.invalid"
  git -C "$FIX_ROOT/target" config user.name "Pacer Probe"
  printf 'probe target\n' > "$FIX_ROOT/target/README.md"
  git -C "$FIX_ROOT/target" add README.md
  git -C "$FIX_ROOT/target" commit -qm "initial target fixture"

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
  local dir="$FIX_ASYNC/inbox/$phase_id"
  local now
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  mkdir -p "$dir"
  cat > "$dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "running",
  "ts_queued": "$now",
  "ts_started": "$now",
  "worker_id": "probe"
}
EOF
}

write_good_brief() {
  local phase_id="$1"
  local target_branch="${2:-$phase_id}"
  local dir="$FIX_ASYNC/cto/AUTONOMY_BACKLOG/$phase_id"

  mkdir -p "$dir"
  cat > "$dir/BRIEF.md" <<EOF
---
target_repo: $FIX_ROOT/target
target_branch: $target_branch
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

## Falsification gate

If the validation command cannot verify the guardrail outcome, this task must fail.

## Validation

Run and record \`bash scripts/check-research-brief-gates.sh --dry-run $dir/BRIEF.md\`.
EOF
}

write_malformed_brief() {
  local phase_id="$1"
  local dir="$FIX_ASYNC/cto/AUTONOMY_BACKLOG/$phase_id"

  mkdir -p "$dir"
  cat > "$dir/BRIEF.md" <<EOF
---
target_repo: $FIX_ROOT/target
base_branch: main
hard_wallclock_min: 5
---

# $phase_id

## Goal

This probe has missing target branch frontmatter.

## Required behavior

- Do not target \`claim_55\`; \`claim_55\` is protected and unrelated.
- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If the malformed frontmatter is counted as queueable, this probe must fail.

## Validation

Run and record \`bash scripts/check-research-brief-gates.sh --dry-run $dir/BRIEF.md\`.
EOF
}

write_no_falsification_brief() {
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

Exercise a BRIEF that intentionally omits the required negative gate.

## Required behavior

- Do not target \`claim_55\`; \`claim_55\` is protected and unrelated.
- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Validation

Run and record \`bash scripts/check-research-brief-gates.sh --dry-run $dir/BRIEF.md\`.
EOF
}

write_no_validation_brief() {
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

Exercise a BRIEF that intentionally omits the required command wording.

## Required behavior

- Do not target \`claim_55\`; \`claim_55\` is protected and unrelated.
- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, \`claim_55\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If this guardrail-negative BRIEF is counted as queueable, this probe must fail.
EOF
}

write_claim55_target_brief() {
  local phase_id="$1"
  local dir="$FIX_ASYNC/cto/AUTONOMY_BACKLOG/$phase_id"

  mkdir -p "$dir"
  cat > "$dir/BRIEF.md" <<EOF
---
target_repo: $FIX_ROOT/target
target_branch: ${phase_id}-claim_55
base_branch: main
hard_wallclock_min: 5
---

# $phase_id

## Goal

Target \`claim_55\` for a protected-claim dry-run negative probe.

## Required behavior

- Do not edit thesis files, claim registry files, \`claims/registry.yaml\`, or the roadmap.
- Do not make SOTA, novelty, or verified-claim statements without a source ledger and comparability table.

## Falsification gate

If a protected \`claim_55\` target is counted as queueable, this probe must fail.

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

section "reserve keeps one waiting task"
make_fixture "reserve-waiting"
write_running_status "phase-7-probe-running-a"
write_running_status "phase-7-probe-running-b"
write_good_brief "phase-7-probe-good-a"
write_good_brief "phase-7-probe-good-b"
write_good_brief "phase-7-probe-good-c"
commit_fixture "reserve waiting scenario"
reserve_output="$(run_pacer)"
printf '%s\n' "$reserve_output"
assert_contains "$reserve_output" "effective_running=2 queued=0 reserve=3 blocks=0 needed=1" "reserve snapshot"
assert_contains "$reserve_output" "QUEUE reserve task: phase-7-probe-good-a" "reserve queue"
assert_contains "$reserve_output" "DRY-RUN would commit queued=phase-7-probe-good-a" "reserve dry run"
assert_not_contains "$reserve_output" "QUEUE reserve task: phase-7-probe-good-b" "reserve overqueue"
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
assert_line_contains "$bad_output" "phase=phase-7-probe-bad-a" "reason=missing_falsification_gate,missing_validation_command" "bad brief gate"
assert_not_contains "$bad_output" "QUEUE reserve task: phase-7-probe-bad-a" "bad brief queue"
assert_not_contains "$bad_output" "phase-6-probe-unsafe" "non-research phase candidate"
assert_contains "$bad_output" "QUEUE reserve task: phase-7-probe-good-b" "good fallback queue"
assert_contains "$bad_output" "DRY-RUN would commit queued=phase-7-probe-good-b" "bad brief dry run"
assert_clean_repo

section "reserve candidate skip reasons and count"
make_fixture "reserve-skip-reasons"
write_running_status "phase-7-probe-running-a"
write_running_status "phase-7-probe-running-b"
write_good_brief "phase-7-probe-good-queueable"
write_good_brief "phase-7-probe-queued-marker"
cat > "$FIX_ASYNC/cto/AUTONOMY_BACKLOG/phase-7-probe-queued-marker/QUEUED.json" <<EOF
{
  "phase_id": "phase-7-probe-queued-marker",
  "queued_at": "2026-05-07T00:00:00Z",
  "queued_by": "probe",
  "inbox": "inbox/phase-7-probe-queued-marker"
}
EOF
write_good_brief "phase-7-probe-inbox-exists"
mkdir -p "$FIX_ASYNC/inbox/phase-7-probe-inbox-exists"
write_good_brief "phase-7-probe-claimed-branch"
git -C "$FIX_ROOT/target" branch "phase-7-probe-claimed-branch"
write_malformed_brief "phase-7-probe-malformed"
write_no_falsification_brief "phase-7-probe-no-failgate"
write_no_validation_brief "phase-7-probe-no-runcmd"
write_claim55_target_brief "phase-7-probe-claim55-target"
commit_fixture "reserve skip reason matrix"
skip_output="$(run_pacer)"
printf '%s\n' "$skip_output"
assert_contains "$skip_output" "effective_running=2 queued=0 reserve=1 blocks=0 needed=1" "reserve guard count"
assert_line_contains "$skip_output" "phase=phase-7-probe-queued-marker" "reason=queued_marker_present" "queued marker skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-inbox-exists" "reason=inbox_already_exists" "inbox skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-claimed-branch" "reason=target_branch_already_claimed" "claimed branch skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-malformed" "reason=malformed_frontmatter" "malformed skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-no-failgate" "reason=missing_falsification_gate" "falsification skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-no-runcmd" "reason=missing_validation_command" "validation skip"
assert_line_contains "$skip_output" "phase=phase-7-probe-claim55-target" "reason=protected_claim_55_targeting" "claim_55 skip"
assert_contains "$skip_output" "QUEUE reserve task: phase-7-probe-good-queueable" "queueable reserve brief"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-queued-marker" "queued marker not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-inbox-exists" "inbox brief not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-claimed-branch" "claimed branch not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-malformed" "malformed brief not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-no-failgate" "missing falsification not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-no-runcmd" "missing validation not queued"
assert_not_contains "$skip_output" "QUEUE reserve task: phase-7-probe-claim55-target" "claim_55 brief not queued"
assert_clean_repo

printf '\nPASS: autonomy pacer dry-run safety probes passed.\n'

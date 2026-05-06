#!/usr/bin/env bash
# remote-worker.sh — async codex worker. Run via cron / worker-daemon every 60 s.
#
# Responsibilities :
#   1. flock-guard : one instance at a time
#   2. git pull this repo
#   3. find first inbox/<id>/STATUS.json with status == "queued"
#   4. parse YAML frontmatter from BRIEF.md
#   5. mark "running", push, run codex with bypass flag, capture log
#   6. push the resulting branch on the target repo
#   7. write outbox/<id>/SUMMARY.md + run.log.tail
#   8. mark "done" (or "error" on non-zero exit)
#
# Crash safety (added 2026-05-06 after canary diagnostic) : ERR trap writes
# status=error + pushes BEFORE exiting if any command fails after the phase
# has been marked running. This prevents phases from getting fossilized in
# "running" forever when an intermediate step (git fetch, worktree add, ...)
# fails.

set -uo pipefail

ASYNC_REPO="${ASYNC_REPO:-$HOME/bsebench-async-codex}"
WORKER_ID="${WORKER_ID:-france-personal}"
LOCK_FILE="${REMOTE_WORKER_LOCK_FILE:-/tmp/codex-async-worker-${WORKER_ID}.lock}"
LOG_TAIL_LINES=200
DEFAULT_WALLCLOCK_MIN=90

# Initialized later when a phase is picked
queued_phase=""
status_file=""
phase_marked_running=0

# ------------------------------------------------------------------ ERR trap
# If anything fails after we've marked a phase running, write status=error
# with a forensic note and push. Without this, the script exits silently and
# the STATUS stays "running" forever.
on_error() {
  local exit_code=$?
  local lineno="${1:-?}"
  if [[ "$phase_marked_running" -eq 1 && -n "$queued_phase" && -f "$status_file" ]] ; then
    cd "$ASYNC_REPO" 2>/dev/null || exit "$exit_code"
    jq --arg w "$WORKER_ID" --argjson c "$exit_code" --arg ln "$lineno" \
       '.status="error"|.ts_done=(now|todate)|.exit_code=$c|.worker_id=$w|.error_at_line=$ln' \
       "$status_file" > "$status_file.tmp" 2>/dev/null && mv "$status_file.tmp" "$status_file"
    git add "$status_file" 2>/dev/null
    git commit -m "chore(async): worker crash on $queued_phase

[role: worker-FR]

ERR trap fired at remote-worker.sh:$lineno with exit $exit_code AFTER phase had been marked running. Forensic SUMMARY.md written to outbox/ before exit." --quiet 2>/dev/null
    git push origin main --quiet 2>/dev/null || true

    # Best-effort outbox note for forensic visibility
    mkdir -p "outbox/$queued_phase" 2>/dev/null
    cat > "outbox/$queued_phase/SUMMARY.md" <<NOTE 2>/dev/null
# Phase $queued_phase summary (worker crash)

- Worker : $WORKER_ID
- Crash exit code : $exit_code
- Crash line in remote-worker.sh : $lineno
- Pre-crash phase progress : marked running, but a step before "codex exec" failed.
- Most likely cause : git fetch / git worktree add / cd to target_repo failed.

## Recovery

The chef should re-queue this phase as <phase-id>-fix-1 with the same BRIEF.
The worker script is now ERR-trap-safe ; the next attempt will surface a clean
status=error if the same problem recurs.
NOTE
    git add "outbox/$queued_phase/" 2>/dev/null
    git commit -m "chore(async): forensic SUMMARY on $queued_phase

[role: worker-FR]

Companion to the ERR trap commit above : SUMMARY.md captures the pre-crash state for chef diagnosis." --quiet 2>/dev/null
    git push origin main --quiet 2>/dev/null || true
  fi
  exit "$exit_code"
}
trap 'on_error $LINENO' ERR

# ------------------------------------------------------------------ flock
exec 9>"$LOCK_FILE"
if ! flock -n 9 ; then
  # another worker tick is already running — bail silently
  exit 0
fi

# ------------------------------------------------------------------ pull
cd "$ASYNC_REPO"
git fetch origin main --quiet
git reset --hard origin/main --quiet

# ------------------------------------------------------------------ pick a queued phase
queued_phase=""
for status_path in inbox/*/STATUS.json ; do
  [[ -f "$status_path" ]] || continue
  status=$(jq -r '.status' "$status_path" 2>/dev/null || echo "")
  if [[ "$status" == "queued" ]] ; then
    queued_phase=$(basename "$(dirname "$status_path")")
    break
  fi
done

if [[ -z "$queued_phase" ]] ; then
  # nothing to do
  exit 0
fi

phase_dir="inbox/$queued_phase"
brief="$phase_dir/BRIEF.md"
status_file="$phase_dir/STATUS.json"

if [[ ! -f "$brief" ]] ; then
  # malformed inbox entry — mark error and continue
  jq --arg id "$queued_phase" \
     '.status="error"|.ts_done=(now|todate)|.exit_code=-1|.worker_id=$WORKER_ID' \
     "$status_file" > "$status_file.tmp"
  mv "$status_file.tmp" "$status_file"
  git add "$status_file"
  git commit -m "chore(async): malformed inbox $queued_phase

[role: worker-FR]

BRIEF.md missing or unreadable in inbox/$queued_phase/. Status set to error, exit_code=-1." --quiet
  git push origin main --quiet
  exit 0
fi

# ------------------------------------------------------------------ parse YAML frontmatter
target_repo=$(awk '/^---$/{flag=!flag; next} flag && /^target_repo:/{print $2; exit}' "$brief")
target_branch=$(awk '/^---$/{flag=!flag; next} flag && /^target_branch:/{print $2; exit}' "$brief")
base_branch=$(awk '/^---$/{flag=!flag; next} flag && /^base_branch:/{print $2; exit}' "$brief" || echo "main")
hard_wallclock_min=$(awk '/^---$/{flag=!flag; next} flag && /^hard_wallclock_min:/{print $2; exit}' "$brief" || echo "$DEFAULT_WALLCLOCK_MIN")

if [[ -z "$target_repo" || -z "$target_branch" ]] ; then
  jq --arg w "$WORKER_ID" \
     '.status="error"|.ts_done=(now|todate)|.exit_code=-2|.worker_id=$w' \
     "$status_file" > "$status_file.tmp"
  mv "$status_file.tmp" "$status_file"
  git add "$status_file"
  git commit -m "chore(async): missing frontmatter $queued_phase

[role: worker-FR]

BRIEF.md present but missing target_repo or target_branch in YAML frontmatter. Status=error, exit_code=-2." --quiet
  git push origin main --quiet
  exit 0
fi

# parse add_dir list (optional) — collect into a bash array
add_dirs=()
while IFS= read -r line ; do
  [[ -n "$line" ]] && add_dirs+=("$line")
done < <(awk '/^---$/{flag=!flag; next} flag && /^  - /{sub(/^  - /,""); print; next} flag && /^add_dir:/{}' "$brief")

# ------------------------------------------------------------------ mark running
jq --arg w "$WORKER_ID" --arg tr "$target_repo" --arg tb "$target_branch" --arg bb "$base_branch" \
   '.status="running"|.ts_started=(now|todate)|.worker_id=$w|.target_repo=$tr|.target_branch=$tb|.base_branch=$bb' \
   "$status_file" > "$status_file.tmp"
mv "$status_file.tmp" "$status_file"
git add "$status_file"
git commit -m "chore(async): start $queued_phase on $WORKER_ID

[role: worker-FR]

Picked up status=queued, marked running at $(date -Iseconds), parsed YAML frontmatter (target_repo=$target_repo, target_branch=$target_branch, base_branch=$base_branch, hard_wallclock_min=$hard_wallclock_min)." --quiet
if ! git push origin main --quiet ; then
  # push raced with another worker — abandon and retry next tick
  git pull --rebase --quiet
  exit 0
fi

# Arm the ERR trap : from this point on, any failure must mark status=error.
phase_marked_running=1

# ------------------------------------------------------------------ set up worktree on target repo
target_repo_dir=$(eval echo "$target_repo")  # expand $HOME, ~, etc.
if [[ ! -d "$target_repo_dir/.git" ]] ; then
  jq --arg w "$WORKER_ID" \
     '.status="error"|.ts_done=(now|todate)|.exit_code=-3|.worker_id=$w' \
     "$status_file" > "$status_file.tmp"
  mv "$status_file.tmp" "$status_file"
  git add "$status_file"
  git commit -m "chore(async): target_repo not found $target_repo_dir

[role: worker-FR]

Phase $queued_phase BRIEF specifies target_repo $target_repo_dir but it does not exist on this PC. Status=error, exit_code=-3." --quiet
  git push origin main --quiet
  exit 0
fi

cd "$target_repo_dir"
git fetch origin --quiet
worktree_path="$(dirname "$target_repo_dir")/$(basename "$target_repo_dir")-$target_branch"

# clean any pre-existing worktree at that path
git worktree remove "$worktree_path" --force 2>/dev/null || true
git branch -D "$target_branch" 2>/dev/null || true

git worktree add -b "$target_branch" "$worktree_path" "origin/$base_branch"

# ------------------------------------------------------------------ run codex
cd "$ASYNC_REPO"
log_file=$(mktemp)
codex_exit=0

add_dir_args=()
for d in "${add_dirs[@]}" ; do
  add_dir_args+=(--add-dir "$d")
done

wallclock_sec=$((hard_wallclock_min * 60))

# `--kill-after=30s` escalates SIGTERM -> SIGKILL after 30 s if codex
# does not respond to SIGTERM (e.g., bloqué sur network / file lock /
# child wait). Without this flag, GNU timeout sends ONLY SIGTERM and
# never SIGKILL, leaving codex hung indefinitely.
# Bug surfaced 2026-05-06 13:11 UTC on phase-async-canary-fix-1 (token
# consumption stagnated = hang dur, no SIGTERM response).
set +e
timeout --kill-after=30s "${wallclock_sec}s" codex exec \
  --dangerously-bypass-approvals-and-sandbox \
  -c 'model="gpt-5.5"' \
  -c 'model_reasoning_effort="xhigh"' \
  -C "$worktree_path" \
  "${add_dir_args[@]}" \
  < "$brief" > "$log_file" 2>&1
codex_exit=$?
set -e

# ------------------------------------------------------------------ push the resulting branch
cd "$worktree_path"
push_result="not-attempted"
branch_sha=""
if git rev-parse HEAD >/dev/null 2>&1 ; then
  branch_sha=$(git rev-parse HEAD)
fi

push_stderr=""
if [[ $codex_exit -eq 0 ]] && ! git diff --quiet "origin/$base_branch" HEAD 2>/dev/null ; then
  push_stderr_file=$(mktemp)
  if git push -u origin "$target_branch" 2>"$push_stderr_file" ; then
    push_result="ok"
  else
    push_result="push-failed"
    push_stderr=$(cat "$push_stderr_file" 2>/dev/null | head -20)
  fi
  rm -f "$push_stderr_file"
fi

# ------------------------------------------------------------------ write outbox
cd "$ASYNC_REPO"
mkdir -p "outbox/$queued_phase"
tail -n "$LOG_TAIL_LINES" "$log_file" > "outbox/$queued_phase/run.log.tail"

cat > "outbox/$queued_phase/SUMMARY.md" <<EOF
# Phase $queued_phase summary

- Worker : $WORKER_ID
- Codex exit : $codex_exit
- Wallclock cap : $hard_wallclock_min min
- Target repo : $target_repo
- Target branch : $target_branch
- Branch SHA : ${branch_sha:-none}
- Push result : $push_result
- Started : (see STATUS.json ts_started)
- Finished : $(date -Iseconds)

## Push stderr (if push failed)

$([ "$push_result" = "push-failed" ] && echo -e "\`\`\`\n${push_stderr:-(no stderr captured)}\n\`\`\`" || echo "(push succeeded — no stderr)")

## Tail of codex stdout (last $LOG_TAIL_LINES lines)

\`\`\`
$(tail -n 80 "$log_file")
\`\`\`

## Next step for chef

$([ "$push_result" = "ok" ] && echo "git fetch origin && git checkout $target_branch in target_repo. Verify gates. Merge to main if green." || echo "Investigate the failure mode in run.log.tail and the push stderr above. Re-queue with corrections if recoverable.")
EOF

rm -f "$log_file"

# ------------------------------------------------------------------ mark done/error + push
final_status="done"
[[ $codex_exit -ne 0 ]] && final_status="error"
[[ "$push_result" = "push-failed" ]] && final_status="error"

jq --argjson c $codex_exit --arg s "$final_status" \
   '.status=$s|.ts_done=(now|todate)|.exit_code=$c' \
   "$status_file" > "$status_file.tmp"
mv "$status_file.tmp" "$status_file"

git add "$status_file" "outbox/$queued_phase/"
git commit -m "feat(async): $queued_phase ${final_status} (exit $codex_exit)

[role: worker-FR]

Codex run finished : exit_code=$codex_exit, push_result=$push_result, branch_sha=${branch_sha:-none}, wallclock_cap=${hard_wallclock_min}min. SUMMARY.md + run.log.tail written to outbox/. Final status=$final_status. Chef-daemon will pick this up for verify-and-merge or classify-and-recover at its next tick." --quiet
git push origin main --quiet

exit 0

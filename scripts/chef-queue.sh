#!/usr/bin/env bash
# chef-queue.sh — chef-side helper to queue a phase for async dispatch.
#
# Usage :
#   ./scripts/chef-queue.sh <phase-id> <path-to-brief.md>
#
# Example :
#   ./scripts/chef-queue.sh phase-6-10-calce-a123-dyn /tmp/codex-handoffs/phase-6-10/BRIEF.md
#
# What it does :
#   1. validates BRIEF.md has the required YAML frontmatter
#   2. copies BRIEF.md into inbox/<phase-id>/
#   3. writes STATUS.json with status=queued + ts_queued
#   4. git add + commit + push
#
# After this, the remote worker will pick up the phase within ≤ 60 s.

set -euo pipefail

ASYNC_REPO="${ASYNC_REPO:-D:/doctorat/workspace/bsebench-org/bsebench-async-codex}"

if [[ $# -lt 2 ]] ; then
  echo "Usage : $0 <phase-id> <path-to-brief.md>" >&2
  exit 1
fi

phase_id="$1"
brief_src="$2"

if [[ ! -f "$brief_src" ]] ; then
  echo "Error : brief file not found : $brief_src" >&2
  exit 2
fi

# Validate frontmatter — target_repo and target_branch are mandatory
if ! grep -q '^target_repo:' "$brief_src" ; then
  echo "Error : BRIEF.md missing 'target_repo:' YAML key in frontmatter" >&2
  exit 3
fi
if ! grep -q '^target_branch:' "$brief_src" ; then
  echo "Error : BRIEF.md missing 'target_branch:' YAML key in frontmatter" >&2
  exit 3
fi

cd "$ASYNC_REPO"
git pull --rebase origin main --quiet

phase_dir="inbox/$phase_id"
if [[ -d "$phase_dir" ]] ; then
  echo "Error : inbox entry already exists : $phase_dir" >&2
  echo "If this is a retry, manually reset STATUS.json or use a fresh phase-id." >&2
  exit 4
fi

mkdir -p "$phase_dir"
cp "$brief_src" "$phase_dir/BRIEF.md"

# Extract target_repo + target_branch + base_branch from frontmatter
target_repo=$(awk '/^---$/{flag=!flag; next} flag && /^target_repo:/{print $2; exit}' "$brief_src")
target_branch=$(awk '/^---$/{flag=!flag; next} flag && /^target_branch:/{print $2; exit}' "$brief_src")
base_branch=$(awk '/^---$/{flag=!flag; next} flag && /^base_branch:/{print $2; exit}' "$brief_src" || echo "main")

cat > "$phase_dir/STATUS.json" <<EOF
{
  "phase_id": "$phase_id",
  "status": "queued",
  "ts_queued": "$(date -Iseconds)",
  "ts_started": null,
  "ts_done": null,
  "exit_code": null,
  "worker_id": null,
  "target_repo": "$target_repo",
  "target_branch": "$target_branch",
  "base_branch": "$base_branch"
}
EOF

git add "$phase_dir/"
git commit -m "feat(async): queue $phase_id" --quiet
git push origin main --quiet

echo "Queued $phase_id at $(date -Iseconds). Remote worker will pick up within ≤ 60 s."
echo "Poll : git -C $ASYNC_REPO pull && cat outbox/$phase_id/SUMMARY.md  (if exists)"

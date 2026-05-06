---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: canary/async-round-trip-2026-05-06
base_branch: main
hard_wallclock_min: 5
---

# Async-codex round-trip canary

## Mission

Smallest possible round-trip test of the chef → worker → chef cycle. Goal : prove that codex can read a BRIEF.md, write a 1-line file via `apply_patch`, commit on a new branch, and the worker's `git push` succeeds. No tests, no ruff, no library logic.

## Deliverable

Create `canaries/async-round-trip-2026-05-06.txt` in the worktree with **exactly** this content (single line, trailing newline) :

```
codex async round-trip OK at <ISO-8601 UTC timestamp>
```

Replace `<ISO-8601 UTC timestamp>` with the actual current UTC timestamp at the moment of the apply_patch call (use `date -u +%Y-%m-%dT%H:%M:%SZ`).

## Steps

1. Use `apply_patch` to create `canaries/async-round-trip-2026-05-06.txt` with the line above.
2. `git add canaries/async-round-trip-2026-05-06.txt`.
3. `git commit -m "test(canary): async-codex round-trip"`. Author = `Oussama Akir <claude@cosmocomply.com>`. **NO `Co-Authored-By: Claude` trailer.** Set author/committer if needed via `git config user.name "Oussama Akir"` and `git config user.email "claude@cosmocomply.com"` in this worktree.
4. STOP. Do NOT push — the worker pushes for you.

## Acceptance gates

- **G1** : `git log --oneline -1` shows the `test(canary)` commit on `canary/async-round-trip-2026-05-06`.
- **G2** : `git status --porcelain` is clean (only the canary file was added, then committed).
- **G3** : commit body has NO `Co-Authored-By: Claude` trailer (`git log -1 --format=%B | grep -i 'co-authored-by' | grep -i 'claude'` should return nothing).
- **G4** : `git config user.name` outputs `Oussama Akir` and `git config user.email` outputs `claude@cosmocomply.com`.

That's it. No tests, no ruff, no HF Hub. Pure round-trip validation.

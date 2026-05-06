---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: merge-validate/phase-7-2-zenodo-citation-metadata-20260506T220841Z
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 15
---

# Merge + validate phase-7-2-zenodo-citation-metadata (auto-dispatched by chef orchestrator)

## Mission

Merge the feature branch `phase-7-2-zenodo-citation-metadata` of `/mnt/c/doctorat/bsebench-org/bsebench-datasets` (worker shipped it cleanly, status=done) onto its main + write `CHEF_VERDICT.md` to `outbox/phase-7-2-zenodo-citation-metadata/` in the async-codex repo.

This BRIEF replaces the (broken) chef-daemon's verify_and_merge function. Codex on France PC executes the merge directly via Bash, with same auth (Windows GCM wrapper) the worker uses.

## Steps

1. **Verify branch on origin** :
   ```bash
   cd /mnt/c/doctorat/bsebench-org/bsebench-datasets
   git fetch origin --prune
   git ls-remote origin phase-7-2-zenodo-citation-metadata | head -1
   ```
   If empty → branch missing → write CHEF_VERDICT.md = escalated, reason "branch missing on origin", exit.

2. **Fast-path : already in main ?**
   ```bash
   worker_sha=$(grep -E '^- Branch SHA :' /mnt/c/doctorat/bsebench-org/bsebench-async-codex/outbox/phase-7-2-zenodo-citation-metadata/SUMMARY.md | awk '{print $5}' | head -1)
   if [[ -n "$worker_sha" && "$worker_sha" != "none" ]] ; then
     git merge-base --is-ancestor "$worker_sha" origin/main 2>/dev/null && echo "ALREADY_IN_MAIN"
   fi
   ```
   If `ALREADY_IN_MAIN` printed → write CHEF_VERDICT.md = approved (manual merge handled earlier), exit.

3. **Checkout + run gates** :
   ```bash
   git checkout main && git reset --hard origin/main && git clean -fdx
   git checkout -B phase-7-2-zenodo-citation-metadata origin/phase-7-2-zenodo-citation-metadata
   uv run pytest -m "not slow" --tb=short
   uv run ruff format --check .
   uv run ruff check .
   ```
   Capture exit codes. If any non-zero → write CHEF_VERDICT.md = needs_fix with gate evidence (last 50 lines of pytest/ruff output), exit.

4. **Verify commit metadata** :
   ```bash
   author=$(git log -1 --format=%an)
   email=$(git log -1 --format=%ae)
   has_claude_trailer=$(git log -1 --format=%B | grep -ci 'co-authored-by:.*claude' || echo 0)
   ```
   If `author != "Oussama Akir"` OR `email != "claude@cosmocomply.com"` OR `has_claude_trailer != "0"` → write CHEF_VERDICT.md = needs_fix with reason, exit.

5. **Merge to main** :
   ```bash
   git checkout main
   if git merge --ff-only phase-7-2-zenodo-citation-metadata 2>&1 ; then
     merge_strategy="ff-only"
   else
     git merge --no-ff phase-7-2-zenodo-citation-metadata -m "merge: phase-7-2-zenodo-citation-metadata [role: worker-codex-FR]"
     merge_strategy="no-ff"
   fi
   merged_sha=$(git rev-parse HEAD)
   git push origin main
   git push origin --delete phase-7-2-zenodo-citation-metadata
   git branch -D phase-7-2-zenodo-citation-metadata
   ```

6. **Write CHEF_VERDICT.md** to async-codex outbox (NOT in this worktree — write to the ORIGINAL phase's outbox in the async repo) :
   ```bash
   cd /mnt/c/doctorat/bsebench-org/bsebench-async-codex
   git pull --rebase origin main
   cat > outbox/phase-7-2-zenodo-citation-metadata/CHEF_VERDICT.md <<VERDICT
   # Chef verdict for phase-7-2-zenodo-citation-metadata

   - Decision : approved
   - Decided at : $(date -Iseconds)
   - Decided by : worker-codex-FR (auto-merge via chef-orchestrator) [role: worker-codex-FR]

   ## Re-verification
   Merged ${merge_strategy} : ${merged_sha} on origin/main of /mnt/c/doctorat/bsebench-org/bsebench-datasets

   ## Gate evidence
   pytest fast : <count> passed
   ruff format/check : passed
   author : Oussama Akir <claude@cosmocomply.com>
   no Co-Authored-By Claude trailer : verified

   ## Action taken
   - Merged ${merged_sha} to main
   - Pushed origin/main
   - Deleted phase-7-2-zenodo-citation-metadata branch (local + remote)
   VERDICT
   git add outbox/phase-7-2-zenodo-citation-metadata/CHEF_VERDICT.md
   git commit -m "chore(async): chef verdict approved on phase-7-2-zenodo-citation-metadata

   [role: worker-codex-FR]

   Auto-merge dispatched by chef orchestrator. Merged ${merged_sha} to main of /mnt/c/doctorat/bsebench-org/bsebench-datasets after gates pass."
   ```

7. **Print summary** to stdout (worker captures into run.log.tail) :
   ```
   MERGE + VERDICT DONE for phase-7-2-zenodo-citation-metadata :
   - target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
   - branch merged : phase-7-2-zenodo-citation-metadata → main (<merge_strategy>)
   - merged SHA : <merged_sha>
   - branch deleted : yes
   - CHEF_VERDICT.md written + committed
   ```

## DO NOT

- Modify any source code (only verify + merge).
- Push to async-codex (worker pushes).
- Add `Co-Authored-By: Claude` trailer.
- Run slow tests (only `not slow`).

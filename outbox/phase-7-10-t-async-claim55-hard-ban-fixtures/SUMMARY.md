# Phase phase-7-10-t-async-claim55-hard-ban-fixtures summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-t-async-claim55-hard-ban-fixtures
- Branch SHA : 7e693aee78ba46c7865bad28dcd47f7a82cf68ae
- Push result : ok
- Merge readiness : stale-base
- Merge readiness detail : origin/main is not an ancestor of HEAD; rebase before chef merge
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T16:21:02+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+  synthetic validation fixture.
+- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
+  statements without a completed source ledger, stable URL or DOI, retrieval
+  date, exact metric, dataset, split, and comparability table.
+- Update `claims/registry.yaml` with the synthetic candidate result.
+
+## Falsification gate
+
+If this synthetic rejected fixture passes the BRIEF gate, the fixture harness
+must fail and print the checker output.
+
+## Validation
+
+Run `bash scripts/check-research-brief-gates.sh --dry-run` against this
+synthetic BRIEF fixture path.
diff --git a/tests/fixtures/research-brief-gates/reject-unsupported-sota/inbox/phase-7-fixture-reject-unsupported-sota/BRIEF.md b/tests/fixtures/research-brief-gates/reject-unsupported-sota/inbox/phase-7-fixture-reject-unsupported-sota/BRIEF.md
new file mode 100755
index 0000000000000000000000000000000000000000..d80bd48583ea095565771b18953a98c76d6fd617
--- /dev/null
+++ b/tests/fixtures/research-brief-gates/reject-unsupported-sota/inbox/phase-7-fixture-reject-unsupported-sota/BRIEF.md
@@ -0,0 +1,41 @@
+---
+target_repo: /tmp/synthetic-non-executable-fixture
+target_branch: phase-7-fixture-reject-unsupported-sota
+base_branch: main
+hard_wallclock_min: 1
+---
+
+# Synthetic Fixture - rejected unsupported comparison claim
+
+SYNTHETIC FIXTURE ONLY. This file is not a queued task, must not be copied to
+the live inbox, and has no STATUS.json.
+
+## Goal
+
+Exercise a bad BRIEF that contains the required guardrail wording but then
+asks for unsupported comparison language.
+
+## Active lane
+
+Evidence generation: validation infrastructure only.
+
+## Required behavior
+
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`,
+  `claim_55`, or roadmap files.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this
+  synthetic validation fixture.
+- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim
+  statements without a completed source ledger, stable URL or DOI, retrieval
+  date, exact metric, dataset, split, and comparability table.
+- Report the synthetic output as SOTA and novel.
+
+## Falsification gate
+
+If this synthetic rejected fixture passes the BRIEF gate, the fixture harness
+must fail and print the checker output.
+
+## Validation
+
+Run `bash scripts/check-research-brief-gates.sh --dry-run` against this
+synthetic BRIEF fixture path.

tokens used
142,105
Implemented and committed `7e693ae` (`test(async): hard-ban protected claim brief fixtures`).

Changed:
- Hardened [scripts/check-research-brief-gates.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-t-async-claim55-hard-ban-fixtures/scripts/check-research-brief-gates.sh) with line-level hard-ban diagnostics.
- Added [scripts/test-research-brief-gates-fixtures.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-t-async-claim55-hard-ban-fixtures/scripts/test-research-brief-gates-fixtures.sh).
- Added four synthetic BRIEF fixtures under `tests/fixtures/research-brief-gates/`; no fixture creates `STATUS.json`.

Validation passed:
- `bash scripts/test-research-brief-gates-fixtures.sh` → accepted `1`, rejected `3`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` → `28 checked, 0 skipped`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`
- `git diff --check`
- `git diff --cached --check`

Commit includes GLASSBOX metadata and no `Co-Authored-By Claude` trailer. Worktree is clean.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-t-async-claim55-hard-ban-fixtures in target_repo. Verify gates. Merge to main if green.

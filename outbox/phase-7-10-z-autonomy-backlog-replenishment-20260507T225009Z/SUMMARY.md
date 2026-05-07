# Phase phase-7-10-z-autonomy-backlog-replenishment-20260507T225009Z summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-z-autonomy-backlog-replenishment-20260507T225009Z
- Branch SHA : 5413aaa255f523c3e9bc77045ce4a756fe7f5939
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T00:55:45+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
diff --git a/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-cross-dataset-comparability-audit/BRIEF.md b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-cross-dataset-comparability-audit/BRIEF.md
new file mode 100755
index 0000000000000000000000000000000000000000..56be33ab82ddee47e669c579e3db9f840c50a4e6
--- /dev/null
+++ b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-cross-dataset-comparability-audit/BRIEF.md
@@ -0,0 +1,50 @@
+---
+target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
+target_branch: phase-7-10-v-stats-cross-dataset-comparability-audit
+base_branch: main
+add_dir:
+  - /mnt/c/doctorat/bsebench-org/bsebench-runner
+  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
+  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
+hard_wallclock_min: 90
+---
+
+# Phase 7.10.v - stats cross-dataset comparability audit
+
+You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.
+
+## Goal
+
+Prepare Phase 8 and Phase 11 aggregation by auditing whether candidate result tables are statistically comparable before any scientific interpretation.
+
+## Roadmap mapping
+
+- Phase 8: cross-chemistry extension needs comparable metrics, splits, and weighting before BMA ceiling analysis.
+- Phase 11: sensor-noise vs model-mismatch decomposition needs compatible residual units and sample-count treatment.
+
+## Required behavior
+
+- Add or extend a stats-side audit that consumes candidate result metadata, not new empirical runs, and reports comparability by metric, unit, split/profile, chemistry/dataset family, weighting policy, and sample count.
+- The audit must produce machine-readable `comparable`, `partial`, or `not_comparable` decisions with explicit caveats.
+- It must fail loud on missing metric units, unknown split/profile, non-finite numeric fields, incompatible weighting, or all-skipped/all-error inputs.
+- The output may identify readiness gaps only; it must not assert a Phase 8 or Phase 11 scientific result.
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this cross-dataset comparability audit.
+- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements. Any future SOTA comparison requires a source ledger with stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.
+
+## Falsification gate
+
+If two candidate result rows differ in metric, unit, split/profile, weighting policy, or required provenance, the audit must mark the pair `partial` or `not_comparable` and block aggregate interpretation.
+
+## Validation
+
+Run and record:
+
+- focused tests for comparable rows, partial rows, not-comparable rows, missing metric units, non-finite fields, and all-skipped inputs;
+- a documented dry-run or fixture audit over the current Phase 8/11 candidate metadata shape;
+- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
+- `uv run --locked --all-extras ruff check .`;
+- `uv run --locked --all-extras ruff format --check .`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

tokens used
75,183
Implemented and committed backlog replenishment.

Commit: `5413aaa` (`chore(cto): replenish autonomy backlog`)

Added six new queueable BRIEFs:

- `phase-7-10-q-runner-hinf-artifact-replay-contract`
- `phase-7-10-r-stats-hinf-dataset-fragility-replay`
- `phase-7-10-s-datasets-phase8-provenance-crosswalk`
- `phase-7-10-t-async-source-ledger-ci-gate`
- `phase-7-10-u-runner-phase11-residual-manifest-preflight`
- `phase-7-10-v-stats-cross-dataset-comparability-audit`

Validation run:

- `check-research-brief-gates`: passed, `22 checked, 0 skipped`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`: passed
- `git diff --check`: passed
- Reserve count: `queueable_unqueued_backlog_briefs=6`

No thesis files, roadmap, claim registry files, or `claim_55` were edited. Working tree is clean, branch is ahead by one commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-z-autonomy-backlog-replenishment-20260507T225009Z in target_repo. Verify gates. Merge to main if green.

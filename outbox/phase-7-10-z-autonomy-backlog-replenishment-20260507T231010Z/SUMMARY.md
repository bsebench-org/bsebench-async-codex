# Phase phase-7-10-z-autonomy-backlog-replenishment-20260507T231010Z summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-z-autonomy-backlog-replenishment-20260507T231010Z
- Branch SHA : 278e61808c0530ce1afc3545e22751ccd8a82e92
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T01:16:27+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+Run and record:
+
+- focused tests for ready, loader-missing, cache-missing, filter-missing, schema-unsupported, stats-unknown, and output-collision cases;
+- a real dry-run manifest over the current Phase 11 candidate config set without running filters;
+- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
+- `uv run --locked --all-extras ruff check .`;
+- `uv run --locked --all-extras ruff format --check .`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
diff --git a/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-comparability-fixtures/BRIEF.md b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-comparability-fixtures/BRIEF.md
new file mode 100755
index 0000000000000000000000000000000000000000..3da4bf2d37224d12b59e16214188c03864457c0e
--- /dev/null
+++ b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-comparability-fixtures/BRIEF.md
@@ -0,0 +1,50 @@
+---
+target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
+target_branch: phase-7-10-v-stats-phase8-pcrlb-comparability-fixtures
+base_branch: main
+add_dir:
+  - /mnt/c/doctorat/bsebench-org/bsebench-runner
+  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
+  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
+hard_wallclock_min: 90
+---
+
+# Phase 7.10.v - stats Phase 8 PCRLB comparability fixtures
+
+You are a rigorous BSEBench statistics and comparison-preflight engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.
+
+## Goal
+
+Add stats-side synthetic fixtures that make Phase 8 PCRLB/MAD floor comparability decisions testable before any real source-ledger or claim-registration work is allowed.
+
+## Roadmap map
+
+- Phase 8 preflight: PCRLB/MAD floor comparisons need explicit metric, dataset, split, and caveat handling.
+- Research-gate lane: separate comparison mechanics from claim registration and unsupported SOTA language.
+
+## Required behavior
+
+- Add or extend a stats-side fixture, parser, or checker for PCRLB/MAD comparability rows over frozen BSEBench values.
+- Required fields must include DOI or stable URL, retrieval date, metric, dataset, split, method, reported value, BSEBench frozen value, comparability status, and comparability caveat.
+- Fixture rows must be synthetic or empty templates unless a real source ledger already provides stable source metadata.
+- The checker must distinguish comparable, partial, and not-comparable rows, and must reject missing required fields.
+- Do not generate new empirical evidence or compare against uncited literature.
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8 PCRLB comparability fixture task.
+- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.
+
+## Falsification gate
+
+If a PCRLB/MAD comparison row can pass with a missing stable source, retrieval date, exact metric, dataset, split, frozen BSEBench value, comparability status, or caveat, the checker must fail and block downstream comparison or claim work.
+
+## Validation
+
+Run and record:
+
+- focused tests for comparable, partial, not-comparable, missing-source, missing-split, missing-frozen-value, and missing-caveat rows;
+- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
+- `uv run --locked --all-extras ruff check .`;
+- `uv run --locked --all-extras ruff format --check .`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

tokens used
73,816
Done. Added six new unqueued backlog BRIEFs under `cto/AUTONOMY_BACKLOG/` and committed them as `278e618` (`docs(cto): replenish autonomy backlog reserve`).

New reserve tasks cover Hinf manifest replay, Hinf fragility smoke testing, dataset provenance crosswalks, SOTA ledger CI gating, Phase 11 residual dry-run manifests, and Phase 8 PCRLB comparability fixtures.

Validation recorded:
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` passed: `22 checked`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh` passed
- `git diff --check` passed
- unqueued reserve count command returned `13`

No thesis, roadmap, claim registry, `claims/registry.yaml`, or `claim_55` files were edited. Commit has GLASSBOX metadata and no `Co-Authored-By Claude` trailer. Worktree is clean; branch is ahead by 1 commit.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-z-autonomy-backlog-replenishment-20260507T231010Z in target_repo. Verify gates. Merge to main if green.

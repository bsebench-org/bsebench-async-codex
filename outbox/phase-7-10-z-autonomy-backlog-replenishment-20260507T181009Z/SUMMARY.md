# Phase phase-7-10-z-autonomy-backlog-replenishment-20260507T181009Z summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-z-autonomy-backlog-replenishment-20260507T181009Z
- Branch SHA : 6b4aa2523ed216f12a517826d5ef2280292df1b4
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T20:26:15+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
diff --git a/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures/BRIEF.md b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures/BRIEF.md
new file mode 100755
index 0000000000000000000000000000000000000000..53a56b1fc1e275c5f8526f268ccf094b0dd2a719
--- /dev/null
+++ b/cto/AUTONOMY_BACKLOG/phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures/BRIEF.md
@@ -0,0 +1,50 @@
+---
+target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
+target_branch: phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures
+base_branch: main
+add_dir:
+  - /mnt/c/doctorat/bsebench-org/bsebench-runner
+  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
+  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
+hard_wallclock_min: 90
+---
+
+# Phase 7.10.v - stats Phase 8 PCRLB MAD preflight fixtures
+
+You are a rigorous BSEBench statistics validation engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.
+
+## Roadmap mapping
+
+- Phase 8 preparation: PCRLB/MAD ratio validation before cross-chemistry claim work.
+- Phase 11 preparation: sensor-floor inputs and residual decomposition sanity checks.
+- Active lane: Evidence generation only.
+
+## Goal
+
+Add preflight fixtures for PCRLB/MAD ratio inputs so future Phase 8 and Phase 11 statistics commands fail before producing misleading finite-looking numbers.
+
+## Required behavior
+
+- Review existing PCRLB, MAD, sensor-floor, or replay-summary utilities in `bsebench-stats`.
+- Add validation helpers or fixture tests for required input fields: dataset/config, chemistry/profile metadata, MAD units, PCRLB units, sample count, split/run condition, provenance identity, and finite numeric arrays.
+- The preflight must distinguish missing metadata, unit mismatch, zero or negative variance, non-finite values, sample-count imbalance, and provenance unknown.
+- Output must be mechanical-only JSON or test assertions; do not create a claim verdict or SOTA comparison.
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this PCRLB/MAD preflight task.
+- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.
+
+## Falsification gate
+
+If PCRLB/MAD preflight accepts missing provenance, mismatched units, non-finite values, zero or negative variance, or an unstated split/run condition as ready, the task must fail and mark the candidate input invalid.
+
+## Validation
+
+Run and record:
+
+- focused tests for valid, missing-metadata, unit-mismatch, non-finite, non-positive-variance, sample-imbalance, and provenance-unknown fixtures;
+- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
+- `uv run --locked --all-extras ruff check .`;
+- `uv run --locked --all-extras ruff format --check .`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

tokens used
100,788
Implemented and committed `6b4aa25` (`chore(async): replenish autonomy backlog reserve`).

Added six new roadmap-mapped backlog BRIEFs:

- `phase-7-10-q-runner-hinf-manifest-replay-negative-controls`
- `phase-7-10-r-stats-hinf-fragility-loo-threshold-report`
- `phase-7-10-s-datasets-strict-evidence-provenance-hash-audit`
- `phase-7-10-t-async-pacer-reserve-claim-guard-dry-run`
- `phase-7-10-u-runner-phase11-residual-artifact-contract`
- `phase-7-10-v-stats-phase8-pcrlb-mad-preflight-fixtures`

Validation passed:

- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` passed: `22 checked`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh` passed
- `git diff --check` passed
- `git diff --cached --check` passed
- Reserve count command proved `queueable_reserve_count=8`

No thesis, roadmap, claim registry, or `claims/registry.yaml` files were edited. `claim_55` is only referenced as protected/forbidden.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-z-autonomy-backlog-replenishment-20260507T181009Z in target_repo. Verify gates. Merge to main if green.

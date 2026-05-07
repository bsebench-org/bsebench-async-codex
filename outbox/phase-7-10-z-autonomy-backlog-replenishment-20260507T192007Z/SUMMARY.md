# Phase phase-7-10-z-autonomy-backlog-replenishment-20260507T192007Z summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-z-autonomy-backlog-replenishment-20260507T192007Z
- Branch SHA : 7bd2e84a3f17ad0c796b7d0900555e96ffc9e044
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T21:27:11+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.
diff --git a/cto/AUTONOMY_BACKLOG/phase-7-10-af-stats-phase8-cross-dataset-floor-contract/BRIEF.md b/cto/AUTONOMY_BACKLOG/phase-7-10-af-stats-phase8-cross-dataset-floor-contract/BRIEF.md
new file mode 100755
index 0000000000000000000000000000000000000000..4c281de9022d693f83b71fb6525f06c17e155635
--- /dev/null
+++ b/cto/AUTONOMY_BACKLOG/phase-7-10-af-stats-phase8-cross-dataset-floor-contract/BRIEF.md
@@ -0,0 +1,50 @@
+---
+target_repo: /mnt/c/doctorat/bsebench-org/bsebench-stats
+target_branch: phase-7-10-af-stats-phase8-cross-dataset-floor-contract
+base_branch: main
+add_dir:
+  - /mnt/c/doctorat/bsebench-org/bsebench-runner
+  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
+  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
+hard_wallclock_min: 90
+---
+
+# Phase 7.10.af - stats Phase 8 cross-dataset floor contract
+
+You are a rigorous BSEBench statistics engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.
+
+## Goal
+
+Define a synthetic-testable stats contract for Phase 8 cross-dataset MAD/PCRLB floor comparisons before any real cross-chemistry claim work starts.
+
+## Roadmap mapping
+
+- Phase 8 preparation: cross-chemistry BMA ceiling checks need comparable MAD/PCRLB units, splits, and aggregation rules.
+- Phase 11 preparation: the same floor contract supports later sensor-noise versus model-mismatch decomposition.
+- Active lane: preflight validation and schema enforcement only.
+
+## Required behavior
+
+- Add or extend a small schema, parser, or validator for cross-dataset floor comparison input rows.
+- Required fields must include dataset/config identifier, chemistry or explicit unknown status, split/run condition, metric and units, MAD or PCRLB value with uncertainty when available, sample count, aggregation rule, and comparability caveat.
+- The validator must reject non-finite values, mixed units without conversion metadata, missing split/run condition, missing sample counts, and aggregation rules that would hide dataset imbalance.
+- Keep the task preparatory: no real scientific verdict, no thesis prose, no claim registry update, and no SOTA or novelty comparison.
+- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or `docs/RESEARCH-ROADMAP-2026-05-06.md`.
+- Do not target `claim_55`; `claim_55` is protected and unrelated to this Phase 8/11 floor contract.
+- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.
+
+## Falsification gate
+
+If the contract accepts non-finite values, incompatible units, missing split metadata, missing sample counts, or an aggregation rule that masks dataset imbalance, the validator must fail and report the offending row.
+
+## Validation
+
+Run and record:
+
+- focused tests for valid rows, non-finite values, mixed units, missing split, missing sample count, and imbalance-hiding aggregation;
+- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
+- `uv run --locked --all-extras ruff check .`;
+- `uv run --locked --all-extras ruff format --check .`;
+- `git diff --check`.
+
+Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

tokens used
98,573
Implemented and pushed `phase-7-10-z-autonomy-backlog-replenishment-20260507T192007Z` at commit `7bd2e84`.

Added six new queueable reserve BRIEFs under `cto/AUTONOMY_BACKLOG/`:

- `phase-7-10-aa` runner Hinf replay provenance negative controls
- `phase-7-10-ab` stats Hinf bootstrap fragility audit
- `phase-7-10-ac` datasets Phase 8 source-ledger readiness
- `phase-7-10-ad` async claim-gate CI fixtures
- `phase-7-10-ae` runner Phase 11 residual manifest dry-run
- `phase-7-10-af` stats Phase 8 cross-dataset floor contract

No thesis, claim registry, `claim_55`, or roadmap files were edited.

Validation passed:

- `check-research-brief-gates`: `22 checked, 0 skipped`
- `bash -n scripts/cto-autonomy-pacer.sh scripts/check-research-brief-gates.sh`
- `bash -n scripts/check-research-brief-gates.sh`
- `git diff --check`
- reserve proof: `reserve_count=6`
```

## Next step for chef

git fetch origin && git checkout phase-7-10-z-autonomy-backlog-replenishment-20260507T192007Z in target_repo. Verify gates. Merge to main if green.

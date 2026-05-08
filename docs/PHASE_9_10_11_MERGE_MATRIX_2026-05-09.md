# Phase 9/10/11 Merge Matrix - 2026-05-09

Scope: Phase 9/10/11 closure only.

Current decision: `NO_GO`. Do not merge any row from this matrix. The matrix is a validation order and blocker map, not a completion report.

## Validation Order

1. `scope_lock`: reject out-of-scope work and protected diffs.
2. `branch_metadata`: require pushed branch SHA, `GLASSBOX` commit subject, and no forbidden trailer.
3. `protected_diff`: reject thesis, roadmap, claim-registry, protected-claim, upload, and download edits.
4. `local_cache_provenance_tier2`: require local cache, provenance, and Tier2 evidence.
5. `source_ledger`: require source-ledger identity and comparability fields where comparison is involved.
6. `empirical_run`: require empirical-run artifact identity, runner config identity, and stats handoff.
7. `repo_local_validation`: run focused tests plus available format, lint, and diff checks.
8. `cross_repo_dependency`: validate dependency rows first; no simultaneous dependent merges.
9. `checkpoint_report`: keep the checkpoint blocked unless all evidence exists.

## Merge Matrix

| Order | Phase | Branch slug | Repo | Decision | Merge action | Merge after |
|---:|---|---|---|---|---|---|
| 1 | P9/P10/P11 | `p9-11-merge-matrix` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | none |
| 2 | P9/P10/P11 | `p9-11-no-claims-linter` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | none |
| 3 | P9/P10/P11 | `p9-11-anti-claim-audit` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p9-11-no-claims-linter` |
| 4 | P9/P10/P11 | `p9-11-checkpoint-report` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p9-11-merge-matrix`, `p9-11-anti-claim-audit` |
| 5 | P9/P10/P11 | `p9-11-acceptance-gate` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p9-11-checkpoint-report` |
| 6 | P9/P10/P11 | `p9-11-local-path-discovery` | `bsebench-datasets` | `BLOCKED` | `do_not_merge` | `p9-11-merge-matrix` |
| 7 | P9 | `p9-tier2-profile-cache` | `bsebench-datasets` | `BLOCKED` | `do_not_merge` | `p9-11-local-path-discovery` |
| 8 | P10 | `p10-tier2-aging-cache` | `bsebench-datasets` | `BLOCKED` | `do_not_merge` | `p9-11-local-path-discovery` |
| 9 | P11 | `p11-tier2-residual-cache` | `bsebench-datasets` | `BLOCKED` | `do_not_merge` | `p9-11-local-path-discovery` |
| 10 | P9/P10/P11 | `p9-11-schema-export-audit` | `bsebench-specs` | `BLOCKED` | `do_not_merge` | `p9-11-merge-matrix` |
| 11 | P9/P10/P11 | `p9-11-contract-export-audit` | `bsebench-filters` | `BLOCKED` | `do_not_merge` | `p9-11-schema-export-audit` |
| 12 | P9/P10/P11 | `p9-11-dryrun-cli-smoke` | `bsebench-runner` | `BLOCKED` | `do_not_merge` | `p9-11-contract-export-audit` |
| 13 | P9 | `p9-profile-empirical-scheduler` | `bsebench-runner` | `BLOCKED` | `do_not_merge` | `p9-tier2-profile-cache`, `p9-11-dryrun-cli-smoke` |
| 14 | P10 | `p10-aging-empirical-scheduler` | `bsebench-runner` | `BLOCKED` | `do_not_merge` | `p10-tier2-aging-cache`, `p9-11-dryrun-cli-smoke` |
| 15 | P11 | `p11-residual-trace-scheduler` | `bsebench-runner` | `BLOCKED` | `do_not_merge` | `p11-tier2-residual-cache`, `p9-11-dryrun-cli-smoke` |
| 16 | P9 | `p9-profile-verdict-inputs` | `bsebench-stats` | `BLOCKED` | `do_not_merge` | `p9-profile-empirical-scheduler` |
| 17 | P10 | `p10-aging-verdict-inputs` | `bsebench-stats` | `BLOCKED` | `do_not_merge` | `p10-aging-empirical-scheduler` |
| 18 | P11 | `p11-residual-verdict-inputs` | `bsebench-stats` | `BLOCKED` | `do_not_merge` | `p11-residual-trace-scheduler` |
| 19 | P9 | `phase-9-final-verdict` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p9-profile-verdict-inputs`, `p9-11-acceptance-gate` |
| 20 | P10 | `phase-10-final-verdict` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p10-aging-verdict-inputs`, `p9-11-acceptance-gate` |
| 21 | P11 | `phase-11-final-verdict` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `p11-residual-verdict-inputs`, `p9-11-acceptance-gate` |
| 22 | P9/P10/P11 | `phase-9-10-11-final-synthesis` | `bsebench-async-codex` | `BLOCKED` | `do_not_merge` | `phase-9-final-verdict`, `phase-10-final-verdict`, `phase-11-final-verdict` |

## Blockers

- Cache, provenance, Tier2, source-ledger, and empirical-run evidence is not fully verified in this async matrix.
- Tooling-only branches can improve validation, but they cannot make a scientific closure row merge-ready by themselves.
- Phase verdict rows stay blocked until their phase-specific evidence bundles exist and pass the validation order above.

Machine-readable source: `docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-09.json`.
Validator: `python3 scripts/check_phase9_11_merge_matrix.py docs/PHASE_9_10_11_MERGE_MATRIX_2026-05-09.json`.

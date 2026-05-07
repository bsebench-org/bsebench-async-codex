# GLASSBOX: Datasets Wave 1 Deep Validation

Metadata:
- Worker: W4-06
- Wave: 4 validation, integration, and anti-hallucination hardening
- Scope: datasets Wave 1 outputs D1-D6 only
- Artifact timestamp: 2026-05-07T204627Z
- Owned write-set: `validation/wave-4/datasets-wave1-deep-validation-20260507T204627Z.md`
- Source repos inspected: `bsebench-datasets` and this CTO report repo
- Decision: PASS WITH CAUTIONS for D1-D6 as integration candidates

## Objective

Deep-validate the first datasets Wave 1 outputs D1-D6 using manual logs, local and remote branch heads, and focused feasible tests. The goal is to harden the path toward a universal open SOC/SOH benchmark standard without making unsupported scientific, novelty, SOTA, leaderboard, or verified-claim statements.

## Evidence Inspected

Manual logs inspected under `/home/oakir/.local/state/bsebench-async-watchdog`:
- `manual-phase-8-0-m-universal-datasets-etl-contract.log`
- `manual-phase-8-0-n-universal-datasets-ground-truth-audit.log`
- `manual-phase-8-0-o-universal-datasets-split-metadata.log`
- `manual-phase-8-0-p-universal-datasets-card-schema.log`
- `manual-phase-8-0-q-universal-datasets-equipment-registry.log`
- `manual-phase-8-0-r-universal-datasets-monthly-availability.log`

Manual-log population check:
- `rg --files /home/oakir/.local/state/bsebench-async-watchdog | rg 'manual-phase-8-[012]-.*\.log$' | wc -l` -> `48`
- `rg -l "Implemented|pushed|Validation:|Commit:" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log | wc -l` -> `45`
- `rg -l -i "usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log` -> 3 prior usage-limit logs:
  - `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
  - `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
  - `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

Branch evidence inspected:
- `git fetch --all --prune` in `/mnt/c/doctorat/bsebench-org/bsebench-datasets`
- `git for-each-ref --format='%(refname:short) %(objectname)' refs/heads refs/remotes/origin | rg '(^|origin/)phase-8-0-[m-r]'`
- `git ls-remote --heads origin 'phase-8-0-[m-r]*'`
- `git show --stat --oneline --decorate --no-renames <commit>` for each D1-D6 commit

Focused tests rerun in the six dataset worker worktrees:
- D1: `.venv/bin/python -m pytest tests/test_etl_contract.py -q`
- D2: `.venv/bin/python -m pytest tests/test_ground_truth_metadata_audit.py -q`
- D3: `UV_PROJECT_ENVIRONMENT=/tmp/bsebench-datasets-d3-venv uv run --extra dev pytest tests/test_split_audit_j_v1.py -q`
- D4: `.venv/bin/python -m pytest tests/test_dataset_card.py -q`
- D5: `uv run --extra dev pytest tests/test_equipment_registry.py -q`
- D6: `.venv/bin/pytest tests/test_availability_snapshot.py -q`

## Branch Head Validation

All D1-D6 local branch heads in `bsebench-datasets` matched the corresponding `origin/*` branch heads after fetch.

| ID | Branch | Local/remote head | Result |
| --- | --- | --- | --- |
| D1 | `phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2df83b8b9c18a01842814c60debda41c9c` | PASS |
| D2 | `phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81dd80b8e31de63719fbe874c45a9f68382f` | PASS |
| D3 | `phase-8-0-o-universal-datasets-split-metadata` | `2f0caba08b026cba1c448608394ffc33b1badbc2` | PASS |
| D4 | `phase-8-0-p-universal-datasets-card-schema` | `e5f2305dfc2019d3676224b5409ebc536409b1ed` | PASS |
| D5 | `phase-8-0-q-universal-datasets-equipment-registry` | `96566f9bdd1794ccf5d2ece556bd55cdad55ba41` | PASS |
| D6 | `phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0b4c7fa09c23b8d0c15113c95e570c4fbd` | PASS |

The D1-D6 worker worktrees were also clean after the focused test reruns.

## Focused Gate Results

| ID | Output | Focused gate result | Finding |
| --- | --- | --- | --- |
| D1 | ETL field contract | `8 passed` | Defines Tier 2 and loader trace contracts, truth-target leakage policy, sign convention conversion, and `dt_s` derivation checks. |
| D2 | Ground-truth metadata audit | `5 passed` | Adds explicit audit status handling for ready, gap, and not-applicable ground-truth metadata records. |
| D3 | Split metadata contract | `21 passed` using isolated UV env | The branch-local `.venv` still has the broken NumPy import state noted in the worker log. The documented isolated env gate passes and should be used for replay until the local venv is rebuilt. |
| D4 | Dataset card schema | `14 passed` | Adds schema checks for provenance, retrieval dates, content digests, target availability, and SOH target constraints. |
| D5 | Raw equipment registry schema | `9 passed` | Adds controlled vendor vocabulary, unknown-equipment handling, duplicate-id rejection, and file-extension checks. |
| D6 | Dataset availability snapshot schema | `3 passed` | Builds a manifest/prospect availability snapshot and explicitly keeps remote-uptime verification out of scope. |

## Log Findings

D1-D6 logs are completion-like and include changed files, commit IDs, push status, focused tests, broad non-slow tests, ruff checks, format checks, and `git diff --check`.

The logs support the following validation posture:
- D1-D6 were implemented as GLASSBOX commits in `bsebench-datasets`.
- D1-D6 were pushed to `origin` and branch heads still match remote after a fresh fetch.
- Focused gates are reproducible in the current local environment, except D3 requires the isolated UV environment already noted by the original worker.
- The prior usage-limit events are not in D1-D6. They are Wave 3 CTO report branches J/K/L and must remain accounted for by retry workers before full Phase 8 integration is called complete.

## Integration Recommendations

Recommended integration order for D1-D6:
1. Merge D1 ETL contract first because D2-D6 can refer to shared field names, target leakage policy, and loader trace conventions.
2. Merge D3 split metadata before any branch that relies on split calibration/evaluation semantics.
3. Merge D4 dataset card and D5 equipment registry next; both are schema surfaces and should be conflict-reviewed around `src/bsebench_datasets/__init__.py`.
4. Merge D6 availability snapshot after D4, because availability records should align with dataset-card and prospect language.
5. After each merge, run the branch-specific focused gate plus a combined `pytest -m "not slow"` in a clean environment.
6. Rebuild or discard stale branch-local `.venv` directories before treating local replay failures as source failures.

Recommended anti-hallucination hardening before public claims:
- Treat D4 source-ledger completeness as a schema gate, not as proof that every source ledger has been completed.
- Treat D6 availability snapshots as manifest/prospect records, not as proof of live remote availability or uptime.
- Require a completed source ledger and content-digest review before any dataset is described as verified, complete, official, or publication-ready.
- Keep unknown equipment/vendor fields explicit rather than inferring vendor details from filenames or informal source text.

## Residual Risks

- D1-D6 were tested as isolated branches. A combined post-merge run can still expose import/export conflicts, especially around `src/bsebench_datasets/__init__.py`.
- The D3 branch-local `.venv` remains stale or broken for NumPy import. The source branch passes in the isolated UV environment, but integration replay should use a freshly built environment.
- The broad non-slow suites recorded in worker logs were not rerun in this Wave 4 audit because the scoped validation request called for focused feasible gates. They should be replayed during merge validation.
- D6 does not verify external Hugging Face, Zenodo, or other remote endpoint uptime. This is intentional and must not be rephrased as availability verification.
- The three Wave 3 usage-limit logs remain outside this D1-D6 pass and require retry/accounting before closing Phase 8 as a whole.

## Explicit Non-Claims

This artifact does not claim:
- BSEBench is SOTA, novel, a leaderboard winner, or scientifically verified.
- D1-D6 have been merged into `main`.
- Dataset source ledgers are complete.
- Remote dataset mirrors are live, reachable, licensed for redistribution, or uptime-verified.
- Ground-truth SOC/SOH labels are scientifically validated beyond the audited metadata/schema checks.
- Future filters, ECMs, Kalman filters, observers, AI estimators, or hybrid estimators have been benchmarked by this validation.

## Pass/Fail Summary

D1-D6 deep validation status: PASS WITH CAUTIONS.

The six dataset branches are valid integration candidates based on matching local/remote heads, completion-like logs, clean branch worktrees, and focused gate reruns. Integration should proceed through a merge queue with clean environment replay, combined test execution, and strict claim-language review.

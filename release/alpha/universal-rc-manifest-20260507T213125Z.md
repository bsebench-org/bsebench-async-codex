# GLASSBOX Universal Benchmark Alpha RC Manifest

- Worker: W5-11
- Branch: `phase-8-4-k-release-candidate-manifest-20260507T213125Z`
- Created UTC: 2026-05-07T21:37:24Z
- Baseline commit: `357e990ffd23c3d41581117bb02bf7368816ddcd`
- Owned write-set: `release/alpha/universal-rc-manifest-20260507T213125Z.md`
- Artifact type: release-readiness manifest, not publication prose
- Release state: `alpha-rc-manifest-draft`
- Publication state: `blocked`

## Purpose

This manifest binds the current universal SOC/SOH benchmark alpha release
candidate inputs to observed branch heads, validation artifacts, known blockers,
and non-claims.

It does not merge source branches, create a public version, publish benchmark
results, register claims, or approve release. It is a fail-closed inventory for
the next integration operator.

## Evidence Sample

Commands run from this W5-11 worktree:

```bash
git fetch --all --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-runner fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-stats fetch origin --prune
git -C /mnt/c/doctorat/bsebench-org/bsebench-datasets fetch origin --prune
git branch -vv
git for-each-ref --format='%(refname:short) %(objectname:short) %(subject)' refs/remotes/origin/phase-8-3-*
git diff --name-status origin/main...origin/<branch>
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-[012]-*.log' | wc -l
rg -l "You've hit your usage limit|usage limit" /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-[012]-*.log
git diff --check
```

Observed log state at sampling:

| Set | Count | Manifest treatment |
| --- | ---: | --- |
| Stable Wave 1-3 logs, `manual-phase-8-[012]-*.log` | 48 | Stable denominator for original Phase 8 task set. |
| Original usage-limit failures | 3 | `phase-8-2-j`, `phase-8-2-k`, and `phase-8-2-l`; do not merge original placeholders. |
| All Phase 8 manual logs | 92 | Live and volatile; do not use as a stable denominator. |
| Wave 4 logs | 25 | Supporting evidence only after pushed branch head and artifact validation. |
| Wave 5 logs | 16 | Active integration wave; treat as moving context. |

## RC Input Branches

The RC input set is branch-head evidence. It is not an integrated release
branch yet.

### Runner Code Lane

Repository: `/mnt/c/doctorat/bsebench-org/bsebench-runner`

| ID | Branch | Head | Artifact surface | Validation state |
| --- | --- | --- | --- | --- |
| R1 | `phase-8-0-a-universal-runner-estimator-plugin-contract` | `7f590c2` | `estimator_contract.py`, toy adapter fixture, contract tests | Ready for controlled integration; W4 runner validation replayed focused tests. |
| R2 | `phase-8-0-b-universal-runner-protocol-registry` | `acf95fa` | `protocol_registry.py`, registry tests | Ready for controlled integration. |
| R3 | `phase-8-0-c-universal-runner-degraded-initialization` | `944a152` | initialization policy and orchestrator tests | Ready; review shared `tests/test_orchestrator.py`. |
| R4 | `phase-8-0-d-universal-runner-leakage-split-guard` | `5d8efab` | split guard and exports | Ready; review `src/bsebench_runner/__init__.py`. |
| R5 | `phase-8-0-e-universal-runner-compute-profiling-hooks` | `2006dff` | profiling hooks and orchestrator metadata | Ready; review `__init__.py` and orchestrator overlap. |
| R6 | `phase-8-0-f-universal-runner-submission-smoke` | `ce792f3` | external submission example and smoke test | Ready; commit subject lacks GLASSBOX prefix but body evidence was reported. |

Runner validation summary:

- W4-04 temporary R1-R6 merge over `origin/main`: no conflicts.
- Integrated focused runner suite: `43 passed`.
- Branch-focused gates passed for R1-R6.
- Open runner replay before promotion: full non-slow runner gate, lint/format,
  and `git diff --check` on the integrated tree.

### Stats Code Lane

Repository: `/mnt/c/doctorat/bsebench-org/bsebench-stats`

| ID | Branch | Head | Artifact surface | Validation state |
| --- | --- | --- | --- | --- |
| S1 | `phase-8-0-g-universal-stats-metric-matrix` | `646bf3c` | metric matrix schema and tests | Ready with integration conflict caution. |
| S2 | `phase-8-0-h-universal-stats-convergence-metrics` | `eddb345` | convergence recovery metrics and tests | Ready; replay with isolated/fresh env. |
| S3 | `phase-8-0-i-universal-stats-robustness-noise-schema` | `0d7e275` | robustness noise schema and tests | Ready. |
| S4 | `phase-8-0-j-universal-stats-compute-cost-aggregator` | `f11a151` | compute cost helpers and tests | Ready. |
| S5 | `phase-8-0-k-universal-stats-multi-axis-ranking` | `f42e0a0` | multi-axis ranking helper and tests | Ready; local upstream hygiene warning in validation. |
| S6 | `phase-8-0-l-universal-stats-transfer-matrix` | `59dfd52` | transfer matrix helper and tests | Ready. |

Stats validation summary:

- W4-05 replayed focused gates: S1 `12 passed`, S2 `6 passed`, S3 `8 passed`,
  S4 `6 passed`, S5 `10 passed`, S6 `10 passed`.
- Branch diff checks passed for all six stats branches.
- Blocking integration caution: all six touch
  `src/bsebench_stats/__init__.py`; merge serially and preserve additive export
  union.
- Open stats replay before promotion: focused test after each merge, import
  checks for top-level exports, full non-slow gate in a fresh environment,
  lint/format, and `git diff --check`.

### Datasets Code Lane

Repository: `/mnt/c/doctorat/bsebench-org/bsebench-datasets`

| ID | Branch | Head | Artifact surface | Validation state |
| --- | --- | --- | --- | --- |
| D1 | `phase-8-0-m-universal-datasets-etl-contract` | `6b6bab2` | ETL field contract and tests | Ready. |
| D2 | `phase-8-0-n-universal-datasets-ground-truth-audit` | `a52c81d` | ground-truth metadata audit and exports | Ready with export-conflict caution. |
| D3 | `phase-8-0-o-universal-datasets-split-metadata` | `2f0caba` | split metadata contract | Ready; replay in isolated/fresh env. |
| D4 | `phase-8-0-p-universal-datasets-card-schema` | `e5f2305` | dataset card schema and tests | Ready with export-conflict caution. |
| D5 | `phase-8-0-q-universal-datasets-equipment-registry` | `96566f9` | equipment registry schema and tests | Ready. |
| D6 | `phase-8-0-r-universal-datasets-monthly-availability` | `c1af5d0` | availability snapshot schema and tests | Ready with export-conflict caution. |

Datasets validation summary:

- W4-06 replayed focused gates: D1 `8 passed`, D2 `5 passed`, D3 `21 passed`,
  D4 `14 passed`, D5 `9 passed`, D6 `3 passed`.
- D1-D6 local heads matched fetched remote heads after validation.
- Blocking integration caution: D2, D4, and D6 conflict around
  `src/bsebench_datasets/__init__.py`; merge serially and preserve export
  union.
- Open datasets replay before promotion: clean environment, split schema tests,
  focused branch gates, combined non-slow suite, and explicit license/source
  caveats.

### Async And Control-Plane Lane

Repository: this CTO report repo.

| Group | Branches | Heads / status | Artifact surface | RC treatment |
| --- | --- | --- | --- | --- |
| Async Wave 1 | `phase-8-0-s` through `phase-8-0-x` | `8b8110b`, `669a4ea`, `9ee3b55`, `cbd60b3`, `1a337a6`, `ce60824` | submission template, monthly snapshot schema, charter gate, disjoint planner, public checklist, no-idle policy | Ready as control-plane inputs after script/doc gate replay. |
| Wave 2 validators/audits | `phase-8-1-k` through `phase-8-1-v` | fetched heads present | validation reports, conflict map, API/source-ledger/risk/workflow/test-budget/backlog artifacts | Mostly ready; `phase-8-1-o` has a concrete whitespace blocker. |
| Wave 3 methodology audits | `phase-8-2-a` through `phase-8-2-i` | fetched heads present | ground truth, leakage, metrics, compute, cross-chemistry, ETL, sandbox, report comparability, licensing audits | Ready as report-only evidence after final guardrail scans. |
| Failed Wave 3 placeholders | `phase-8-2-j`, `phase-8-2-k`, `phase-8-2-l` | no completed artifact | reproducibility manifest audit, merge runbook, worker triage runbook attempts | Blocked; exclude original placeholders. |
| Wave 4 retries | `phase-8-3-a`, `phase-8-3-b`, `phase-8-3-c` | `4185c09`, `10415cd`, `1bb6ad4` | retry reproducibility manifest audit, merge runbook, worker triage runbook | Replacement evidence exists now; re-run final guardrails before merge. |
| Wave 4 deep validation/support | `phase-8-3-d` through `phase-8-3-y` | fetched heads present for listed remote refs | runner/stats/datasets/async validation, branch ledger, guardrail audits, specs, readiness dashboard, DoD | Supporting evidence, not automatic merge approval. |
| Wave 5 local integration | `phase-8-4-d` | local `fb81fb4`, ahead of `origin/main`, behind by one at inspection; no `origin/phase-8-4-d` observed | local integration of async Wave 1, Wave 2, methodology audits | Not an RC base until rebased/fetched/pushed and validated. |

## Supporting Artifacts To Carry Forward

| Artifact | Branch | Required use |
| --- | --- | --- |
| Branch ledger | `phase-8-3-h` / `b5b0adf` | Pin every branch, repo, head SHA, validation status, and failed placeholder accounting. |
| Merge readiness dashboard | `phase-8-3-t` / `2d550ef` | Preserve ready/needs-fix/blocked lane classifications and merge-order cautions. |
| Definition of done | `phase-8-3-x` / `8d3f428` | Apply gates for code, data, metrics, reproducibility, claims, and community workflow. |
| Source-ledger schema | `phase-8-3-k` / `808d046` | Block comparison claims until source-ledger and claim-binding rows are complete. |
| Unsupported-claim audit | `phase-8-3-j` / `a6e9296` | Re-run claim language scans after final integration. |
| Monthly snapshot artifact schema retry | `phase-8-3-y` / `55599bf` | Use as the release artifact wrapper; no fake published version. |
| Reproducibility manifest retry | `phase-8-3-a` / `4185c09` | Require manifest fields before snapshot freeze. |
| Merge queue runbook retry | `phase-8-3-b` / `10415cd` | Use serial queue with conflict notes and post-merge replay. |
| Worker triage runbook retry | `phase-8-3-c` / `1bb6ad4` | Preserve failure evidence and avoid retry loops. |

## Open Blockers

| ID | Severity | Blocker | Current evidence | Required close-out |
| --- | --- | --- | --- | --- |
| B-001 | P0 | No assembled, pushed alpha RC integration branch across runner, stats, datasets, and report lanes. | This W5-11 branch only adds this manifest. Source branches remain independent inputs. | Build explicit integration branches per repo, pin exact SHAs, merge serially, and run post-merge gates. |
| B-002 | P0 | `phase-8-1-o` integration conflict map has trailing whitespace. | W4-07 and W4-20 replay found `audits/wave-1/integration-conflict-map-20260507T193050Z.md:3` and `:4` fail `git diff --check`. | Fix or supersede the branch, rerun `git diff --check`, then merge. |
| B-003 | P0 | Source-ledger completion is absent for public comparison claims. | Source-ledger audit/spec define gates; no completed ledger rows for external comparisons were inspected. | Create source ledger and claim-binding ledger before any SOTA, novelty, leaderboard, breakthrough, or verified-claim wording. |
| B-004 | P0 | Stats export conflicts are expected. | All S1-S6 add top-level exports in `src/bsebench_stats/__init__.py`. | Merge stats branches one at a time with additive export union and import tests. |
| B-005 | P0 | Dataset export conflicts are expected. | D2, D4, and D6 touch `src/bsebench_datasets/__init__.py`. | Merge datasets serially with additive export union and focused tests after each merge. |
| B-006 | P1 | Stale or local-only integration evidence exists. | `phase-8-4-d` is local and not an observed pushed remote branch at sampling. | Rebase/refresh, push, and validate before using as RC base. |
| B-007 | P1 | Some validations depend on local environment workarounds. | Runner imports need `BSEBENCH_LEGACY_AUTORESEARCH_DIR`; stats S2/S5 and datasets D3 require isolated/fresh env. | Encode environment setup in integration replay commands and avoid treating stale venv failures as source failures. |
| B-008 | P1 | Full integrated CI has not been run in any assembled RC tree. | Wave 4 evidence is focused replay plus merge-tree/temp merges, not full release CI. | Run repo-specific non-slow gates, lint/format, shell/doc gates, protected-path scan, unsupported-claim scan, and `git diff --check`. |
| B-009 | P1 | Public submission sandbox policy is still audit/spec evidence, not enforced infrastructure. | Submission sandbox security audit exists; no enforced public untrusted-code runner is in this manifest. | Keep alpha intake template-only or block arbitrary public code execution until sandbox gate is implemented. |
| B-010 | P1 | Monthly snapshot artifact is schema/spec-only. | Monthly snapshot and artifact schemas exist, but no frozen monthly snapshot bytes, hashes, or source-ledger bundle exist. | Produce a draft snapshot artifact with hashes, commands, gates, residual risks, and `release_status=release_candidate`. |

## Required Integration Replay

Before any alpha RC is described as frozen, run and record at least:

```bash
# Runner
BSEBENCH_LEGACY_AUTORESEARCH_DIR=/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch \
  uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check

# Stats
uv run pytest tests/test_metric_matrix.py tests/test_convergence.py tests/test_robustness_noise_schema.py tests/test_compute_cost.py tests/test_multi_axis_ranking.py tests/test_transfer_matrix.py
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check

# Datasets
uv run pytest tests/test_etl_contract.py tests/test_ground_truth_metadata_audit.py tests/test_split_audit_j_v1.py tests/test_dataset_card.py tests/test_equipment_registry.py tests/test_availability_snapshot.py
uv run pytest -m "not slow" --tb=short
uv run ruff check .
uv run ruff format --check .
git diff --check

# Async/report
bash -n scripts/*.sh
bash scripts/check-research-brief-gates.sh --dry-run
bash scripts/check-no-idle-capacity-policy.sh
bash tests/test-disjoint-wave-planner.sh
git diff --check
```

Also run these release guardrails on the assembled report branch:

```bash
rg -n "Co-Authored-By: Claude" .
rg -n "(SOTA|state[- ]of[- ]the[- ]art|leaderboard|breakthrough|verified claim|novelty|novel|outperform|best in the literature|leaderboard winner)" release docs audits specs templates README.md
git diff --name-only origin/main...HEAD | rg '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP)' || true
git diff --check
```

Any positive hit must be reviewed in context. Guardrail examples, blocked-word
lists, and negative fixtures are allowed only when clearly framed as rejection
or test cases.

## Non-Claims

- This manifest does not claim BSEBench is public-ready.
- This manifest does not create a release version, publication tag, leaderboard,
  result table, or monthly frozen snapshot.
- This manifest does not claim SOTA, novelty, breakthrough, verified scientific
  validity, or superiority for any ECM, Kalman filter, observer, AI estimator,
  hybrid method, baseline, or future filter.
- This manifest does not validate SOC/SOH numerical results.
- This manifest does not certify source-ledger completeness, dataset licensing,
  public availability, redistribution rights, or remote endpoint uptime.
- This manifest does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

## W5-11 Artifact Validation

| Check | Status |
| --- | --- |
| Owned write-set limited to `release/alpha/universal-rc-manifest-20260507T213125Z.md` | PASS |
| No source branch merge performed by W5-11 | PASS |
| No public version or publication claim introduced | PASS |
| Claim-language terms in this manifest | PASS as guardrail/blocker/non-claim context only |
| `git diff --check` after writing | PASS |

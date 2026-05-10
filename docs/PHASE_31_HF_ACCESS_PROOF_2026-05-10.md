# Phase 31 HF Access Proof

Date: 2026-05-10
Status: CLOSED WITH BLOCKERS
Runner commit: `9d43f1d`
Claim status: `NO_CLAIM`

## Objective

Prove dataset access for the Phase 28 real micro-slice before building any further KPI, ranking, or BSE-Score logic.

## Definition Of Done

- Hugging Face authentication checked without recording the token in repo artifacts.
- Each Phase 28 selected config probed for expected Tier 2 repository and expected file presence.
- Each selected config loader called once when possible.
- Phase 29 rerun under authenticated HF access.
- Blockers logged as data-access or Tier 2 packaging issues, not hidden as model failures.

## Result

Phase 31 is partially proven and still blocked.

Authentication now works:

- `auth_probe.status`: `authenticated`
- `auth_probe.name`: `akiroussama`
- token is stored only in the local Hugging Face cache, not in the repo.
- `policy.token_recorded`: `false`

Dataset access proof:

| Config | Repo status | Expected file status | Loader status | Verdict |
|---|---|---|---|---|
| `calce_legacy:DST:T25` | Tier 2 repo inaccessible | missing | failed | blocked |
| `calce_a123_dyn:DST:T20` | Tier 2 repo inaccessible | missing | failed | blocked |
| `panasonic:US06:T10` | Tier 2 repo inaccessible | missing | failed | blocked |
| `nasa:CC-discharge:T24` | accessible | present | loaded, `N=197` | proven |
| `lg_hg2:WLTC_P066:T25` | repo accessible | Parquet missing | failed | blocked |
| `yao:BCDC:T35` | repo accessible | Parquet missing | failed | blocked |
| `calce_inr_dyn:DST:T25` | Tier 2 repo inaccessible | missing | failed | blocked |

Summary from `outputs/phase31_hf_access_proof_20260510.json`:

```text
status=dataset_access_partially_proven_with_blockers
selected_config_count=7
load_proven_count=1
blocked_config_count=6
repo_accessible_count=3
expected_file_complete_count=1
blockers=22
```

## Phase 29 Authenticated Rerun

The authenticated rerun improves the previous Phase 29 result:

```text
previous: sentinel_cells=21/21
current:  sentinel_cells=19/21
```

The two completed cells are the NASA config under `GRU_light` and `SO_SMO`.
`EKF` on NASA reaches filter execution but fails at step 0:

```text
soc_estimated must be bounded in [0, 1]
```

This is now a real model/contract issue for the NASA config, separate from dataset-access failures.

## Artifact Hashes

| Artifact | SHA-256 |
|---|---|
| `bsebench-runner/outputs/phase31_hf_access_proof_20260510.json` | `b43f9da4161d2c2e494b2c4a7391ca1272102caab955325770b6b69f3ddaf328` |
| `bsebench-runner/outputs/phase29_real_micro_run_20260510_hf_token_rerun.json` | `ebe499fcd1e7013e040390a43d9ce4f51000e65f8f12633ddcca8000d769f4fd` |

## Validation

Executed in `bsebench-runner`:

```bash
uv run pytest tests/test_phase29_real_micro_run.py tests/test_phase31_hf_access_proof.py
uv run ruff check src/bsebench_runner/phase31_hf_access_proof.py scripts/phase31_hf_access_proof.py tests/test_phase31_hf_access_proof.py
git diff --check
```

Result:

```text
7 passed
All checks passed
git diff --check clean
```

Secret scan over the new files found no raw HF token. The only token-related strings are policy/test text and Hugging Face error prose.

## Scientific Interpretation

The original Phase 29 blocker has been decomposed:

1. Authentication was missing before; now fixed locally.
2. NASA Tier 2 access is real and loadable.
3. Six selected configs still lack the exact Tier 2 Parquet contract expected by current loaders.
4. Several raw mirrors exist, but raw mirror accessibility is not equivalent to benchmark-ready Tier 2 access.
5. The next work must package or publish Tier 2 Parquet artifacts for the blocked configs, not build more scoring logic.

## Do Not Claim

Do not claim:

- full benchmark execution,
- KPI completeness,
- BSE-Score readiness,
- model ranking,
- method superiority,
- or harmonized dataset coverage beyond the one proven NASA micro-slice.

Allowed claim:

> Phase 31 proves authenticated HF access and one real loadable micro-slice config, while identifying six remaining Tier 2 packaging/access blockers.

## Next Phase

Recommended Phase 32:

Goal: repair Tier 2 packaging/access for the six blocked configs.

Definition of Done:

- exact expected Parquet files exist in the expected Tier 2 repos, or loader constants are formally amended to new Tier 2 repos;
- raw repos are not treated as Tier 2 success unless a harmonization step generates the expected Parquet contract;
- Phase 31 rerun reaches `load_proven_count=7/7`;
- Phase 29 rerun has zero loader-stage failures;
- remaining sentinels, if any, are model/filter issues with failure traces.

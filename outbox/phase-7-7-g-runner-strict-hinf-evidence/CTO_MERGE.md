# CTO Merge: phase-7-7-g-runner-strict-hinf-evidence

Status: approved and pushed

Actor: codex-cto-FR

UTC: 2026-05-07T04:21:42Z

## Context

Phase 7.7.b approved the Hinf evidence-bundle tooling, but real execution was
blocked by Hugging Face authentication / repository access. The strict rule
remained unchanged: no Hinf evidence can be accepted unless all five target
configs and all twenty-five filter runs complete.

CTO recovered exact local cache inputs for the five strict configs and reran the
strict evidence path from the primary `bsebench-runner` checkout.

## Change

Repository: `bsebench-runner`

Commit: `d21e059a1eb3e1128959c6cc3ca7cd01b0f0b12a`

Subject: `GLASSBOX [role: codex-cto-FR] Commit strict Hinf 5x5 evidence bundle`

Pushed to: `origin/main`

Changed / added files:

- `scripts/hinf_residual_evidence_5x5.py`
- `tests/test_hinf_residual_evidence_5x5.py`
- `outputs/hinf_residual_cache_preflight.json`
- `outputs/chi2_sweep_5x5.json`
- `outputs/hinf_residual_evidence_5x5.json`

The code change only exposes the existing anti-claim guardrails at the bundle
top level:

- `mechanical_evidence_only=true`
- `claim_55_targeted=false`

The output artifacts are mechanical evidence, not a scientific verdict.

## Evidence Gates

Strict local cache preflight:

- `ok_configs=5`
- `missing_configs=0`
- `evidence_ready=true`

Chi2 5x5 sweep:

- `ok=25`
- `skipped=0`
- `error=0`

Hinf residual evidence bundle:

- `trace.summary.ok_configs=5`
- `trace.summary.error_configs=0`
- `trace.summary.ok_filter_runs=25`
- `trace.summary.error_filter_runs=0`
- Hinf status `ok` on all five configs
- stats covariance panel `ok_configs=5`
- stats variance decomposition `ok_configs=5`

Guardrails:

- `scientific_verdict="none"`
- `claim_target="new_hinf_candidate_not_claim_55"`
- `mechanical_evidence_only=true`
- `claim_55_targeted=false`
- `stats_import.selected_stats_src=/mnt/c/doctorat/bsebench-org/bsebench-stats/src`

## Cache Provenance

Local cache roots used for the strict run:

- `yao=/tmp/bsebench_yao_tier2_cache`
- `panasonic=/tmp/bsebench_panasonic_tier2_cache`
- `nasa=/tmp/bsebench_nasa_tier2_cache`
- `calce_legacy=/tmp/bsebench_calce_legacy_tier2_cache`

Raw / generated provenance snapshot:

| Item | Bytes | SHA256 |
|---|---:|---|
| NASA Kaggle ZIP `nasa-battery-dataset.zip` | 209672520 | `94da1e5f4c8edb9a2fb96d2a9fc2fd24f5af8af85a5691117928ed8ba7a411d6` |
| NASA extracted `B0005.mat` | 15956874 | `0eae4585baf3f200c09fe24c5ab884f1889679fc75206ca1aa19da704104f0b0` |
| Yao US06 raw CSV `9_US06_25deg.csv` | 9557212 | `fbe32df81498de797f91bfa97e33dd4f04548e4aae7be53f8faf42dd7b98b25e` |
| Panasonic raw MAT `03-20-17_01.43 25degC_US06_Pan18650PF.mat` | 1414084 | `c12a57f8fa2bfcb7fcd30f243781390e1567acb369da647e6bdc08885deb0ac4` |
| CALCE legacy raw `A123_25C.csv` | 904228 | `0fdaea979be1f09c69ae9aa63e9fdfe2f53e041245d07b8a2f51fdca3201d3ab` |
| Tier 2 `Yao-BCDC-T25.parquet` | 3374546 | `bc10913e1cedfb1a028fcd298a85eca2bc9de269bb6bf3ba6a3499ebd526dac6` |
| Tier 2 `Yao-US06-T25.parquet` | 2283028 | `89b22c9a6a220c77537d97135e8e43fb8b926dda141c7dd8eb441c8b365658a9` |
| Tier 2 `pan_US06_T25.parquet` | 541661 | `bedd9e41c347d31b7bc3388ad0454538fc9f3fc6e77c5f287a9cade24570337f` |
| Tier 2 NASA `metadata.csv` | 228 | `b64f245e2bf8d432d1e02f0d9f04fd4efee05554608f1f5e09be7c60c6b9297c` |
| Tier 2 NASA `B0005_test1.parquet` | 10771 | `de20fe2fe81f478214f44b93d7d49ebfe563372573df724f6fd222c075069674` |
| Tier 2 `calce_a123_DST_T25.parquet` | 292866 | `18587ddfbddafdc20d618a99c6688fbad3047c1e5afe71147923051befafa085` |

NASA detail:

- Public Kaggle API returned a 209672520-byte ZIP for
  `patrickfleith/nasa-battery-dataset`.
- The ZIP contains original `.mat` files, not the cleaned CSV layout.
- CTO extracted `battery_dataset/BatteryAgingARC-FY08Q4/B0005.mat`.
- The generated Tier 2 cache uses B0005 first eligible discharge at 24 C,
  `Capacity=1.8564874208181574 Ah`, `N=197`, duration `3690.234 s`, and mean
  discharge current `2.0126207740316393 A`.

## Validation

Local CTO gates:

- focused Hinf evidence test: `9 passed`
- focused combined Hinf suite: `28 passed`
- full runner non-slow: `98 passed, 5 deselected`
- `uv run --locked --all-extras ruff check .`: pass
- `uv run --locked --all-extras ruff format --check .`: pass
- JSON validity on all three committed output artifacts: pass
- finite residual audit on Hinf arrays: pass
- `git diff --check`: pass
- independent stats-side replay from the committed runner bundle: pass
  - covariance summary matches embedded bundle summary
  - variance-decomposition summary matches embedded bundle summary

Independent validator `Boole`: GO.

Boole confirmed:

- no coauthor trailer;
- no `NaN`, `Infinity`, or `-Infinity`;
- exact five config labels and five filter labels;
- strict preflight / chi2 / evidence summaries;
- `stats_import.selected_stats_src` points to the intended sibling stats repo;
- Hinf is `ok` on all five configs.

## Scope Boundary

This approves a mechanical evidence bundle only. It does not verify, retract,
rename, or update any thesis claim. The prior claim identity block still holds:
Hinf residual covariance/decomposition must not be written into historical
`claim_55`; it remains `new_hinf_candidate_not_claim_55` until registry identity
is explicitly resolved.

## Next Step

The independent stats-side replay is complete and passed. Next, decide whether
to add a small machine-checkable provenance replay script or proceed to
claim-candidate drafting under a new claim id.

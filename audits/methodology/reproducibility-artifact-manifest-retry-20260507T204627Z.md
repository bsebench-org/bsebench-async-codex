# GLASSBOX Reproducibility Artifact Manifest Retry Audit

[role: worker-codex-FR]

## Objective

Retry and complete the Wave 3 reproducibility artifact manifest audit that
stopped at the Codex usage limit. This artifact defines the minimum manifest
contract required for every monthly BSEBench snapshot so runner, stats,
datasets, and async artifacts can be replayed or rejected without relying on
memory, unpublished state, or unsupported claim language.

## Scope And Evidence Inspected

- Current branch: `phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z`.
- Owned output path: `audits/methodology/reproducibility-artifact-manifest-retry-20260507T204627Z.md`.
- Prior failed log: `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`.
- Retry log: `/home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-3-a-retry-repro-artifact-manifest-20260507T204627Z.log`.
- Runner repo inspected at `/mnt/c/doctorat/bsebench-org/bsebench-runner`, `HEAD=66bd827`, branch `main`.
- Stats repo inspected at `/mnt/c/doctorat/bsebench-org/bsebench-stats`, `HEAD=ad24842`, branch `phase-7-10-a-stats-hinf-uncertainty-report`.
- Datasets repo inspected at `/mnt/c/doctorat/bsebench-org/bsebench-datasets`, `HEAD=2b97c25`, branch `main`.
- Protocol sources inspected: `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md` and `docs/PROTOCOL.md`.

## Commands Run

```bash
git status --short --branch
find /home/oakir/.local/state/bsebench-async-watchdog -maxdepth 1 -type f -name 'manual-phase-8-*.log' -printf '%f\n' | sort
for f in /home/oakir/.local/state/bsebench-async-watchdog/manual-phase-8-{0,1,2}-*.log; do ...; done
git ls-remote --heads origin 'phase-8-*'
sha256sum outputs/*.json outputs/*.md
jq 'if type=="object" then keys else type end' outputs/hinf_residual_artifact_manifest.json
uv run python scripts/audit_hinf_residual_manifest.py
uv run python scripts/audit_hinf_residual_ci_summary.py
uv run python scripts/replay_hinf_residual_stats.py --evidence ../bsebench-runner/outputs/hinf_residual_evidence_5x5.json
uv run python - <<'PY'
from bsebench_datasets.hinf_loader_provenance import format_summary, run_audit
payload = run_audit(runner_root='../bsebench-runner')
print(format_summary(payload))
PY
git diff --check
```

## Prior Failure Accounting

The pre-retry Phase 8 log set was checked directly, excluding Wave 4 retry logs:

- `prior_phase8_logs=48`
- `completion_like_by_no_early_usage=45`
- `early_usage_limit=3`
- Failed early-usage logs:
  - `manual-phase-8-2-j-reproducibility-artifact-manifest-audit-20260507T193528Z.log`
  - `manual-phase-8-2-k-merge-queue-runbook-20260507T193528Z.log`
  - `manual-phase-8-2-l-worker-triage-and-relaunch-runbook-20260507T193528Z.log`

The original `phase-8-2-j` log contains only the task prompt and two usage-limit
errors before any artifact write. This retry therefore supersedes only the
missing manifest audit artifact; it does not imply that the other two failed
Wave 3 tasks were completed by this branch.

## Existing Artifact Shape Observed

The strict runner Hinf bundle already has a narrower manifest:
`outputs/hinf_residual_artifact_manifest.json`.

Observed top-level keys:

```text
artifacts
claim_55_targeted
claim_target
created_utc
guardrails
locked_dependencies
mechanical_evidence_only
notes
repositories
schema_version
scientific_verdict
script
strict_summary
```

Observed runner artifact hashes:

```text
8fc425f73213a3aa81511dde7e4db3fdb507edffebb2a4d819f219383f0255aa  outputs/hinf_residual_artifact_manifest.json
e002d37837e8ee6c4ddfa43b5c4607a6278ce240f1839642ddc9fd85c01329d7  outputs/hinf_residual_cache_preflight.json
ab1c3d92e762aa00365b3b2b1b1bd98dc0d87fc78519cdfb211e242135158d20  outputs/chi2_sweep_5x5.json
35c255c696fd9b63552c2206d08009aea834c17f3f09e2bd49b7ac5666917f78  outputs/hinf_residual_evidence_5x5.json
c2156136123b6fb0b0ef584ebb0edd75c123c37cc31382f2134bc393d369a0ca  outputs/hinf_residual_sensitivity_5x5.json
6682c8cf85b0009ea16f37291d9dbbefcb53211a48d04f66ce3cef130a218e20  outputs/hinf_candidate_report_summary.json
da0ce9affaa809a77758c95ae56a6ab8965b5b35008c20293120e4c98ef27647  outputs/hinf_candidate_report.md
50eb3018e1bcbe663bddb9cc3bfc3a4ee1907f523b22695dc38be3f007ba5457  outputs/chi2_smoke_yao_bcdc_t25.json
```

The stats and datasets repos had no committed `outputs/` files in the inspected
working copies. They still contribute mandatory replay and provenance
requirements through source scripts, dataset manifests, local-cache audits, and
branch/lock identity.

## Monthly Snapshot Manifest Contract

Every monthly BSEBench snapshot must include one machine-readable manifest,
preferably `snapshot_manifest.json`, committed with the snapshot branch or tag.
The manifest should reject unknown top-level fields and must be valid JSON with
no NaN, Infinity, or non-finite numeric values.

Required top-level fields:

| Field | Required content |
|---|---|
| `schema_version` | Literal version such as `bsebench-monthly-snapshot-manifest/v1`. |
| `snapshot_id` | Stable ID, e.g. `2026-05-monthly`. |
| `created_utc` | ISO-8601 UTC timestamp generated at freeze time. |
| `scope` | Snapshot lane list: `runner`, `stats`, `datasets`, `async`, plus any excluded lane with reason. |
| `repositories` | Per-repo remote URL, branch, commit SHA, dirty status, and lockfile hashes. |
| `environment` | OS, Python version, package manager command, `uv --version`, selected env vars, and hardware/GPU fields if compute timing is reported. |
| `commands` | Exact commands used to generate, audit, and replay every included artifact. |
| `inputs` | Dataset/config/filter/observer identifiers, split IDs, local cache roots or explicit unavailable-cache notes, and input artifact hashes. |
| `artifacts` | Content-addressed list of every committed JSON, CSV, Parquet, Markdown report, lockfile, and schema file supporting the snapshot. |
| `hash_policy` | Hash algorithm, path normalization, size-byte recording, and which files are intentionally excluded. |
| `replay` | Independent replay commands, expected compared-value counts, tolerances, mismatch thresholds, and pass/fail result. |
| `dataset_provenance` | Dataset manifest names, canonical source fields, license/redistribution fields, cache readability status, and documented provenance gaps. |
| `metrics` | Exact metric IDs, units, directionality, denominator policy, uncertainty policy, and split association. |
| `guardrails` | `scientific_verdict`, `mechanical_evidence_only`, `claim_target`, `claim_registry_edited`, `thesis_or_manuscript_edited`, and source-ledger status. |
| `failures` | Skipped, errored, unavailable, or partial artifacts with explicit cause and owner; no silent omission. |
| `non_claims` | Explicit text stating what this snapshot does not establish. |

Required artifact entry fields:

| Field | Required content |
|---|---|
| `role` | Semantic role such as `runner_evidence`, `stats_replay`, `dataset_manifest`, `source_ledger`, `report`, `lockfile`. |
| `path` | Repository-relative path; absolute paths are forbidden in committed manifests except in local-only environment diagnostics. |
| `repo` | Owning repo key from `repositories`. |
| `sha256` | SHA-256 of the exact committed bytes. |
| `size_bytes` | File size from the filesystem at freeze time. |
| `schema_version` | Parsed schema version for JSON/YAML artifacts when available. |
| `generated_by` | Command ID from `commands`; `manual` requires a rationale and reviewer. |
| `inputs` | Input artifact IDs or dataset/config IDs used to produce this file. |
| `audit_status` | `pass`, `fail`, `partial`, or `not_run`, with reason. |

Required command entry fields:

| Field | Required content |
|---|---|
| `id` | Stable command identifier referenced by artifacts and replay sections. |
| `cwd_repo` | Repo key and working directory. |
| `argv` | Exact argv string or array. |
| `env` | Relevant env vars with secret values redacted and unavailable vars explicitly marked. |
| `exit_code` | Command exit code. |
| `stdout_digest` | SHA-256 of captured stdout when stored outside git, or committed log artifact path and hash. |
| `result_summary` | Human-readable counts: values compared, mismatches, skipped items, tolerances, and status. |

## Hash And Environment Policy

- SHA-256 is mandatory for every committed artifact, lockfile, and schema file.
- `size_bytes` is mandatory so truncated or line-ending-altered files fail audit.
- Repos must record full commit SHAs, not only seven-character abbreviations.
- Lockfiles must be hashed and linked to the package manager command. If no
  lockfile exists, the manifest must say `lockfile_status=missing`.
- Local dataset caches are not silently trusted. The manifest must either hash
  the local input file, cite an existing dataset manifest hash, or mark the
  cache metadata as unavailable.
- Secret-bearing environment variables must be listed by name with
  `value_status=redacted`, never copied into the manifest.
- Hardware and timing fields are required only when compute-cost or timing
  claims are reported; otherwise they may be `not_applicable`.

## Pass/Fail Findings

| Finding | Status | Evidence |
|---|---|---|
| Prior Wave 3 `M-REPRO` artifact was absent because the worker hit usage limit before writing. | Pass | Direct first-80-line inspection of `manual-phase-8-2-j...log`. |
| The pre-retry Phase 8 known state was correctly accounted for. | Pass | 48 prior logs, 45 completion-like, 3 early usage-limit stops. |
| Runner strict Hinf manifest has artifact hashes and dependency-lock provenance. | Pass | `uv run python scripts/audit_hinf_residual_manifest.py` reported 4 artifacts SHA-256 OK and stats lock `d7e86b7...`. |
| Runner CI summary detects manifest links, strict identity, sidecar status, and committed-output counts. | Pass | `uv run python scripts/audit_hinf_residual_ci_summary.py` reported 5 configs and 5 filters. |
| Stats replay can recompute embedded residual covariance and decomposition sections from committed runner evidence. | Pass | `584` covariance values and `498` decomposition values compared with zero mismatches at `1e-12` tolerances. |
| Datasets provenance audit avoids fabrication when runtime fields are missing. | Pass with gap | NASA B0005 T24 reports missing explicit `dataset`, `chemistry`, and `source_url`; gap is documented, not inferred. |
| Monthly universal snapshot manifest does not yet exist as an integrated artifact. | Recommendation | This document defines the required contract; implementation should add a validator before public monthly release. |

## Recommendations

1. Add a schema validator for `bsebench-monthly-snapshot-manifest/v1` before any
   public monthly snapshot is advertised.
2. Require all snapshot-producing tasks to emit a manifest before report prose.
   Report generation should fail if any included artifact lacks a hash, command,
   repo SHA, or replay status.
3. Promote the existing runner Hinf manifest audit pattern to all lanes:
   runner evidence, stats replay outputs, dataset manifests/cache audits, async
   source ledgers, and public reports.
4. Require a `source_ledger_status` field before any SOTA, novelty,
   leaderboard, or verified-claim wording is allowed. Missing ledger means
   `scientific_verdict=none`.
5. Preserve unavailable metadata as a first-class failure or partial field.
   Never infer dataset provenance, local cache identity, split identity, or
   source comparability from memory.

## Residual Risks

- The inspected stats worktree was on `phase-7-10-a-stats-hinf-uncertainty-report`,
  not `main`; a future monthly manifest must pin the intended stats release SHA.
- Some Phase 8 branches are not integrated into mainline repos yet, so this audit
  defines the manifest standard but does not certify merged Wave 1/Wave 2/Wave 3
  behavior.
- Local cache paths and raw dataset hashes can vary by machine. The manifest
  must distinguish committed artifact hashes from local-only cache diagnostics.
- The current runner manifest is Hinf-specific. Universal monthly snapshots need
  the same rigor for ECMs, Kalman filters, observers, AI estimators, hybrid
  methods, and future filters.
- A passing manifest audit is a reproducibility gate, not a source-ledger gate or
  scientific claim gate.

## Explicit Non-Claims

- This artifact does not claim SOTA, novelty, leaderboard status, breakthrough
  performance, or verified scientific validity.
- This artifact does not edit or validate thesis files, manuscript files,
  `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- This artifact does not certify that all Phase 8 branches are merge-ready.
- This artifact does not certify public dataset redistribution rights beyond
  the inspected manifest fields and provenance-gap handling.
- This artifact does not transform Hinf mechanical evidence into a thesis claim.

## Final Status

Audit result: pass for retry completion and manifest-contract definition.

Required next gate before public monthly release: implement and run a
machine-readable monthly snapshot manifest validator that enforces the fields
above, recomputes hashes, and fails on missing replay or provenance fields.

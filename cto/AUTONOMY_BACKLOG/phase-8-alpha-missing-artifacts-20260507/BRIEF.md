---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex-cto-report
target_branch: phase-8-alpha-missing-artifacts-closeout-20260507
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 8 alpha missing artifacts close-out tasklist

You are a rigorous BSEBench alpha-release evidence coordinator. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Create a fail-closed, current-state alpha missing-artifacts tasklist from W5/W6/W7 evidence so the daemon can queue only concrete release-hardening work. This is a validation and task-routing artifact only; it must not edit the scientific roadmap or convert missing evidence into success.

## Evidence inputs to inspect

Use current refs, not memory. Fetch/read these branches and artifacts:

- W5-11: `origin/phase-8-4-k-release-candidate-manifest-20260507T213125Z`, `release/alpha/universal-rc-manifest-20260507T213125Z.md`.
- W5-13: `origin/phase-8-4-m-community-submission-package-index-20260507T213125Z`, `release/alpha/community-submission-package-index-20260507T213125Z.md`.
- W5-07: `origin/phase-8-4-g-datasets-integration-validator-20260507T213125Z`, `validation/wave-5/datasets-integration-validator-20260507T213125Z.md`.
- W5-08: `origin/phase-8-4-h-async-integration-validator-20260507T213125Z`, `validation/wave-5/async-integration-validator-20260507T213125Z.md`.
- W6 release/red-team blockers: `origin/phase-8-5-a` through `origin/phase-8-5-l`, especially W6-06 alpha red-team, W6-07 compute gate, W6-08 dataset-license red-team, W6-10 submission adversarial spec, and W6-11 no-claims checker spec.
- W7 alpha artifacts when present: `origin/phase-8-6-b`, `origin/phase-8-6-c`, `origin/phase-8-6-d`, `origin/phase-8-6-e`, `origin/phase-8-6-f`, `origin/phase-8-6-g`, `origin/phase-8-6-o`, and `origin/phase-8-6-p`.
- Current runner/stats/datasets remote integration heads:
  - runner `origin/phase-8-4-a-runner-universal-wave1-integration-20260507T213125Z`;
  - stats `origin/phase-8-4-b-stats-universal-wave1-integration-20260507T213125Z`;
  - datasets `origin/phase-8-4-c-datasets-universal-wave1-integration-20260507T213125Z`.

If any ref has moved or is absent, record `unknown` or `blocked` explicitly. Do not infer a pass from a previous branch name or stale report.

## Required output

Add one report-only artifact under a disjoint write-set, for example:

- `release/alpha/missing-artifacts-tasklist-20260507.md`

The artifact must include:

- exact refs and full SHAs inspected for runner, stats, datasets, async/report, W5/W6/W7 evidence, and any missing/absent refs;
- a P0/P1 task table with owner lane, missing artifact, source evidence, required close-out, validation command, and blocking status;
- stale-evidence reconciliation for W5-07 and W5-08: do not mark datasets or async integration ready unless successor pushed-head replay evidence exists and is cited;
- explicit separation between available sidecar/spec/template artifacts and missing executable/generated artifacts;
- a minimum close-out sequence that starts with exact ref pinning and ends with snapshot/report/source-ledger/freeze validation;
- a non-claims section stating that the artifact does not publish, tag, freeze, rank, compare, validate SOC/SOH scientific results, or approve dataset redistribution.

At minimum, the tasklist must cover these missing alpha artifacts from W5/W6 evidence:

- assembled and pushed alpha RC refs or dossier across runner, stats, datasets, and async/report;
- post-merge validation logs on exact assembled refs;
- frozen monthly snapshot candidate JSON plus hash/freeze manifest;
- public report Markdown bound to snapshot values, caveats, and failed-row visibility;
- canonical source ledger, frozen BSEBench value ledger, external-comparison ledger, and line/table/caption binding matrix, or an explicit no-external-comparison release mode;
- dataset license/access/cache/loader/split/provenance closure for each public runnable row;
- community submission packet, lifecycle JSON, package-specific static risk report, dependency restore record, sandboxed smoke bundle, determinism replay report, leakage review report, protocol assignment, evidence artifact manifest, raw metric table, and release hash bundle for any included external estimator;
- executable or manually signed public-claims/no-claims preflight for exact public text;
- compute evidence records with tier/scope/backend/hardware/repeat/caveat fields, or explicit missing/declarative treatment.

## Guardrails

- Do not edit thesis files, manuscript files, claim registry files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.
- Do not edit runner, stats, or datasets repos. Inspect them read-only.
- Do not make SOTA, novelty, leaderboard, breakthrough, superior, universal-proven, verified scientific, or public-ready claims.
- Do not create a public report, release tag, result table, source-ledger values, claim binding, or monthly snapshot by fabrication. Missing artifacts stay missing.
- Do not write `Co-Authored-By Claude`.

## Falsification gate

If the current evidence cannot prove an alpha artifact exists at a pinned ref with validation and hashes, mark that artifact missing or blocked. The tasklist fails its purpose if it upgrades a stale W5/W6/W7 report into a current pass without rechecking the underlying ref.

## Validation

Run and record:

- `git fetch --all --prune` in this repo;
- read-only `git fetch origin --prune` in runner, stats, and datasets, if those repos are available;
- `git diff --name-only origin/main...HEAD`;
- protected-path scan: `git diff --name-only origin/main...HEAD | rg '(^|/)(thesis|manuscript|claims/registry\\.yaml|claim_55|RESEARCH-ROADMAP)' || true`;
- unsupported public-claim language scan over the changed artifact, with hits classified as blockers/examples/non-claims;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

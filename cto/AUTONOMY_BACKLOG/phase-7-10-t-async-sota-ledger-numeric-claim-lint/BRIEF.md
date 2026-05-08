---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-10-t-async-sota-ledger-numeric-claim-lint
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 75
---

# Phase 7.10.t - async SOTA ledger numeric-claim lint

You are a rigorous BSEBench async research-gate engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Block future unsupported comparison language by adding a lightweight async lint that detects external numeric performance claims unless they are tied to a complete source-ledger row and comparability table.

## Required behavior

- Active lane: SOTA comparison, limited to source-ledger validation and anti-hallucination CI fixtures.
- Add a script or shell gate that can lint Markdown/JSON comparison drafts and source-ledger files for numeric external baselines, `SOTA`/novelty language, source IDs, stable URL or DOI, retrieval date, exact metric, dataset, split, BSEBench artifact reference, comparability status, and caveat.
- Include positive and negative fixtures that cover complete ledger rows, missing DOI/URL, missing retrieval date, missing split, unlinked numeric baseline, and forbidden `SOTA` wording.
- The gate must not perform live literature search, invent source metadata, generate new empirical evidence, or edit any claim registry.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this source-ledger lint.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if a fixture can contain a numeric external baseline or SOTA/novelty wording without a linked complete ledger row, if a missing comparability caveat passes, or if the linter permits a claim-verification sentence in a SOTA-comparison draft.

## Validation

Run and record:

- fixture tests for complete source ledger, missing stable URL/DOI, missing retrieval date, missing metric, missing dataset/split, unlinked numeric baseline, missing comparability caveat, and forbidden claim-verification wording;
- `bash scripts/check-sota-source-ledger.sh --fixtures tests/fixtures/sota-ledger`;
- `bash scripts/check-sota-source-ledger.sh outbox/claim-candidate-63-hinf-residual-cov-decomp || true` with the result explained as pass, skip, or expected non-applicability;
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md`;
- `bash -n scripts/check-sota-source-ledger.sh scripts/check-research-brief-gates.sh`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

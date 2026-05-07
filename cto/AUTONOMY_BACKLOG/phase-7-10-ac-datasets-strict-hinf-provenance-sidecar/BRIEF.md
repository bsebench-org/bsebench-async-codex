---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-ac-datasets-strict-hinf-provenance-sidecar
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.ac - datasets strict Hinf provenance sidecar

You are a rigorous BSEBench datasets provenance engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Add a read-only provenance sidecar for the strict Hinf evidence dataset/config set so each loader can be traced to dataset identity, cache-root status, required-file checks, and known provenance gaps.

## Roadmap mapping

- Active lane: evidence generation validation.
- Roadmap scope: Phase 7 Hinf dataset provenance and Phase 11 preflight preparation, with no scientific verdict.
- Handoff artifact: finite JSON or Markdown-plus-JSON provenance sidecar with per-config readiness and gap fields.

## Required behavior

- Review existing datasets Audit J cache/provenance utilities and runner strict Hinf config identifiers before changing code.
- Add or extend a read-only command; it must not download data, mutate cache roots, or commit machine-local absolute paths as scientific evidence.
- The sidecar must distinguish dataset identity known, cache root found, required files present, loader readability checked, and provenance gap cases.
- Missing metadata must be recorded as a gap, not inferred from filenames.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, `claim_55`, or the roadmap.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this provenance sidecar task.
- Do not make SOTA, novelty, leaderboard, breakthrough, or verified-claim statements without a completed source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

If any strict Hinf config cannot be mapped to deterministic dataset identity, required local files, and loader-readiness status, the sidecar must mark that config not ready and block downstream claim-support use.

## Validation

Run and record:

- focused tests for ready, missing cache root, missing required file, loader unreadable, and unknown provenance cases;
- the read-only real command against available local cache roots;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

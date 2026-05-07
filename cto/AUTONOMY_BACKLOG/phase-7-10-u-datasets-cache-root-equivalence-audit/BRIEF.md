---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-7-10-u-datasets-cache-root-equivalence-audit
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-async-codex
hard_wallclock_min: 90
---

# Phase 7.10.u - datasets cache-root equivalence audit

You are a rigorous BSEBench dataset reproducibility engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prove that local-cache manifests used for Hinf, Phase 8, and Phase 11 preflights compare dataset identity and provenance rather than machine-specific root paths.

## Required behavior

- Active lane: Evidence generation, limited to cache/provenance replay tooling.
- Add or extend a datasets-owned audit that compares two local-cache manifest JSON files and reports whether they are equivalent after normalizing allowed root-specific fields.
- The comparison must preserve dataset ID, loader ID, split/config ID, required-file identity, file size/hash when available, provenance source, and unavailable-reason fields; absolute root paths may be normalized only when the underlying identities match.
- Include a mode that can generate synthetic fixture manifests so CI can test equivalence without private local caches.
- The audit must fail loud on missing hashes, duplicate dataset identities, path-only identity, mismatched provenance source, or a manifest that claims readiness without required files.
- Do not generate empirical filter evidence, modify caches, or commit local-machine paths as scientific evidence.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, the roadmap, or manuscript prose.
- Do not target `claim_55`; `claim_55` is protected and unrelated to this cache-root equivalence audit.
- Do not make unsupported SOTA, novelty, leaderboard, breakthrough, or verified-claim statements; any SOTA comparison requires a source ledger, stable URL or DOI, retrieval date, exact metric, dataset, split, and comparability table.

## Falsification gate

The task must fail if two manifests with different dataset/provenance identities compare equal, if two root-shifted but otherwise identical manifests compare unequal, if readiness is derived from an absolute path alone, or if missing file hashes are not surfaced as explicit gaps.

## Validation

Run and record:

- focused tests for root-shift equivalence, dataset mismatch, provenance mismatch, missing hash, duplicate identity, path-only identity rejection, and readiness-with-missing-file rejection;
- `uv run --locked --all-extras python scripts/audit_cache_root_equivalence.py --left tests/fixtures/cache_manifest/root_a.json --right tests/fixtures/cache_manifest/root_b.json`;
- if local Hinf cache manifests are available, run the audit on real manifests and mark any unavailable local cache as a gap rather than inferred readiness;
- `uv run --locked --all-extras pytest tests/test_cache_root_equivalence_audit.py -q`;
- `uv run --locked --all-extras pytest tests/ -m "not slow" -q`;
- `uv run --locked --all-extras ruff check .`;
- `uv run --locked --all-extras ruff format --check .`;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

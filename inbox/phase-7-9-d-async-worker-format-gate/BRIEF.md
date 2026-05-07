---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-async-codex
target_branch: phase-7-9-d-async-worker-format-gate
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/bsebench-runner
  - /mnt/c/doctorat/bsebench-org/bsebench-stats
  - /mnt/c/doctorat/bsebench-org/bsebench-datasets
hard_wallclock_min: 60
---

# Phase 7.9.d — worker format-gate hardening

You are a rigorous async infrastructure engineer. You are not alone in this codebase; do not revert or overwrite unrelated edits.

## Goal

Prevent a repeat of Phase 7.8 formatter drift where workers reported green validation while chef later found `ruff format --check` failures.

## Required behavior

- Update async worker prompts/docs/checkers so Python repo BRIEFs and worker summaries include `ruff format --check` when `ruff` is part of the repo's gates.
- Prefer a lightweight static checker over complex daemon behavior.
- Do not make the watchdog mutate repos.
- Do not edit the scientific roadmap.
- Do not edit thesis files, claim registry files, `claims/registry.yaml`, or roadmap files.
- Do not make SOTA claims without a source ledger, stable URL/DOI, and comparability table.

## Falsification gate

A Phase 7/8/11 Python BRIEF that asks for `ruff check` but omits `ruff format --check` should be detected or clearly flagged.

## Validation

Run and record:

- `bash -n` for changed shell scripts;
- checker dry-run on at least one Phase 7.8 BRIEF that includes format gates;
- checker negative test or documented manual negative probe;
- `git diff --check`.

Commit with GLASSBOX metadata. No `Co-Authored-By Claude`.

---
target_repo: /mnt/c/doctorat/bsebench-org/bsebench-datasets
target_branch: phase-6-10-a-calce-a123-adapter-skeleton-fix-1
base_branch: main
add_dir:
  - /mnt/c/doctorat/bsebench-org/_datasets
  - /mnt/c/doctorat/these_lfp_2026
hard_wallclock_min: 30
---

# Phase 6.10.a fix-1 — CalceA123Adapter skeleton (Tier 1, no parsing logic)

## Why this is fix-1

The original `phase-6-10-a-calce-a123-adapter-skeleton` (queued 2026-05-06 10:06 UTC) was processed by a worker tick that ran the OLD remote-worker.sh (without ERR trap) AND failed to push to GitHub due to a Windows GCM × WSL worktree-cwd bug. The phase fossilized in `status=running`, then was force-reset to `error` by the chef. Round-trip infrastructure has since been validated end-to-end via `phase-async-canary-fix-1` (commit `fe1af5d` pushed successfully).

Both fixes are now in effect on the worker :
1. ERR trap in `scripts/remote-worker.sh` (commit `609509f`).
2. `timeout --kill-after=30s` for SIGKILL escalation (commit `17c9464`).
3. `git-credential-manager-wsl` wrapper in `~/.local/bin/` (worker-side, fixed by user 2026-05-06 ~13:33 UTC).
4. Worker captures `git push` stderr in SUMMARY.md (uncommitted patch landing concurrently).

## Mission

First mini-step toward the CALCE A123 LFP loader family (paper2b's `load_calce_wrapper` + `load_calce_a123_dynamic_wrapper`). Per the granularity rule (CHEF.md §10), this dispatch ONLY sets up the adapter class skeleton + 5 fast smoke tests. NO CSV parsing, NO zip extraction, NO Tier 2 loader. Those come in 6.10.b, 6.10.c, etc.

Goal : ≤ 80 LOC of new code total. ≥ 1 fast test passing. 1 commit, conventional format.

## Workspace

Worktree provided by the worker at `<target_repo>-<target_branch>`. You operate in that worktree. Do NOT push — worker handles push.

## Pre-flight (per ADR 0014 §"Pre-flight checklist", abridged for this mini-dispatch)

1. **API signatures** : read `src/bsebench_datasets/adapters/_base.py` to confirm `BaseAdapter` contract (the abstract `harmonize` method, expected return type `dict[str, Path]`, init kwargs).
2. **Reference implementation** : read `src/bsebench_datasets/adapters/yao_tu_berlin_2024.py` end-to-end (last shipped Tier 1 adapter, ~250 LOC). You will mirror its STRUCTURE in this dispatch — class definition, init, type annotations — without yet copying its CSV-parsing logic (that's for 6.10.b).
3. **Source-of-truth** : paper2b's CALCE wrapper at `/mnt/c/doctorat/these_lfp_2026/ecm_fidelity_lfp/autoresearch/benchmark_grid_multi.py:97-111` (`load_calce_wrapper` for legacy A123 CSVs) AND `:466-585` (`load_calce_a123_dynamic_wrapper` for zip-based dynamic). You'll reference both in the docstring but not yet implement either.

## Deliverable

ONE new file : `src/bsebench_datasets/adapters/calce_a123_2014.py`

Content :

```python
"""CALCE A123 LFP — Tier 1 adapter (Phase 6.10.a skeleton).

Source : CALCE Battery Research Group, University of Maryland.
URL    : https://calce.umd.edu/battery-data
Cell   : A123 APR18650M1A, 1.1 Ah nominal, LFP chemistry.
License: free download, no DOI (per battery-datasets-catalog skill §1).

This adapter unifies two paper2b wrappers :
- load_calce_wrapper (legacy : DST-only on raw CSVs, 3 T : 0/25/40 °C)
- load_calce_a123_dynamic_wrapper (DST + US06 + FUDS on zip bundles, 8 T)

Phase 6.10.a status : SKELETON ONLY. Class definition + harmonize signature.
CSV parsing logic comes in 6.10.b. zip-bundle handling in 6.10.c.

Sign convention :
    CALCE convention is already paper2b-aligned : positive I = discharge in
    the raw CSV. In Tier 1 BPX 1.1 (charge-positive) we will FLIP during
    harmonize : write current_A = -raw_current. Empirical verification of
    the flip will be done in Phase 6.10.b on one canonical sample.

Cell ID forensic format (Tier 2 contract, mirrored here for reference) :
    legacy   -> A123_T{int(T_C)}     (e.g. A123_T25)
    dynamic  -> A123_DST_T{int(T_C)} or _US06_ or _FUDS_ (e.g. A123_FUDS_T25)
"""

from __future__ import annotations

from pathlib import Path

from bsebench_datasets.adapters._base import BaseAdapter

# CALCE A123 dynamic temperature set (paper2b benchmark_grid_multi.py:472-481)
CALCE_A123_DYN_TEMPS_C: tuple[int, ...] = (-10, 0, 10, 20, 25, 30, 40, 50)

# CALCE A123 dynamic profile set (paper2b benchmark_grid_multi.py:483)
CALCE_A123_DYN_PROFILES: tuple[str, ...] = ("DST", "US06", "FUDS")

# CALCE A123 legacy temperature set (paper2b benchmark_grid_multi.py:101)
CALCE_A123_LEGACY_TEMPS_C: tuple[int, ...] = (0, 25, 40)

# CALCE A123 legacy profile set (paper2b benchmark_grid_multi.py:99)
CALCE_A123_LEGACY_PROFILES: tuple[str, ...] = ("DST",)

# Nominal capacity (Ah) — A123 APR18650M1A datasheet
NOMINAL_CAPACITY_AH: float = 1.1

# Chemistry tag for Tier 2 dict / loader contract
CHEMISTRY_TAG: str = "LFP_A123_APR18650M1A"

# Dataset tag for Tier 2 dict / loader contract
DATASET_TAG: str = "calce_a123_lfp"


class CalceA123Adapter(BaseAdapter):
    """Skeleton for CALCE A123 LFP Tier 1 harmonizer.

    Full CSV parsing + zip extraction land in Phase 6.10.b and 6.10.c.
    For now : class definition + harmonize signature that raises
    NotImplementedError. The class is importable and has the expected
    metadata constants.

    Args :
        local_root : path to the CALCE raw data on the local PC.
                     Must contain the legacy CSVs (A123_*C.csv) AND/OR
                     the dynamic zip bundles (A123_DST-US06-FUDS-*.zip).
                     Caller-supplied (no Path(__file__).parents discovery).

    See `harmonize()` for the BPX 1.1 Parquet contract.
    """

    DATASET_NAME: str = DATASET_TAG
    CHEMISTRY: str = CHEMISTRY_TAG

    def __init__(self, local_root: Path | str) -> None:
        self.local_root = Path(local_root)

    def harmonize(self, output_dir: Path | str) -> dict[str, Path]:
        """Harmonize CALCE raw to BPX 1.1 Parquet (NOT YET IMPLEMENTED).

        Returns dict mapping cell_id -> Parquet path.

        Phase 6.10.a status : raises NotImplementedError. Logic
        comes in 6.10.b (legacy CSV) and 6.10.c (dynamic zips).
        """
        raise NotImplementedError(
            "CalceA123Adapter.harmonize is a Phase 6.10.a skeleton. "
            "Legacy CSV parsing arrives in 6.10.b. "
            "Dynamic zip handling arrives in 6.10.c."
        )
```

## Test deliverable

ONE new file : `tests/test_adapter_calce_a123_skeleton.py`

Content :

```python
"""Phase 6.10.a smoke test : CalceA123Adapter skeleton.

Verifies the class is importable, has expected constants, and harmonize
raises NotImplementedError as advertised. Real harmonize tests land in
6.10.b once CSV parsing is implemented.
"""

from pathlib import Path

import pytest

from bsebench_datasets.adapters.calce_a123_2014 import (
    CALCE_A123_DYN_PROFILES,
    CALCE_A123_DYN_TEMPS_C,
    CALCE_A123_LEGACY_PROFILES,
    CALCE_A123_LEGACY_TEMPS_C,
    CHEMISTRY_TAG,
    DATASET_TAG,
    NOMINAL_CAPACITY_AH,
    CalceA123Adapter,
)


def test_constants_match_paper2b_canonical() -> None:
    # Mirror paper2b benchmark_grid_multi.py:472-483
    assert CALCE_A123_DYN_TEMPS_C == (-10, 0, 10, 20, 25, 30, 40, 50)
    assert CALCE_A123_DYN_PROFILES == ("DST", "US06", "FUDS")
    # Mirror paper2b benchmark_grid_multi.py:99-101
    assert CALCE_A123_LEGACY_TEMPS_C == (0, 25, 40)
    assert CALCE_A123_LEGACY_PROFILES == ("DST",)
    # Datasheet values
    assert NOMINAL_CAPACITY_AH == 1.1
    assert CHEMISTRY_TAG == "LFP_A123_APR18650M1A"
    assert DATASET_TAG == "calce_a123_lfp"


def test_class_attributes() -> None:
    assert CalceA123Adapter.DATASET_NAME == DATASET_TAG
    assert CalceA123Adapter.CHEMISTRY == CHEMISTRY_TAG


def test_constructor_stores_local_root_as_path(tmp_path: Path) -> None:
    adapter = CalceA123Adapter(local_root=tmp_path)
    assert isinstance(adapter.local_root, Path)
    assert adapter.local_root == tmp_path


def test_constructor_accepts_str_path(tmp_path: Path) -> None:
    adapter = CalceA123Adapter(local_root=str(tmp_path))
    assert adapter.local_root == tmp_path


def test_harmonize_raises_not_implemented_in_skeleton(tmp_path: Path) -> None:
    adapter = CalceA123Adapter(local_root=tmp_path)
    with pytest.raises(NotImplementedError, match="Phase 6\\.10\\.a skeleton"):
        adapter.harmonize(output_dir=tmp_path)
```

## Acceptance gates

- **G1** : `uv run pytest tests/test_adapter_calce_a123_skeleton.py -v` → 5 passed.
- **G2** : `uv run ruff format --check src/bsebench_datasets/adapters/calce_a123_2014.py tests/test_adapter_calce_a123_skeleton.py` → exit 0.
- **G3** : `uv run ruff check src/ tests/` → exit 0 (no E/F errors anywhere).
- **G4** : `git status --porcelain` shows ONLY the 2 new files.
- **G5** : ONE commit on `phase-6-10-a-calce-a123-adapter-skeleton-fix-1` branch with conventional format `feat(adapters): add CalceA123Adapter skeleton (6.10.a)`. Body ≥ 5 lines explaining what's in scope and what's deferred to 6.10.b/c. Author = `Oussama Akir <claude@cosmocomply.com>`. NO `Co-Authored-By: Claude` trailer.

## DO NOT

- Implement CSV parsing in this dispatch (that's 6.10.b).
- Implement zip extraction (6.10.c).
- Add Tier 2 loader (6.10.d).
- Push (worker handles).
- Touch `bsebench-runner` or any other repo (only `bsebench-datasets`).
- Add `Co-Authored-By: Claude` trailer.

## Cross-references

- `docs/PROTOCOL.md` — async state machine.
- `docs/CHEF.md` §10 — granularity rule.
- `docs/codex-final-prompt.md` §3 — full convention contract (in your memory at `~/.codex/memories/bsebench-async-codex-context.md`).
- `bsebench-datasets@5792706` — Phase 6.9 Yao mirror (the reference implementation pattern).

# Phase phase-6-10-a-calce-a123-adapter-skeleton-fix-1 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-6-10-a-calce-a123-adapter-skeleton-fix-1
- Branch SHA : f397ca962cb09900a380eb2ef2a137264e0daea0
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T15:41:35+02:00

## Tail of codex stdout (last 200 lines)

```
+++ b/tests/test_adapter_calce_a123_skeleton.py
@@ -0,0 +1,56 @@
+"""Phase 6.10.a smoke test : CalceA123Adapter skeleton.
+
+Verifies the class is importable, has expected constants, and harmonize
+raises NotImplementedError as advertised. Real harmonize tests land in
+6.10.b once CSV parsing is implemented.
+"""
+
+from pathlib import Path
+
+import pytest
+
+from bsebench_datasets.adapters.calce_a123_2014 import (
+    CALCE_A123_DYN_PROFILES,
+    CALCE_A123_DYN_TEMPS_C,
+    CALCE_A123_LEGACY_PROFILES,
+    CALCE_A123_LEGACY_TEMPS_C,
+    CHEMISTRY_TAG,
+    DATASET_TAG,
+    NOMINAL_CAPACITY_AH,
+    CalceA123Adapter,
+)
+
+
+def test_constants_match_paper2b_canonical() -> None:
+    # Mirror paper2b benchmark_grid_multi.py:472-483
+    assert CALCE_A123_DYN_TEMPS_C == (-10, 0, 10, 20, 25, 30, 40, 50)
+    assert CALCE_A123_DYN_PROFILES == ("DST", "US06", "FUDS")
+    # Mirror paper2b benchmark_grid_multi.py:99-101
+    assert CALCE_A123_LEGACY_TEMPS_C == (0, 25, 40)
+    assert CALCE_A123_LEGACY_PROFILES == ("DST",)
+    # Datasheet values
+    assert NOMINAL_CAPACITY_AH == 1.1
+    assert CHEMISTRY_TAG == "LFP_A123_APR18650M1A"
+    assert DATASET_TAG == "calce_a123_lfp"
+
+
+def test_class_attributes() -> None:
+    assert CalceA123Adapter.DATASET_NAME == DATASET_TAG
+    assert CalceA123Adapter.CHEMISTRY == CHEMISTRY_TAG
+
+
+def test_constructor_stores_local_root_as_path(tmp_path: Path) -> None:
+    adapter = CalceA123Adapter(local_root=tmp_path)
+    assert isinstance(adapter.local_root, Path)
+    assert adapter.local_root == tmp_path
+
+
+def test_constructor_accepts_str_path(tmp_path: Path) -> None:
+    adapter = CalceA123Adapter(local_root=str(tmp_path))
+    assert adapter.local_root == tmp_path
+
+
+def test_harmonize_raises_not_implemented_in_skeleton(tmp_path: Path) -> None:
+    adapter = CalceA123Adapter(local_root=tmp_path)
+    with pytest.raises(NotImplementedError, match=r"Phase 6\.10\.a skeleton"):
+        adapter.harmonize(output_dir=tmp_path)

tokens used
63,124
Implemented and committed the Phase 6.10.a skeleton.

Files added:
- [calce_a123_2014.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-a-calce-a123-adapter-skeleton-fix-1/src/bsebench_datasets/adapters/calce_a123_2014.py:1)
- [test_adapter_calce_a123_skeleton.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-6-10-a-calce-a123-adapter-skeleton-fix-1/tests/test_adapter_calce_a123_skeleton.py:1)

One repo-specific note: `src/bsebench_datasets/adapters/_base.py` does not exist in this revision, so I added a tiny local compatibility fallback for `BaseAdapter` inside the new adapter file while keeping the change limited to the two requested files.

Verification passed:
- `uv run pytest tests/test_adapter_calce_a123_skeleton.py -v` → 5 passed
- `uv run ruff format --check ...` → passed
- `uv run ruff check src/ tests/` → passed
- Pre-commit status showed only the 2 new files
- Final `git status --porcelain` is clean

Commit:
- `f397ca9 feat(adapters): add CalceA123Adapter skeleton (6.10.a)`
- Author: `Oussama Akir <claude@cosmocomply.com>`
- No push performed.
```

## Next step for chef

git fetch origin && git checkout phase-6-10-a-calce-a123-adapter-skeleton-fix-1 in target_repo. Verify gates. Merge to main if green.

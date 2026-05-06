# Phase phase-7-1-bsebench-readme-examples summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 30 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-datasets
- Target branch : phase-7-1-bsebench-readme-examples
- Branch SHA : b2dec374b80a7652c9be427e3a92ee84b33f39e5
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T22:53:36+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+
+def _stats(values: np.ndarray) -> str:
+    return (
+        f"min={np.nanmin(values):.3f}, mean={np.nanmean(values):.3f}, max={np.nanmax(values):.3f}"
+    )
+
+
+def main() -> None:
+    trace = PanasonicKollmeyerLoader().load("US06", 25.0)
+    time_s = trace["t"]
+    voltage_v = trace["V"]
+    current_a = trace["I"]
+
+    print(f"dataset=Panasonic Kollmeyer 2018 cell_id={trace['cell_id']} samples={trace['N']}")
+    print(f"t shape={time_s.shape}, {_stats(time_s)} s")
+    print(f"V shape={voltage_v.shape}, {_stats(voltage_v)} V")
+    print(f"I shape={current_a.shape}, {_stats(current_a)} A discharge-positive")
+
+
+if __name__ == "__main__":
+    main()
diff --git a/examples/03_load_yao_bcdc.py b/examples/03_load_yao_bcdc.py
new file mode 100755
index 0000000000000000000000000000000000000000..39527d88653900f292ec0fa5d8ab996a1e5d3f0f
--- /dev/null
+++ b/examples/03_load_yao_bcdc.py
@@ -0,0 +1,27 @@
+from __future__ import annotations
+
+import numpy as np
+
+from bsebench_datasets.loaders.yao_tu_berlin_2024_loader import YaoTuBerlin2024Loader
+
+
+def _stats(values: np.ndarray) -> str:
+    return (
+        f"min={np.nanmin(values):.3f}, mean={np.nanmean(values):.3f}, max={np.nanmax(values):.3f}"
+    )
+
+
+def main() -> None:
+    trace = YaoTuBerlin2024Loader().load("BCDC", 25.0)
+    time_s = trace["t"]
+    voltage_v = trace["V"]
+    current_a = trace["I"]
+
+    print(f"dataset=Yao TU Berlin 2024 cell_id={trace['cell_id']} samples={trace['N']}")
+    print(f"t shape={time_s.shape}, {_stats(time_s)} s")
+    print(f"V shape={voltage_v.shape}, {_stats(voltage_v)} V")
+    print(f"I shape={current_a.shape}, {_stats(current_a)} A discharge-positive")
+
+
+if __name__ == "__main__":
+    main()

tokens used
143,806
Done in `phase-7-1-bsebench-readme-examples`.

Commit: `b2dec374b80a7652c9be427e3a92ee84b33f39e5`  
Scope: 4 files only:
- [README.md](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-1-bsebench-readme-examples/README.md)
- [examples/01_load_nasa_pcoe_2007.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-1-bsebench-readme-examples/examples/01_load_nasa_pcoe_2007.py)
- [examples/02_load_panasonic_us06.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-1-bsebench-readme-examples/examples/02_load_panasonic_us06.py)
- [examples/03_load_yao_bcdc.py](/mnt/c/doctorat/bsebench-org/bsebench-datasets-phase-7-1-bsebench-readme-examples/examples/03_load_yao_bcdc.py)

Verification:
- `uv run --extra dev ruff format --check ...` passed
- `uv run --extra dev ruff check ...` passed
- `uv run --all-extras pytest -m "not slow"` passed: `203 passed, 28 deselected`
- `git status` clean, branch ahead by 1 commit
- No `Co-Authored-By: Claude` trailer

Caveat: I smoke-ran the three examples, but Hugging Face returned `401 Unauthorized` for the NASA, Panasonic, and Yao Tier 2 dataset repos. The scripts use the shipped loaders correctly; they will execute once the mirrors are public or an HF token with access is present.

Style references checked: PyBaMM README and BatteryML README/dataprepare:
- https://github.com/pybamm-team/PyBaMM
- https://github.com/microsoft/BatteryML
- https://github.com/microsoft/BatteryML/blob/main/dataprepare.md
```

## Next step for chef

git fetch origin && git checkout phase-7-1-bsebench-readme-examples in target_repo. Verify gates. Merge to main if green.

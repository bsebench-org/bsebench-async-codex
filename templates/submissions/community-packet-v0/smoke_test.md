# Smoke Test Command

Packet: `replace_with_submission_id`

Run from a clean `bsebench-runner` checkout with the submitted packet available
on disk.

```bash
export BSEBENCH_SUBMISSION_MODULE=/absolute/path/to/packet/estimator_adapter.py
export BSEBENCH_SUBMISSION_SPLIT=/absolute/path/to/packet/smoke_split.yaml
export BSEBENCH_N_MAX=16

uv run --extra dev python - <<'PY'
import importlib.util
import os
from pathlib import Path

import numpy as np
from bsebench_datasets.splits import load_split
from bsebench_runner.orchestrator import run_benchmark

module_path = Path(os.environ["BSEBENCH_SUBMISSION_MODULE"])
split_path = Path(os.environ["BSEBENCH_SUBMISSION_SPLIT"])
n_max = int(os.environ.get("BSEBENCH_N_MAX", "16"))

spec = importlib.util.spec_from_file_location("bsebench_submission", module_path)
assert spec is not None
assert spec.loader is not None
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

split = load_split(split_path)
kwargs = {
    "split": split,
    "filter_registry": module.build_filter_registry(),
    "n_max": n_max,
    "runner_version": "community-packet-v0-smoke",
}
if hasattr(module, "build_adapter_registry"):
    kwargs["adapter_registry"] = module.build_adapter_registry()

result = run_benchmark(**kwargs)
rmse = np.asarray(result.rmse_matrix, dtype=float)
if rmse.size == 0 or not np.all(np.isfinite(rmse)):
    raise SystemExit("smoke failed: empty or non-finite RMSE matrix")
print(
    "smoke_status=pass "
    f"split_id={result.metadata.split_id} "
    f"filters={len(result.filter_names)} "
    f"configs={len(result.config_labels)}"
)
PY
```

## Required Smoke Log

| Field | Value |
| --- | --- |
| Runner repo | `unknown` |
| Runner commit SHA | `unknown` |
| Command status | `not_run` |
| Output summary | `unknown` |
| Maintainer rerun status | `not_run` |

If the command cannot run, record the exact blocker and keep intake blocked.

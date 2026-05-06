# Phase phase-6-11-a-chi2-smoke-yao-bcdc-t25 summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-6-11-a-chi2-smoke-yao-bcdc-t25
- Branch SHA : 3e19e2bfbda6b0696d1bd7f20f3c7855d3bf27b2
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-06T22:44:31+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+            "V": voltage,
+            "I": np.full(self.n_samples, 0.5, dtype=float),
+            "T_meas": np.full(self.n_samples, t_c, dtype=float),
+            "N": self.n_samples,
+            "chemistry": "SYNTHETIC",
+        }
+
+
+class _BiasFilter:
+    def __init__(self, bias_v: float) -> None:
+        self.bias_v = bias_v
+
+    def step(
+        self,
+        t: float,
+        voltage_V: float,
+        current_A: float,
+        temperature_C: float,
+    ) -> dict[str, float]:
+        del t, current_A, temperature_C
+        return {
+            "soc_estimated": 0.5,
+            "voltage_predicted": float(voltage_V) + self.bias_v,
+        }
+
+
+@pytest.mark.slow
+def test_run_smoke_end_to_end_on_synthetic_data(smoke_module, tmp_path: Path) -> None:
+    n_samples = 32
+    warmup = 4
+    output_path = tmp_path / "chi2_smoke.json"
+    biases = {"EnsembleMeta": 0.001, "EKF": -0.002}
+
+    payload = smoke_module.run_smoke(
+        loader_factory=lambda _: _SyntheticLoader(n_samples=n_samples),
+        filter_factories={
+            name: (lambda bias=bias: _BiasFilter(bias)) for name, bias in biases.items()
+        },
+        output_path=output_path,
+        n_max=n_samples,
+        warmup_samples=warmup,
+    )
+
+    assert output_path.is_file()
+    assert payload["config"]["loaded_samples"] == n_samples
+    assert payload["primary_filter"] == "EnsembleMeta"
+    assert set(payload["filters"]) == {"EnsembleMeta", "EKF"}
+
+    sigma_v = payload["sensor_noise"]["sigma_V"]
+    df = n_samples - warmup
+    for name, bias in biases.items():
+        expected_chi2 = df * (bias / sigma_v) ** 2
+        result = payload["filters"][name]
+        assert result["df"] == df
+        assert result["chi2"] == pytest.approx(expected_chi2, rel=1e-12)
+        assert 0.0 <= result["p_value"] <= 1.0

tokens used
228,616
Implemented and committed: `3e19e2b feat(smoke): add Yao BCDC T25 chi2 smoke`.

Files:
- [script](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-a-chi2-smoke-yao-bcdc-t25/scripts/chi2_smoke_yao_bcdc_t25.py)
- [tests](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-a-chi2-smoke-yao-bcdc-t25/tests/test_chi2_smoke_yao_bcdc_t25.py)
- [output JSON](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-11-a-chi2-smoke-yao-bcdc-t25/outputs/chi2_smoke_yao_bcdc_t25.json)

Real Yao BCDC T25 result, 3000 samples, 100 warmup, sigma via paper2b MAD voltage-difference estimator:
- `EnsembleMeta`: chi2 `121929051.31408338`, df `2900`, p `0.0`, RMSE `0.6180959013743591 mV`
- `EKF`: chi2 `24014340685.70337`, df `2900`, p `0.0`, RMSE `8.67436315749092 mV`

The commit body documents that paper2b `157.636` is the Audit J Friedman chi-square over `10 filters x 26 configs`, so it is recorded but not directly comparable to this residual time-series chi-square.

Verification:
- `uv run pytest tests/test_chi2_smoke_yao_bcdc_t25.py -v` passed
- `uv run ruff format --check scripts/chi2_smoke_yao_bcdc_t25.py tests/test_chi2_smoke_yao_bcdc_t25.py` passed
- `uv run ruff check scripts/chi2_smoke_yao_bcdc_t25.py tests/test_chi2_smoke_yao_bcdc_t25.py` passed
- `uv run ruff check .` passed
- `git status --porcelain` clean

Note: whole-repo `uv run ruff format --check .` reports an existing unrelated formatting issue in `tests/test_audit_j_smoke.py`; I left it untouched to keep scope to the 3 requested files. Dataset source used: [DepositOnce Yao drive-cycle dataset](https://depositonce.tu-berlin.de/items/7f68932b-4d43-4f49-a5d8-914b00039f87).
```

## Next step for chef

git fetch origin && git checkout phase-6-11-a-chi2-smoke-yao-bcdc-t25 in target_repo. Verify gates. Merge to main if green.

# Phase phase-13-04-stats-bootstrap-uncertainty-20260509T134830Z direct-worker summary

- Direct pid: `3038023`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-stats`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-stats-glassbox-phase13-04-stats-bootstrap-uncertainty-20260509T134830Z`
- Target branch: `glassbox-phase13-04-stats-bootstrap-uncertainty-20260509T134830Z`
- Branch SHA: `800292cc43c0399c5c6986f3c321149aaafc5068`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:07:52.166566Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+    assert [(row["candidate"], row["metric"]) for row in report["groups"]] == [
+        ("EstimatorA", "soc_rmse"),
+        ("EstimatorA", "soh_mae"),
+    ]
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize(
+    ("mutate", "message"),
+    [
+        (lambda record: record.pop("evidence"), r"evidence"),
+        (lambda record: record.pop("provenance"), r"provenance"),
+        (lambda record: record["axes"].pop("split"), r"split"),
+        (
+            lambda record: (
+                record["evidence"].pop("sha256"),
+                record["provenance"].pop("source_sha256"),
+            ),
+            r"hashes",
+        ),
+        (lambda record: record.update({"value": float("nan")}), r"finite metric value"),
+        (lambda record: record.update({"value": True}), r"finite metric value"),
+    ],
+)
+def test_missing_evidence_hashes_splits_provenance_or_finite_metrics_fail_closed(
+    mutate,
+    message: str,
+) -> None:
+    records = [
+        _record("EstimatorA", 0.10, split="fold-1"),
+        _record("EstimatorA", 0.20, split="fold-2"),
+    ]
+    mutate(records[0])
+
+    with pytest.raises(BootstrapUncertaintyError, match=message):
+        build_bootstrap_uncertainty_report(records, n_resamples=8, seed=1)
+
+
+@pytest.mark.fast
+@pytest.mark.parametrize(
+    ("kwargs", "message"),
+    [
+        ({"n_resamples": 1}, r"n_resamples"),
+        ({"seed": -1}, r"seed"),
+        ({"confidence_level": 1.0}, r"confidence_level"),
+        ({"statistic": "trimmed_mean"}, r"statistic"),
+    ],
+)
+def test_bootstrap_options_fail_closed(kwargs: dict[str, object], message: str) -> None:
+    with pytest.raises(BootstrapUncertaintyError, match=message):
+        bootstrap_metric_summary([1.0, 2.0], **kwargs)
+
+
+@pytest.mark.fast
+def test_bootstrap_metric_summary_rejects_non_finite_arrays_and_short_samples() -> None:
+    with pytest.raises(BootstrapUncertaintyError, match="finite"):
+        bootstrap_metric_summary([1.0, np.inf])
+
+    with pytest.raises(BootstrapUncertaintyError, match="numeric"):
+        bootstrap_metric_summary([1.0, True])
+
+    with pytest.raises(BootstrapUncertaintyError, match="at least 2"):
+        bootstrap_metric_summary([1.0])

tokens used
125,983
Implemented and pushed commit `800292c` to `glassbox-phase13-04-stats-bootstrap-uncertainty-20260509T134830Z`.

Changes:
- Added `phase13_bootstrap_uncertainty.py` with deterministic bootstrap resampling, metric summaries, record-level guarded reports, reproducible seeds, finite guards, and evidence/hash/split/provenance fail-closed validation.
- Added focused tests for determinism, finite JSON outputs, grouped summaries, metrics-map expansion, and failure modes.
- Minimally exported the new helpers from `bsebench_stats.__init__`.

Validation run:
- `uv run --extra dev pytest -q tests/test_phase13_bootstrap_uncertainty.py` passed: 15 tests.
- `git diff --check` passed.
- `uv run --extra dev ruff check src tests` passed.
- `uv run --extra dev mypy src/bsebench_stats/phase13_bootstrap_uncertainty.py` passed.

Full pytest was skipped; the broader cheap project check was the full ruff pass.
```

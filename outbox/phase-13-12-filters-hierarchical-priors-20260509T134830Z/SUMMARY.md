# Phase phase-13-12-filters-hierarchical-priors-20260509T134830Z direct-worker summary

- Direct pid: `3040667`
- Target repo: `/mnt/c/doctorat/bsebench-org/bsebench-filters`
- Worktree: `/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-12-filters-hierarchical-priors-20260509T134830Z`
- Target branch: `glassbox-phase13-12-filters-hierarchical-priors-20260509T134830Z`
- Branch SHA: `78eb2c239e098618a184846f2b346bfcc5efa504`
- Has diff vs `origin/main`: `true`
- Push result: `ok`
- Final status: `done`
- Finished: `2026-05-09T14:06:20.284361Z`

## Push stderr

```text
Everything up-to-date
```

## Log tail

```text
+            "claim_status must remain NO_GO_CLAIM",
+        ),
+    ],
+)
+def test_hierarchical_prior_validation_fails_closed_for_missing_or_unsafe_metadata(
+    mutation,
+    message: str,
+) -> None:
+    manifest = _valid_manifest()
+    mutation(manifest)
+
+    with pytest.raises(HierarchicalPriorValidationError, match=message):
+        validate_phase13_hierarchical_prior_manifest(manifest)
+    assert hierarchical_prior_blocking_gaps(manifest)
+
+
+@pytest.mark.parametrize(
+    ("mutation", "message"),
+    [
+        (
+            lambda prior: prior.update({"levels": prior["levels"][:1]}),
+            "levels must contain at least 2 levels",
+        ),
+        (
+            lambda prior: prior["ensemble_members"][1].update(
+                {"member_id": prior["ensemble_members"][0]["member_id"]}
+            ),
+            r"ensemble_members\[1\]\.member_id must be unique",
+        ),
+        (
+            lambda prior: prior["levels"][0]["distribution"]["parameters"].update(
+                {"scale": float("inf")}
+            ),
+            r"distribution\.parameters\.scale must be a finite number",
+        ),
+    ],
+)
+def test_hierarchical_prior_spec_validation_rejects_ambiguous_or_nonfinite_priors(
+    mutation,
+    message: str,
+) -> None:
+    prior = default_hierarchical_prior_spec()
+    mutation(prior)
+    manifest = build_phase13_hierarchical_prior_manifest(
+        prior_spec=prior,
+        evidence=_evidence(),
+        diagnostic_metrics={"calibration_log_likelihood": -1.0},
+        phase12_gate=_phase12_gate(),
+    )
+
+    with pytest.raises(HierarchicalPriorValidationError, match=message):
+        validate_phase13_hierarchical_prior_manifest(manifest)
+
+
+def test_hierarchical_prior_manifest_rejects_execution_or_transfer_flags() -> None:
+    manifest = deepcopy(_valid_manifest())
+    manifest["execution_policy"]["estimator_execution_allowed"] = True
+
+    with pytest.raises(
+        HierarchicalPriorValidationError,
+        match=r"execution_policy\.estimator_execution_allowed must remain false",
+    ):
+        validate_phase13_hierarchical_prior_manifest(manifest)

tokens used
106,568
Implemented and pushed `78eb2c2 GLASSBOX [role: phase13-filters-hierarchical] add hierarchical prior metadata gates` to `glassbox-phase13-12-filters-hierarchical-priors-20260509T134830Z`.

Added:
- [phase13_hierarchical_priors.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-12-filters-hierarchical-priors-20260509T134830Z/src/bsebench_filters/phase13_hierarchical_priors.py): metadata-only manifest builder, validator, fail-closed blocking gaps, Phase 12 gate checks, finite diagnostic metric checks, provenance/hash/split validation, and explicit no-execution/no-claim policy.
- [test_phase13_hierarchical_priors.py](/mnt/c/doctorat/bsebench-org/bsebench-filters-glassbox-phase13-12-filters-hierarchical-priors-20260509T134830Z/tests/test_phase13_hierarchical_priors.py): focused coverage for valid metadata and missing evidence, bad hashes/splits/provenance, non-finite metrics, unsafe claims, and execution flags.

Validation:
- `UV_LINK_MODE=copy uv run --extra dev pytest tests/test_phase13_hierarchical_priors.py -q` passed: 12 passed.
- `git diff --check` passed.
- `UV_LINK_MODE=copy uv run --extra dev ruff check ...` passed.
- `UV_LINK_MODE=copy uv run --extra dev ruff format --check ...` passed.
- `python -m py_compile ...` passed.

Skipped full repo pytest because the requested targeted validation passed and the broader suite was not a cheap check in the current concurrent Phase 13 workspace.
```

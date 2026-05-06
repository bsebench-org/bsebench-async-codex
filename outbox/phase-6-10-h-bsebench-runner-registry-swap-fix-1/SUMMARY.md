# Phase phase-6-10-h-bsebench-runner-registry-swap-fix-1 summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 45 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-6-10-h-bsebench-runner-registry-swap-fix-1
- Branch SHA : 34acb8b9d8ca2fbce8ea99cd31984e43403b4f88
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T00:54:12+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+
+CONCRETE_LOADER_MODULES = (
+    "bsebench_datasets.loaders.calce_a123_dyn_loader",
+    "bsebench_datasets.loaders.calce_a123_legacy_loader",
+    "bsebench_datasets.loaders.calce_inr_20r_loader",
+    "bsebench_datasets.loaders.lg_hg2_stroebl_2024_loader",
+    "bsebench_datasets.loaders.nasa_pcoe_loader",
+    "bsebench_datasets.loaders.nasa_rw_loader",
+    "bsebench_datasets.loaders.panasonic_kollmeyer_loader",
+    "bsebench_datasets.loaders.yao_tu_berlin_2024_loader",
 )
 
 
@@ -58,11 +80,33 @@
         assert callable(adapter_loader)
 
 
-def test_stub_wrappers_raise_adapter_not_available(registry: AdapterRegistry) -> None:
-    for wrapper in STUB_WRAPPERS:
-        loader = registry.get(wrapper)()
-        with pytest.raises(AdapterNotAvailableError):
-            loader("any_profile", 25.0)
+def test_default_adapter_module_does_not_import_concrete_loader_modules() -> None:
+    import bsebench_runner.default_adapters as default_adapters
+
+    for module_name in CONCRETE_LOADER_MODULES:
+        sys.modules.pop(module_name, None)
+
+    importlib.reload(default_adapters)
+
+    imported = sorted(
+        module_name for module_name in CONCRETE_LOADER_MODULES if module_name in sys.modules
+    )
+    assert imported == []
+
+
+@pytest.mark.parametrize(
+    ("wrapper", "loader_class_name"),
+    sorted(EXPECTED_DEFAULT_LOADER_CLASS_NAMES.items()),
+)
+def test_default_factories_instantiate_real_loaders(
+    registry: AdapterRegistry,
+    wrapper: str,
+    loader_class_name: str,
+) -> None:
+    loader_method = registry.get(wrapper)()
+    loader = loader_method.__self__
+    assert loader.__class__.__name__ == loader_class_name
+    assert not isinstance(loader, StubLoader)
 
 
 def test_nasa_wrapper_returns_a_callable_without_fetching(registry: AdapterRegistry) -> None:
@@ -95,7 +139,9 @@
 
 @pytest.mark.slow
 def test_nasa_adapter_loads_real_data_from_hf_hub(registry: AdapterRegistry) -> None:
-    """Network-bound integration test against ``bsebench-org/nasa-rw-2014``."""
+    """Network-bound integration test against the default NASA PCoE mirror."""
+    if not os.environ.get("BSEBENCH_RUN_HF_SLOW"):
+        pytest.skip("BSEBENCH_RUN_HF_SLOW not set")
     nasa_loader = registry.get("nasa")()
     data = nasa_loader("CC-discharge", 24.0)
     assert {"t", "V", "I"}.issubset(data.keys())

tokens used
194,762
Implemented and committed.

Commit: `34acb8b feat(adapters): swap default stubs to Tier 2 loaders [role: worker-codex-FR]`

Changed [default_adapters.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-10-h-bsebench-runner-registry-swap-fix-1/src/bsebench_runner/default_adapters.py:63) so all seven Audit J adapter keys instantiate real Tier 2 loaders via lazy factory-local imports. NASA remains `NasaPcoeLoader`. `uv.lock` now pins `bsebench-datasets` to `1dd4624`, the commit containing the needed loaders.

Added focused coverage in [test_default_adapters.py](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-6-10-h-bsebench-runner-registry-swap-fix-1/tests/test_default_adapters.py:36) for all seven real loader classes and lazy module import behavior. Updated the CLI test to inject stubs explicitly for its sentinel-path test.

Verification passed:

- `uv run pytest tests/test_default_adapters.py tests/test_default_registries.py -v` → 26 passed, 2 skipped
- `uv run pytest -m "not slow" --tb=short` → 55 passed, 5 deselected
- `uv run ruff format --check .` → passed
- `uv run ruff check .` → passed
```

## Next step for chef

git fetch origin && git checkout phase-6-10-h-bsebench-runner-registry-swap-fix-1 in target_repo. Verify gates. Merge to main if green.

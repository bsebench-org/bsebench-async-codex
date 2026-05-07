# Phase phase-7-8-e-runner-ci-hinf-audit-step summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 45 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-runner
- Target branch : phase-7-8-e-runner-ci-hinf-audit-step
- Branch SHA : 96772d01b18ca73181033ff71381c1c05b2db9d4
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T08:36:34+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
- ruff check: OK
- ruff format check: OK
- `git diff --check`: OK

Commit: `96772d01b18ca73181033ff71381c1c05b2db9d4`  
No `Co-Authored-By Claude` trailer.
diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index db0257c3dabdf9dbffef1f34ab9949f12b8d2ea0..c93752c4a248bee9b62adf6bbd91b1a24736ac29
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -25,11 +25,34 @@
         run: pip install uv
 
       - name: Install dependencies
-        run: uv sync --all-extras
+        run: uv sync --locked --all-extras
 
       - name: Run tests
-        run: uv run pytest tests/ -v -m "not slow" --cov=bsebench_runner --cov-report=term-missing
+        run: uv run --locked --all-extras pytest tests/ -v -m "not slow" --cov=bsebench_runner --cov-report=term-missing
 
+  strict-hinf-audit:
+    name: Strict Hinf audit
+    runs-on: ubuntu-latest
+    steps:
+      - uses: actions/checkout@v4
+
+      - name: Set up Python
+        uses: actions/setup-python@v5
+        with:
+          python-version: "3.12"
+
+      - name: Install uv
+        run: pip install uv
+
+      - name: Install dependencies
+        run: uv sync --locked --all-extras
+
+      - name: Audit strict Hinf residual outputs
+        run: uv run --locked --all-extras python scripts/audit_hinf_residual_outputs.py
+
+      - name: Audit strict Hinf residual manifest
+        run: uv run --locked --all-extras python scripts/audit_hinf_residual_manifest.py
+
   lint:
     name: Lint
     runs-on: ubuntu-latest
@@ -39,6 +62,6 @@
         with:
           python-version: "3.12"
       - run: pip install uv
-      - run: uv sync --all-extras
-      - run: uv run ruff check .
-      - run: uv run ruff format --check .
+      - run: uv sync --locked --all-extras
+      - run: uv run --locked --all-extras ruff check .
+      - run: uv run --locked --all-extras ruff format --check .

tokens used
67,791
Implemented and committed in the phase 7.8.e worktree.

Changed [ci.yml](/mnt/c/doctorat/bsebench-org/bsebench-runner-phase-7-8-e-runner-ci-hinf-audit-step/.github/workflows/ci.yml:33) to add a standalone `Strict Hinf audit` CI job that runs:

- `scripts/audit_hinf_residual_outputs.py`
- `scripts/audit_hinf_residual_manifest.py`

Both use `uv run --locked --all-extras`. Existing test/lint CI commands now also use the committed lockfile explicitly.

Validation passed:

- output audit: OK
- manifest audit: OK
- pytest: `108 passed, 5 deselected`
- ruff check: OK
- ruff format check: OK
- `git diff --check`: OK

Commit: `96772d01b18ca73181033ff71381c1c05b2db9d4`  
No `Co-Authored-By Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-7-8-e-runner-ci-hinf-audit-step in target_repo. Verify gates. Merge to main if green.

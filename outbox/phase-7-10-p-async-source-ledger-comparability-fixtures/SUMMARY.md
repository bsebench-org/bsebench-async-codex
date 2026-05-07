# Phase phase-7-10-p-async-source-ledger-comparability-fixtures summary

- Worker : france-personal
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-p-async-source-ledger-comparability-fixtures
- Branch SHA : 91a0649c72eaf89d8c7d9b75322a6cc3c79b6e4a
- Push result : ok
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-07T20:51:19+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+        "split": "synthetic fixed test split A",
+        "method": "SyntheticComparableMethod",
+        "reported_value": "1.230 synthetic units (fixture only, not literature evidence)",
+        "bsebench_frozen_value": "1.230 synthetic units from frozen fixture artifact",
+        "comparability": "comparable",
+        "comparability_caveat": "none; synthetic fixture uses the same metric, dataset, split, and method basis"
+      }
+    ]
+  }
+}
diff --git a/tests/fixtures/source-ledger-comparability/pass-not-comparable.json b/tests/fixtures/source-ledger-comparability/pass-not-comparable.json
new file mode 100755
index 0000000000000000000000000000000000000000..bf1260472ab15dcce6bb79ae6539c019d78d5913
--- /dev/null
+++ b/tests/fixtures/source-ledger-comparability/pass-not-comparable.json
@@ -0,0 +1,22 @@
+{
+  "source_ledger": {
+    "schema_version": "source-ledger-comparability/v1",
+    "ledger_status": "synthetic_positive_fixture",
+    "entries": [
+      {
+        "source_id": "synthetic-not-comparable-001",
+        "title": "Synthetic Not Comparable Source Row",
+        "stable_url_or_doi": "https://example.org/bsebench/synthetic-source-ledger/not-comparable-001",
+        "retrieval_date": "2026-05-07",
+        "metric": "synthetic MAE percent",
+        "dataset": "SyntheticOtherCellSet v0 fixed profile",
+        "split": "synthetic source-only test split C",
+        "method": "SyntheticDifferentMethod",
+        "reported_value": "3.210 synthetic units (fixture only, not literature evidence)",
+        "bsebench_frozen_value": "1.230 synthetic units from frozen fixture artifact",
+        "comparability": "not_comparable",
+        "comparability_caveat": "synthetic caveat: source row uses a different metric, dataset, split, and method basis"
+      }
+    ]
+  }
+}
diff --git a/tests/fixtures/source-ledger-comparability/pass-partial.json b/tests/fixtures/source-ledger-comparability/pass-partial.json
new file mode 100755
index 0000000000000000000000000000000000000000..c530d4e0e49b9b81014ea92523d325a3b5b8a671
--- /dev/null
+++ b/tests/fixtures/source-ledger-comparability/pass-partial.json
@@ -0,0 +1,22 @@
+{
+  "source_ledger": {
+    "schema_version": "source-ledger-comparability/v1",
+    "ledger_status": "synthetic_positive_fixture",
+    "entries": [
+      {
+        "source_id": "synthetic-partial-001",
+        "title": "Synthetic Partial Source Row",
+        "stable_url_or_doi": "https://example.org/bsebench/synthetic-source-ledger/partial-001",
+        "retrieval_date": "2026-05-07",
+        "metric": "synthetic RMSE percent",
+        "dataset": "SyntheticCellSet v0 fixed profile",
+        "split": "synthetic alternate validation horizon B",
+        "method": "SyntheticComparableMethod",
+        "reported_value": "2.340 synthetic units (fixture only, not literature evidence)",
+        "bsebench_frozen_value": "2.100 synthetic units from frozen fixture artifact",
+        "comparability": "partial",
+        "comparability_caveat": "synthetic caveat: source row shares metric and dataset but uses a different validation horizon"
+      }
+    ]
+  }
+}

tokens used
149,670
Implemented and pushed commit `91a0649` to `origin/phase-7-10-p-async-source-ledger-comparability-fixtures`.

Added [check-source-ledger-comparability.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-p-async-source-ledger-comparability-fixtures/scripts/check-source-ledger-comparability.sh:1), fixture probes in [test-source-ledger-comparability.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-p-async-source-ledger-comparability-fixtures/scripts/test-source-ledger-comparability.sh:1), and synthetic comparable/partial/not-comparable/missing-field fixtures under `tests/fixtures/source-ledger-comparability/`. Updated the research gate protocol’s source-ledger field set at [docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-p-async-source-ledger-comparability-fixtures/docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md:129).

Validation passed:
- `bash scripts/test-source-ledger-comparability.sh`
- `bash -n scripts/check-source-ledger-comparability.sh scripts/test-source-ledger-comparability.sh`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` (`16 checked`)
- `git diff --check`

No thesis, claim registry, `claims/registry.yaml`, `claim_55`, or roadmap files were edited. Commit has no `Co-Authored-By Claude` trailer.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-p-async-source-ledger-comparability-fixtures in target_repo. Verify gates. Merge to main if green.

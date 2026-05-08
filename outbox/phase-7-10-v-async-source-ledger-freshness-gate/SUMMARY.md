# Phase phase-7-10-v-async-source-ledger-freshness-gate summary

- Worker : france-personal-2
- Codex exit : 0
- Wallclock cap : 60 min
- Target repo : /mnt/c/doctorat/bsebench-org/bsebench-async-codex
- Target branch : phase-7-10-v-async-source-ledger-freshness-gate
- Branch SHA : befd8974fd11ed90a06e9e0d3572b0d32bf61b0b
- Push result : ok
- Merge readiness : stale-base
- Merge readiness detail : origin/main is not an ancestor of HEAD; rebase before chef merge
- Started : (see STATUS.json ts_started)
- Finished : 2026-05-08T16:33:28+02:00

## Push stderr (if push failed)

(push succeeded — no stderr)

## Tail of codex stdout (last 200 lines)

```
+    ]
+  }
+}
diff --git a/tests/fixtures/source-ledger-freshness/pass-not-comparable.json b/tests/fixtures/source-ledger-freshness/pass-not-comparable.json
new file mode 100755
index 0000000000000000000000000000000000000000..71ce89425bdb309853bfe7083237465d840b3ce7
--- /dev/null
+++ b/tests/fixtures/source-ledger-freshness/pass-not-comparable.json
@@ -0,0 +1,23 @@
+{
+  "source_ledger": {
+    "schema_version": "source-ledger-freshness/v1",
+    "ledger_status": "synthetic_positive_fixture",
+    "entries": [
+      {
+        "source_id": "synthetic-not-comparable-001",
+        "title": "Synthetic Not Comparable Source Row",
+        "stable_url_or_doi": "10.1234/bsebench.synthetic.not-comparable",
+        "retrieval_date": "2026-05-07",
+        "metric": "synthetic MAE percent",
+        "dataset": "SyntheticOtherCellSet v0 fixed profile",
+        "split": "synthetic source-only test split C",
+        "run_condition": "synthetic private profile C with unshared preprocessing",
+        "method": "SyntheticDifferentMethod",
+        "reported_value": "3.210 synthetic units (fixture only, not literature evidence)",
+        "bsebench_frozen_value": "1.230 synthetic units from frozen fixture artifact",
+        "comparability": "not-comparable",
+        "comparability_caveat": "synthetic caveat: source row uses a different metric, dataset, split, preprocessing, and method basis"
+      }
+    ]
+  }
+}
diff --git a/tests/fixtures/source-ledger-freshness/pass-partial.json b/tests/fixtures/source-ledger-freshness/pass-partial.json
new file mode 100755
index 0000000000000000000000000000000000000000..559fbce6bcd3c02947b7beceee4d20194b81b063
--- /dev/null
+++ b/tests/fixtures/source-ledger-freshness/pass-partial.json
@@ -0,0 +1,23 @@
+{
+  "source_ledger": {
+    "schema_version": "source-ledger-freshness/v1",
+    "ledger_status": "synthetic_positive_fixture",
+    "entries": [
+      {
+        "source_id": "synthetic-partial-001",
+        "title": "Synthetic Partial Source Row",
+        "doi_or_url": "https://example.org/bsebench/synthetic-source-ledger/partial-001",
+        "retrieved_at": "2026-05-07",
+        "metric": "synthetic RMSE percent",
+        "dataset": "SyntheticCellSet v0 fixed profile",
+        "split": "synthetic alternate validation horizon B",
+        "preprocessing": "not_reported",
+        "method": "SyntheticComparableMethod",
+        "reported_value": "2.340 synthetic units (fixture only, not literature evidence)",
+        "bsebench_value": "2.100 synthetic units from frozen fixture artifact",
+        "comparability": "partial",
+        "caveat": "synthetic caveat: source row shares metric and dataset but leaves preprocessing unreported and uses a different validation horizon"
+      }
+    ]
+  }
+}

tokens used
150,360
Implemented and committed `befd8974fd11ed90a06e9e0d3572b0d32bf61b0b`:

`GLASSBOX [role: worker-FR] Add source-ledger freshness gate`

Added [check-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/check-source-ledger-freshness.sh) plus fixture coverage in [test-source-ledger-freshness.sh](/mnt/c/doctorat/bsebench-org/bsebench-async-codex-phase-7-10-v-async-source-ledger-freshness-gate/scripts/test-source-ledger-freshness.sh). The checker classifies rows as `comparable`, `partial`, `not_comparable`, `stale`, or `invalid`, and fails closed on future/malformed dates, stale retrievals, missing stable URL/DOI, missing metric/dataset/split, missing frozen BSEBench value, missing caveat, and `comparable` rows with unknown required conditions.

Validation passed:
- `bash scripts/test-source-ledger-freshness.sh`
- `bash -n scripts/check-source-ledger-freshness.sh scripts/test-source-ledger-freshness.sh scripts/check-research-diff-scope.sh scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/probe-research-diff-scope-guard.sh`
- `bash scripts/check-research-brief-gates.sh --dry-run cto/AUTONOMY_BACKLOG/phase-7-*/BRIEF.md` (`28 checked`)
- `git diff --check`
- `git diff --cached --check`
- Extra staged guard: `bash scripts/check-research-diff-scope.sh --dry-run --staged`

No thesis files, claim registries, `claims/registry.yaml`, `claim_55`, or roadmap files were edited. No real literature numbers were added. No `Co-Authored-By Claude` trailer is present.
```

## Next step for chef

git fetch origin && git checkout phase-7-10-v-async-source-ledger-freshness-gate in target_repo. Verify gates. Merge to main if green.

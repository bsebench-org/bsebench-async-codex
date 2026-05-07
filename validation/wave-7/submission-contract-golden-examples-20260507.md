# Submission Contract Golden Examples Validation

GLASSBOX metadata:

- Artifact id: `submission-contract-golden-examples-20260507`
- Worker: `W7-d`
- Branch: `phase-8-6-d-submission-contract-golden-examples-20260507T214305Z`
- Date: 2026-05-07
- Owned write-set:
  - `examples/submissions/phase8-alpha/`
  - `validation/wave-7/submission-contract-golden-examples-20260507.md`
- Scope: draft community estimator submission golden examples and rejection
  examples tied to the universal step API and blind evaluation constraints.
- Non-scope: runner, stats, datasets, thesis, manuscript, roadmap, claim
  registry, `claims/registry.yaml`, `claim_55`, benchmark results, and public
  scientific claims.

## Evidence Inspected

Read-only evidence used before drafting:

| Evidence | Path | Finding used |
|---|---|---|
| Universal benchmark charter | `docs/BSEBENCH-UNIVERSAL-BENCHMARK-CHARTER-2026-05-07.md` | Contributor algorithms should not rewrite loaders, split logic, metrics, or reports; blind evaluation and calibration/training separation are core integrity requirements. |
| Universal parallel wave brief | `docs/BSEBENCH-UNIVERSAL-PARALLEL-WAVE-2026-05-07.md` | Wave 1 identifies the estimator plugin contract, submission smoke path, contributor template, anti-leakage, degraded initialization, provenance, and monthly readiness as target infrastructure. |
| Runner estimator contract branch | `../bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/src/bsebench_runner/estimator_contract.py` | Candidate contract version is `bsebench.estimator.v1`; `step(t, voltage_V, current_A, temperature_C)` must return a mapping with finite numeric `voltage_predicted`; extra outputs must also be finite numeric scalars. |
| Runner contract tests | `../bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/tests/test_estimator_contract.py` | Contract tests reject missing `voltage_predicted`, non-finite values, non-string keys, factories without callable `step`, and verify fresh stateful factory instances. |
| Runner toy adapter fixture | `../bsebench-runner-phase-8-0-a-universal-runner-estimator-plugin-contract/tests/fixtures/toy_estimator_adapter.py` | A minimal toy estimator can expose `voltage_predicted` and optional `soc_estimated` without hidden labels. |
| Runner external submission smoke | `../bsebench-runner-phase-8-0-f-universal-runner-submission-smoke/tests/test_submission_smoke.py` and `examples/submissions/toy_external_estimator.py` in that worktree | External submission smoke currently proves same-process registry loading only; it is not a sandbox or public release approval. |
| Contributor template branch | `../bsebench-async-codex-cto-report-phase-8-0-s-universal-async-submission-template/templates/universal-contributor-submission-template.md` | Intake packets should declare metadata, adapter contract, data/split use, provenance, requested metrics, comparison ledger, reproduction commands, and checklist status. |
| Estimator compatibility matrix | `../bsebench-async-codex-cto-report-phase-8-3-n-estimator-interface-compatibility-matrix-20260507T204627Z/audits/universal/estimator-interface-compatibility-matrix-20260507T204627Z.md` | Current scoring is voltage-centered; SOC/SOH outputs may be carried, but public SOC/SOH metric compatibility needs validated ground truth, target-signal metadata, and stats contracts. |
| Community package index | `../bsebench-async-codex-cto-report-phase-8-4-m-community-submission-package-index-20260507T213125Z/release/alpha/community-submission-package-index-20260507T213125Z.md` | A complete community package still needs a real filled packet, dependency restore, sandbox smoke, determinism replay, leakage review, protocol assignment, evidence manifest, source ledger for comparisons, and freeze artifacts. |
| Adversarial submission spec | `../bsebench-async-codex-cto-report-phase-8-5-j-submission-adversarial-test-spec-20260507T213656Z/specs/submissions/adversarial-test-spec-20260507T213656Z.md` | Minimal alpha gate families include state reset/order invariance, label denial, determinism replay, dependency/network/filesystem boundaries, and report blocker fields. |

## Drafted Artifacts

| Artifact | Purpose |
|---|---|
| `examples/submissions/phase8-alpha/README.md` | Directory index and non-claim caveat. |
| `examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py` | Self-contained causal adapter matching the inspected step signature. |
| `examples/submissions/phase8-alpha/golden-submission-packet.md` | Filled alpha intake example with metadata, blind-evaluation declaration, metric caveats, and reproduction commands. |
| `examples/submissions/phase8-alpha/rejection-examples.md` | Rejection examples for invalid output schema, label leakage, future-sample leakage, cross-fold state, evaluation tuning, network/dynamic dependency use, unsupported claim language, and protocol mismatch. |

## Contract Coverage

The golden adapter example intentionally satisfies these inspected contract
requirements:

- callable `step(t, voltage_V, current_A, temperature_C)`;
- finite numeric `voltage_predicted` output;
- optional finite numeric `soc_estimated` output;
- fresh factory hook through `build_estimator()`;
- no imports from datasets, metrics, labels, reports, network clients, or
  runner internals;
- deterministic output for identical input stream and initial state.

The rejection catalog maps failure examples to alpha decisions:

- missing or invalid `voltage_predicted`: reject until contract-compliant;
- label file read: reject and mark non-blind;
- future-sample lookahead: reject until causal or approved protocol exists;
- cross-fold global state: reject until reset/fresh-factory replay passes;
- evaluation-tuned hyperparameters: reject until tuning provenance is separated;
- network/dynamic dependency use: reject until offline reproducibility exists;
- unsupported comparison or claim language: reject until removed or complete
  source-ledger evidence exists;
- SOC/SOH-only output: reject for the current voltage protocol.

## Blind Evaluation Constraints

These examples avoid or explicitly reject:

- evaluation labels, SOC/SOH ground truth files, metric outputs, hidden split
  manifests, previous reports, and benchmark result caches;
- future evaluation samples under the causal step API;
- hyperparameter selection from repeated hidden benchmark submissions;
- persistent cross-fold state not cleared by fresh factory or reset;
- import-time or evaluation-time network calls;
- public comparison or benchmark-proof claim language forbidden by the Wave 7
  guardrails.

## Validation Record

Commands run from this worktree:

```bash
python3 -m py_compile examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py
python3 examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py
git diff --check
```

Expected output characteristics:

- Python compile succeeds.
- Adapter dry run prints a finite mapping containing `voltage_predicted` and
  `soc_estimated`.
- `git diff --check` reports no whitespace errors.

Observed results in this worktree:

- `python3 -m py_compile examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py`: PASS.
- `python3 examples/submissions/phase8-alpha/golden_causal_voltage_adapter.py`: PASS; printed `{'voltage_predicted': 3.7, 'soc_estimated': 0.5}`.
- `git diff --check`: PASS.
- Forbidden-claim and prohibited coauthor-trailer scan over owned files: PASS.

## Blockers And Residual Risks

- The inspected runner contract and submission smoke are in sibling Wave 1
  runner branches, not guaranteed merged into the target integration branch at
  this inspection time.
- The examples are not a full sandbox harness and do not implement syscall,
  filesystem, network, subprocess, dependency-lock, or resource-limit audits.
- The examples do not validate real SOC/SOH public scoring. SOC/SOH public
  metrics remain blocked on selected protocols with validated labels, metric
  definitions, and leakage gates.
- A real community submission still needs package-specific dependency restore,
  sandbox smoke, determinism replay, leakage review, protocol assignment,
  evidence manifest, source ledger for comparisons, and release hash bundle.

## Explicit Non-Claims

- This artifact makes no public comparison or benchmark-proof scientific claim.
- This artifact does not claim any method is empirically better than another.
- This artifact does not certify public monthly benchmark readiness.
- This artifact does not edit or validate thesis files, manuscript files, the
  scientific roadmap, claim registry files, `claims/registry.yaml`, or
  `claim_55`.

# Fail-Closed Checklist

Packet: `replace_with_submission_id`

Mark every required check `pass`, `blocked`, or `not_applicable`. Intake may
proceed only when every required check is `pass`.

| Check | Required | Status | Notes |
| --- | --- | --- | --- |
| Required file set is complete. | yes | `blocked` | Replace placeholder. |
| `submission_metadata.json` parses as JSON. | yes | `blocked` | Replace placeholder. |
| Metadata contains no placeholder values. | yes | `blocked` | Replace placeholder. |
| Contract version is `bsebench.estimator.v1`. | yes | `blocked` | Replace placeholder. |
| `estimator_adapter.py` imports by file path. | yes | `blocked` | Replace placeholder. |
| `build_filter_registry()` exists and returns a runner `FilterRegistry`. | yes | `blocked` | Replace placeholder. |
| Estimator `step` accepts `t`, `voltage_V`, `current_A`, and `temperature_C`. | yes | `blocked` | Replace placeholder. |
| `voltage_predicted` is present and finite for the smoke step. | yes | `blocked` | Replace placeholder. |
| Extra step outputs are finite numeric scalars. | yes | `blocked` | Replace placeholder. |
| Smoke import performs no network access. | yes | `blocked` | Replace placeholder. |
| Smoke import writes no files outside a temp directory. | yes | `blocked` | Replace placeholder. |
| Smoke run does not read secrets or private cache material. | yes | `blocked` | Replace placeholder. |
| Split file includes forensic source metadata. | yes | `blocked` | Replace placeholder. |
| Split file has no overlapping calibration and evaluation identities. | yes | `blocked` | Replace placeholder. |
| Dependency risk form has no unknown required runtime dependencies. | yes | `blocked` | Replace placeholder. |
| Replay evidence includes command, repo SHA, artifact path, and artifact hash. | yes | `blocked` | Replace placeholder. |
| Packet contains no unsupported result language or public ranking language. | yes | `blocked` | Replace placeholder. |
| Packet contains no forbidden coauthor trailer. | yes | `blocked` | Replace placeholder. |

## Intake Decision

- Decision: `blocked`
- Reviewer:
- Date UTC:
- Notes:

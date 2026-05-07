# Replay Evidence Form

Packet: `replace_with_submission_id`

Replay evidence must be based on a clean checkout or a clearly documented
maintainer environment. Missing repo SHAs, missing commands, or missing artifact
hashes block intake.

## Repositories

| Repo | Path or URL | Commit SHA | Notes |
| --- | --- | --- | --- |
| runner | `unknown` | `unknown` | Required. |
| datasets | `unknown` | `unknown` | Required when canonical adapters are used. |
| stats | `not_applicable` | `not_applicable` | Required only when a stats replay is run. |

## Replay Command

```bash
# Replace with the exact command used for replay.
```

## Artifacts

| Artifact | SHA256 | Created UTC | Notes |
| --- | --- | --- | --- |
| `unknown` | `unknown` | `unknown` | Replace placeholder. |

## Maintainer Rerun

| Check | Status | Notes |
| --- | --- | --- |
| Command starts from a clean checkout. | `blocked` | Replace placeholder. |
| Required repos are pinned by SHA. | `blocked` | Replace placeholder. |
| Artifact hashes match rerun output. | `blocked` | Replace placeholder. |
| Any mismatch returns non-zero or is marked blocked. | `blocked` | Replace placeholder. |

Any `blocked` status blocks intake.

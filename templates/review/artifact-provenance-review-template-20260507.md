# Frozen Artifact Provenance Review Template

> TEMPLATE for reviewing a frozen BSEBench artifact bundle before alpha,
> public report, monthly snapshot, or downstream release use.
>
> This template records provenance and replay readiness only. It does not make
> scientific, public-ranking, or claim-status statements. Unknown evidence must
> be marked `unknown` or `blocked`; do not infer missing hashes, licenses,
> split policies, or source ledger rows.

## Review Identity

| Field | Value |
| --- | --- |
| Review id | `<review-id>` |
| Reviewed bundle id | `<bundle-id>` |
| Reviewed artifact root | `<path-or-uri>` |
| Review date UTC | `<YYYY-MM-DDTHH:MM:SSZ>` |
| Reviewer | `<name-or-role>` |
| Prepared by | `<name-or-role>` |
| Review scope | `<neutral scope statement>` |
| Source repositories inspected | `<repo list>` |
| Source refs inspected | `<branch-or-commit list>` |
| Hash algorithm | `sha256` |
| Review status | `<pass/needs-fix/blocked>` |
| Protected files edited | `no` |

## Fail-Closed Rules

Mark the review `blocked` if any required field below is missing, unverifiable,
or based only on an unmerged side branch without a reviewer-approved exception.

| Rule | Required evidence | Status | Blocker id |
| --- | --- | --- | --- |
| Every reviewed artifact has an immutable path or URI. | Artifact inventory row. | `<pass/fail>` | `<id-or-none>` |
| Every reviewed artifact has a SHA256 hash. | `sha256sum <path>` or equivalent. | `<pass/fail>` | `<id-or-none>` |
| Every source repo is pinned to a full commit SHA. | `git rev-parse <ref>`. | `<pass/fail>` | `<id-or-none>` |
| Every source repo has clean or explicitly recorded dirty status. | `git status --short`. | `<pass/fail>` | `<id-or-none>` |
| Dataset license/access status is recorded per dataset artifact. | Registry row, license file, or blocker. | `<pass/fail>` | `<id-or-none>` |
| Split manifests are present and hashable. | Split manifest path and SHA256. | `<pass/fail>` | `<id-or-none>` |
| Source ledger rows are complete for any external comparison context. | Ledger path, hash, retrieval date, caveat. | `<pass/fail>` | `<id-or-none>` |
| Replay commands are recorded and runnable or explicitly blocked. | Command, inputs, environment, result. | `<pass/fail>` | `<id-or-none>` |
| Reviewer sign-off is explicit. | Sign-off table completed. | `<pass/fail>` | `<id-or-none>` |

## Current Sidecar Cross-Check

Use this section to record read-only evidence from current W6/W7/W8 sidecars
when they are present. Sidecar evidence may inform blockers and next actions,
but it is not a substitute for committed frozen artifacts in the reviewed
bundle.

| Evidence class | Ref or path inspected | Expected artifact | Observed status | Review use |
| --- | --- | --- | --- | --- |
| W6 red-team sidecars | `<phase-8-5-* refs>` | Red-team reports, runbooks, license red-team notes. | `<complete/blocked/unknown>` | Advisory only unless merged and cited by commit. |
| W7 frozen hash manifest template | `<phase-8-6-o... ref>` | `templates/release/frozen-artifact-hash-manifest-template-20260507.md`. | `<present/absent/unknown>` | Reuse required row classes where applicable. |
| W7 source-ledger fixture pack | `<phase-8-6-c... ref>` | Synthetic source rows, frozen-value rows, comparison bindings. | `<present/absent/unknown>` | Fixture-only unless real rows are added and reviewed. |
| W7 alpha blocker dashboard | `<phase-8-6-g... ref>` | Current P0/P1 blocker table. | `<present/absent/unknown>` | Carry blockers forward. |
| W8 W6 closure audit | `<phase-8-7-d... ref>` | W6 sidecar closure matrix. | `<present/absent/unknown>` | Confirms sidecar closure, not release approval. |
| W8 alpha missing artifacts tasklist | `<phase-8-7-f... ref>` | Missing alpha artifact tasklist. | `<present/absent/unknown>` | Carry missing artifact rows forward. |
| W8 source-ledger gap audit | `<phase-8-7-g... ref>` | Current ledger gap audit. | `<present/absent/unknown>` | Carry source-ledger blockers forward. |

Read-only cross-check commands:

```bash
git fetch --all --prune
git status --short --branch
git rev-parse <ref>
git diff --name-status origin/main...<sidecar-ref>
git show <sidecar-ref>:<artifact-path>
```

## Repository Commit Review

Record every repository that can affect artifact generation, validation,
dataset loading, statistics, reporting, or replay. Use full SHAs.

| Component | Repository URL | Local path inspected | Ref inspected | Full commit SHA | Commit date UTC | Dirty status | Remote pushed | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Async/report repo | `<url>` | `<path>` | `<ref>` | `<sha>` | `<iso>` | `<clean/dirty/unknown>` | `<yes/no/unknown>` | `<accept/block>` | `<notes>` |
| Runner repo | `<url>` | `<path>` | `<ref>` | `<sha>` | `<iso>` | `<clean/dirty/unknown>` | `<yes/no/unknown>` | `<accept/block>` | `<notes>` |
| Stats repo | `<url>` | `<path>` | `<ref>` | `<sha>` | `<iso>` | `<clean/dirty/unknown>` | `<yes/no/unknown>` | `<accept/block>` | `<notes>` |
| Datasets repo | `<url>` | `<path>` | `<ref>` | `<sha>` | `<iso>` | `<clean/dirty/unknown>` | `<yes/no/unknown>` | `<accept/block>` | `<notes>` |

Minimum commands:

```bash
git -C <repo> rev-parse <ref>
git -C <repo> log -1 --format='%H %cI %s' <ref>
git -C <repo> status --short
git -C <repo> ls-remote --heads origin <branch>
```

## Artifact Hash Review

Every frozen artifact cited by the bundle must appear here. If the artifact is
private, record a stable private artifact id and keep the path in a controlled
appendix.

| Artifact id | Artifact class | Path or URI | Format | Size bytes | SHA256 | Produced by commit SHA | Produced by command | Hash command | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<artifact-id>` | `<dataset/split/protocol/result/report/log/bundle>` | `<path-or-uri>` | `<json/csv/md/log/other>` | `<bytes>` | `<sha256>` | `<sha>` | `<command>` | `sha256sum <path>` | `<accept/block>` | `<notes>` |

Hash review commands:

```bash
sha256sum <artifact-path>
wc -c <artifact-path>
git -C <repo> ls-files --stage -- <artifact-path>
```

## Dataset License And Provenance Review

Record one row per dataset source, cache, or derived artifact. Do not mark a
dataset release-ready unless license/access/provenance evidence is explicit.

| Dataset id | Artifact id | Source URL or registry id | License/access status | License evidence path | Retrieval or generation date | Registry/provenance path | Registry/provenance SHA256 | Local path disclosure policy | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<dataset-id>` | `<artifact-id>` | `<url-or-registry-id>` | `<license/access/unknown>` | `<path-or-blocked>` | `<date-or-unknown>` | `<path-or-blocked>` | `<sha256-or-unknown>` | `<public/private/redacted>` | `<accept/block>` | `<notes>` |

Required blockers:

| Blocker id | Dataset id | Missing or failed evidence | Required resolution | Owner | Status |
| --- | --- | --- | --- | --- | --- |
| `DATA-LIC-001` | `<dataset-id>` | `<license/access/provenance/hash>` | `<specific evidence>` | `<role>` | `<open/closed>` |

## Split Manifest Review

Every evaluation, calibration, validation, test, profile, cell, temporal, or
holdout partition must have a hashable split manifest.

| Split id | Dataset id | Protocol id | Split manifest path | SHA256 | Split policy summary | Generated by commit SHA | Leakage guard command | Leakage guard result | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<split-id>` | `<dataset-id>` | `<protocol-id>` | `<path>` | `<sha256>` | `<neutral summary>` | `<sha>` | `<command-or-blocked>` | `<pass/fail/not-run>` | `<accept/block>` | `<notes>` |

Required blockers:

| Blocker id | Split id | Missing or failed evidence | Required resolution | Owner | Status |
| --- | --- | --- | --- | --- | --- |
| `SPLIT-001` | `<split-id>` | `<manifest/hash/leakage-check>` | `<specific evidence>` | `<role>` | `<open/closed>` |

## Source Ledger Review

Use this section for dataset provenance ledgers, external-source ledgers,
frozen-value ledgers, comparison bindings, and public-text claim bindings. Real
external comparison rows require stable source identifiers, retrieval dates,
exact metric/dataset/split context, and caveats.

| Ledger id | Ledger class | Path | SHA256 | Required fields present | Retrieval dates present | Frozen artifact hashes present | Comparability caveats present | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<ledger-id>` | `<dataset/external-source/frozen-value/comparison-binding/text-binding>` | `<path>` | `<sha256>` | `<yes/no>` | `<yes/no/not-applicable>` | `<yes/no/not-applicable>` | `<yes/no/not-applicable>` | `<accept/block>` | `<notes>` |

Required source-ledger row classes:

| Row class | Required minimum fields | Status | Blocker id |
| --- | --- | --- | --- |
| External source row | `source_id`, title, DOI or stable URL, retrieval date, source location, access status, method/task, metric/unit/direction, dataset/version, split/protocol, preprocessing, reported value, caveat. | `<present/missing/not-applicable>` | `<id-or-none>` |
| Frozen BSEBench value row | `bsebench_value_id`, exact value, metric/unit/direction, dataset, split, method, artifact repo/ref/commit/path/hash, generation command, replay command, validation log, environment, evidence status, caveat. | `<present/missing/not-applicable>` | `<id-or-none>` |
| Comparison binding row | `comparison_id`, resolved source ids, resolved frozen value ids, comparison scope, comparability decision, metric/dataset/split/method/preprocessing match decisions, leakage risk, caveat, reviewer. | `<present/missing/not-applicable>` | `<id-or-none>` |
| Public-text binding row | Text artifact path, line/table reference, text hash, trigger terms, resolved comparison ids, decision, reviewer note. | `<present/missing/not-applicable>` | `<id-or-none>` |

## Replay Command Review

Replay must start from frozen inputs and pinned commits. If replay is too
expensive, unavailable, or blocked by private data, record the exact blocker.

| Replay id | Purpose | Working directory | Command | Input artifact ids | Expected outputs | Environment lock | Exit code | Result artifact/log | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<replay-id>` | `<hash-check/result-replay/report-regeneration/ledger-check>` | `<path>` | `<command>` | `<ids>` | `<paths>` | `<lockfile/container/unknown>` | `<code-or-not-run>` | `<path>` | `<accept/block>` | `<notes>` |

Minimum replay evidence:

```bash
<setup command if any>
<replay command>
sha256sum <replay-output>
git diff --check
```

## No-Claim Language Review

Use this gate for public report text, release notes, README excerpts, monthly
snapshots, and reviewer summaries derived from frozen artifacts.

| Text artifact | Path | Text SHA256 | Guardrail command or manual check | Result | Reviewer decision | Notes/blocker |
| --- | --- | --- | --- | --- | --- | --- |
| `<text-id>` | `<path>` | `<sha256>` | `<command-or-manual>` | `<pass/fail/not-run>` | `<accept/block>` | `<notes>` |

Forbidden outcomes:

| Check | Decision |
| --- | --- |
| Positive scientific or public-ranking wording without complete source-ledger and frozen-value rows. | `block` |
| Claim registry, thesis prose, manuscript, roadmap, or protected claim edits in this artifact review. | `block` |
| Missing caveat for partial or not-comparable rows. | `block` |
| Any unknown evidence silently treated as pass. | `block` |

## Blocker Register

Repeat every blocker here. A review with open critical or high blockers cannot
be signed off as pass.

| Blocker id | Severity | Artifact class | Artifact id | Blocking condition | Required resolution evidence | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `<BLOCK-ID>` | `<critical/high/medium/low>` | `<repo/dataset/split/ledger/replay/text/bundle>` | `<artifact-id>` | `<condition>` | `<evidence>` | `<role>` | `<open/closed>` |

## Reviewer Sign-Off

| Role | Name | Date UTC | Decision | Scope signed | Notes |
| --- | --- | --- | --- | --- | --- |
| Artifact preparer | `<name>` | `<YYYY-MM-DD>` | `<complete/blocked>` | `<scope>` | `<notes>` |
| Provenance reviewer | `<name>` | `<YYYY-MM-DD>` | `<accept/needs-fix/block>` | `hashes, commits, source ledger` | `<notes>` |
| Dataset/license reviewer | `<name>` | `<YYYY-MM-DD>` | `<accept/needs-fix/block>` | `dataset license, source provenance` | `<notes>` |
| Split/leakage reviewer | `<name>` | `<YYYY-MM-DD>` | `<accept/needs-fix/block>` | `split manifests, leakage guard` | `<notes>` |
| Replay reviewer | `<name>` | `<YYYY-MM-DD>` | `<accept/needs-fix/block>` | `replay commands and logs` | `<notes>` |
| Release owner | `<name>` | `<YYYY-MM-DD>` | `<pass/blocked>` | `final artifact bundle` | `<notes>` |

## Validation Record

Commands run while completing this review:

```bash
git status --short --branch
git diff --check
```

| Command | Result | Notes |
| --- | --- | --- |
| `git status --short --branch` | `<pass/fail>` | `<notes>` |
| `git diff --check` | `<pass/fail>` | `<notes>` |
| `<additional command>` | `<pass/fail/not-run>` | `<notes>` |

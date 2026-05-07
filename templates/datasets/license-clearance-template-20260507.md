# Dataset License Clearance Template

Template date: 2026-05-07
Scope: monthly public BSEBench reports and release gates for dataset-bearing artifacts.
Posture: evidence-only; unknown redistribution terms fail closed.

## Use

Copy this template for each monthly public report candidate, release candidate,
or dataset publication package. Fill every bracketed field from committed
evidence, registry metadata, source pages, dataset manifests, or local
provenance audits. Do not infer missing license terms from memory, dataset
popularity, or prior local use.

This template clears only dataset redistribution and public-report disclosure
status. It does not certify scientific claims, leaderboard status, novelty, or
SOTA comparisons.

## Release Gate Summary

Report or release candidate: `[report-or-release-id]`
Prepared by: `[name-or-worker-id]`
Prepared at: `[YYYY-MM-DDTHH:MM:SSZ]`
Target repository and commit: `[owner/repo@sha]`
Dataset-bearing artifact paths: `[paths-or-none]`
Source evidence bundle paths: `[paths]`
Prior red-team artifact reviewed: `[path-or-none]`

Gate decision: `[PASS | PASS_WITH_CAVEATS | BLOCKED]`

Decision rules:

- `PASS`: every included dataset has a source license or permission record that
  allows the exact public use and redistribution mode in this release.
- `PASS_WITH_CAVEATS`: public report may cite aggregate/non-redistributive
  results, but at least one dataset has restrictions that must be printed in
  the caveats and must not be mirrored or bundled.
- `BLOCKED`: any dataset planned for publication or redistribution has unknown,
  missing, contradictory, expired, or non-public redistribution terms.

Fail-closed policy:

- Unknown dataset license, unknown redistribution permission, missing source
  URL, missing registry entry, or missing permission evidence means
  `redistribution_decision = blocked_unknown_terms`.
- `blocked_unknown_terms` blocks raw data, derived row-level data, local cache
  mirrors, and public download links until a reviewed license or permission
  record is committed.
- If only aggregate metrics are reported, the report may proceed only when the
  dataset source identity is known and the report clearly states that the data
  itself is not redistributed.

## Evidence Inputs

| Input | Required value | Evidence path or URL | Reviewed at | Reviewer |
|---|---|---|---|---|
| Dataset registry snapshot | `[repo@sha or N/A]` | `[path]` | `[date]` | `[name]` |
| Loader/cache provenance audit | `[repo@sha or N/A]` | `[path]` | `[date]` | `[name]` |
| Citation metadata | `[repo@sha or N/A]` | `[path]` | `[date]` | `[name]` |
| Dataset license red-team | `[repo@sha or N/A]` | `[path-or-none]` | `[date]` | `[name]` |
| External permission emails/contracts | `[id or N/A]` | `[path]` | `[date]` | `[name]` |

Minimum evidence required for each dataset:

- Dataset identifier and version or source snapshot.
- Original source URL, DOI, repository URL, or provider page.
- License name, license URL, provider terms URL, or permission record.
- Retrieval date or registry commit SHA.
- Exact public use mode: citation only, aggregate report, derived artifact,
  bundled processed data, mirrored raw data, or hosted local cache.
- Attribution and notice requirements.
- Redistribution limitations and revocation/expiry conditions, if any.

## Dataset Clearance Matrix

| Dataset id | Source/version evidence | License/terms evidence | Public report use | Redistribute raw? | Redistribute derived/cache? | Attribution/notice required | Decision | Caveat/blocker |
|---|---|---|---|---|---|---|---|---|
| `[dataset-id]` | `[path/url@date]` | `[path/url@date]` | `[aggregate-only | row-level | figures | none]` | `[yes | no | unknown]` | `[yes | no | unknown]` | `[text]` | `[cleared | cleared_report_only | blocked_restricted | blocked_unknown_terms]` | `[text]` |

Decision vocabulary:

- `cleared`: evidence allows the exact report and redistribution use.
- `cleared_report_only`: aggregate or figure reporting is allowed, but no data,
  cache, or row-level artifact may be redistributed.
- `blocked_restricted`: evidence shows the planned redistribution or public
  report use is not allowed.
- `blocked_unknown_terms`: evidence is absent, incomplete, contradictory, or not
  reviewed.

## Monthly Public Report Checklist

- [ ] The report lists every dataset used in figures, tables, and aggregate
  metrics.
- [ ] Each dataset has a completed clearance row.
- [ ] The report separates benchmark code license from upstream dataset licenses.
- [ ] The report states when BSEBench does not redistribute the upstream data.
- [ ] Dataset attribution text is included exactly as required by the evidence.
- [ ] Restricted datasets are marked as source-obtainable-only or excluded.
- [ ] Unknown-license datasets are excluded from redistribution and marked as
  blocked if required for the public artifact.
- [ ] No claim language relies on an uncleared dataset artifact.
- [ ] A reviewer checked that generated files do not contain embedded raw rows,
  local cache paths with secrets, private URLs, or provider tokens.

## Release Artifact Checklist

- [ ] Raw dataset files are absent unless every raw redistribution row is
  `cleared`.
- [ ] Processed Parquet/CSV/JSON/cache files are absent unless every
  derived/cache redistribution row is `cleared`.
- [ ] Dataset manifests include source identity and license/terms pointers.
- [ ] Citation files and release metadata do not imply that upstream datasets
  inherit the benchmark code license.
- [ ] Public download instructions point users to upstream sources when
  redistribution is not cleared.
- [ ] Any third-party notices required by source terms are bundled in the
  release artifact.
- [ ] The final `git diff --check` or release archive lint is recorded.

## Required Caveat Text

Use these exact caveat classes in reports and release notes as applicable:

| Caveat class | Required wording |
|---|---|
| No redistribution | `This report does not redistribute upstream dataset files. Users must obtain restricted datasets from the original provider under that provider's terms.` |
| Aggregate only | `This report publishes aggregate benchmark outputs only; row-level source data and local cache artifacts are not included.` |
| Unknown terms | `Dataset redistribution is blocked because license or redistribution terms were not available in the reviewed evidence bundle.` |
| Permission pending | `Dataset redistribution is blocked pending written permission or a reviewed public license record.` |

## Sign-Off

Prepared by: `[name]`
Prepared date: `[YYYY-MM-DD]`
Independent reviewer: `[name]`
Review date: `[YYYY-MM-DD]`
Final decision: `[PASS | PASS_WITH_CAVEATS | BLOCKED]`
Required follow-up issues: `[links-or-none]`

Sign-off statement:

`I reviewed the evidence paths listed above. Any dataset with unknown or
uncleared redistribution terms is excluded from redistributed artifacts or has
blocked this release candidate. Missing metadata is recorded as a blocker, not
inferred.`

# GLASSBOX Async Docs Integration Red-Team - 2026-05-07T213656Z

- Worker: W6-04
- Branch: `phase-8-5-d-async-docs-integration-redteam-20260507T213656Z`
- Local sample time: `2026-05-07T23:42:14+02:00`
- Owned write-set: `redteam/wave5/async-docs-integration-redteam-20260507T213656Z.md`
- Scope: red-team Wave 5 async/docs integration risk while other integration
  workers continue. This artifact is advisory only and changes no integrated
  docs, specs, gates, claim registries, thesis/manuscript files, or roadmap
  files.

## Objective

Identify merge and publication risks in the async/docs Wave 5 integration path:
duplicate source-ledger specifications, stale validation claims, and missing
source-ledger gates before any public comparison, ranking, release note, or
claim-like wording is allowed.

This artifact does not publish benchmark results, compare methods, rank methods,
register claims, or assert novelty, leaderboard, breakthrough, external
verification, or state-of-the-art status.

## Evidence Inspected

Current local refs sampled:

| Ref | SHA | Finding |
| --- | --- | --- |
| `HEAD` / this red-team branch | `357e990ffd23c3d41581117bb02bf7368816ddcd` | Clean starting point on current main baseline. |
| `phase-8-4-d-async-universal-docs-integration-20260507T213125Z` | `52a7b14d0c41ab56c315bd9e14d36bcf7f358248` | Main Wave 5 docs integration branch. |
| `phase-8-4-h-async-integration-validator-20260507T213125Z` | `357e990ffd23c3d41581117bb02bf7368816ddcd` | Points at current main; no extra validation artifact was present in this ref. |
| `phase-8-4-l-public-claims-redline-gate-20260507T213125Z` | `b76ce0949e07cc3770c52090c0a50f00fb59ed9b` | Wave 5 public-claims redline gate design. |
| `phase-8-3-g-async-wave1-wave2-deep-validation-20260507T204627Z` | `5e06094d12fdc66446ca1cb4d45940388d6dcc31` | Wave 4 async validation artifact. |
| `phase-8-3-k-source-ledger-schema-spec-20260507T204627Z` | `808d046ca467be270ef39852db1127e41bc8e101` | Wave 4 source-ledger schema artifact. |

Primary files inspected from those refs:

- `validation/wave-4/async-wave1-wave2-deep-validation-20260507T204627Z.md`
- `specs/universal/source-ledger-schema-20260507T204627Z.md`
- `audits/universal/source-ledger-audit-20260507T193050Z.md`
- `dashboards/phase8/merge-readiness-dashboard-20260507T204627Z.md`
- `ledgers/phase8/branch-ledger-20260507T204627Z.md`
- `ledgers/phase8/docs-integration-ledger-20260507T213125Z.md`
- `docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md`
- `docs/schemas/bsebench-monthly-benchmark-snapshot-v1.schema.json`
- `docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md`
- `docs/universal/community-benchmark-report-outline-20260507T204627Z.md`
- `gates/public-claims-redline-gate-20260507T213125Z.md`
- `scripts/check-research-brief-gates.sh`

Representative commands run:

```bash
git status --short --branch
git for-each-ref --format='%(refname:short) %(objectname:short) %(committerdate:iso8601) %(subject)' \
  refs/heads/phase-8-3-g-async-wave1-wave2-deep-validation-20260507T204627Z \
  refs/heads/phase-8-3-k-source-ledger-schema-spec-20260507T204627Z \
  refs/heads/phase-8-4-d-async-universal-docs-integration-20260507T213125Z \
  refs/heads/phase-8-4-h-async-integration-validator-20260507T213125Z \
  refs/heads/phase-8-4-l-public-claims-redline-gate-20260507T213125Z \
  refs/heads/phase-8-5-d-async-docs-integration-redteam-20260507T213656Z
git diff --name-status HEAD...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
git diff --check HEAD...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
git diff --check HEAD...phase-8-4-l-public-claims-redline-gate-20260507T213125Z
git diff --name-only HEAD...phase-8-4-d-async-universal-docs-integration-20260507T213125Z |
  rg -n '(^|/)(thesis|manuscript|claims/registry\.yaml|claim_55|RESEARCH-ROADMAP|scientific-roadmap|roadmap)' || true
git grep -n -i -E 'source[- ]ledger|ledger_status|claim binding|claim-to-ledger|comparison_id|retrieved_at|retrieval_date|doi_or_url|stable_url_or_doi|bsebench_value|comparability' \
  phase-8-4-d-async-universal-docs-integration-20260507T213125Z -- docs audits specs ledgers templates validation scripts tests
git grep -n -i -E '\b(SOTA|state[- ]of[- ]the[- ]art|novel|breakthrough|verified[- ]claim|leaderboard|best in|outperform|beats?|surpass|claim accepted|overall winner|first)\b' \
  phase-8-4-d-async-universal-docs-integration-20260507T213125Z -- docs audits specs ledgers runbooks templates validation gates
```

## Findings

### 1. Wave 5 docs integration is mechanically close, but exact SHA pinning is mandatory.

At sample time, `phase-8-4-d` is a fast-forward candidate from `HEAD`; `HEAD` is
an ancestor of `52a7b14`. It adds 66 paths relative to `HEAD`, including 63
under docs, audits, specs, ledgers, runbooks, templates, validation, tests, or
scripts.

Current replay result:

```text
git diff --check HEAD...phase-8-4-d-async-universal-docs-integration-20260507T213125Z
PASS, no output
```

Important timing note: during this red-team pass, the branch moved from
`9968bae` to `52a7b14`. The earlier `9968bae` range still exposed the known
`phase-8-1-o` trailing whitespace problem in
`audits/wave-1/integration-conflict-map-20260507T193050Z.md`. The current
W5 docs integration ledger says that trailing whitespace was cleaned before
`52a7b14`, and replay confirms the current range is clean. Merge operators
should pin `52a7b14` or newer and rerun `git diff --check` immediately before
merge.

### 2. The async integration-validator ref contributes no new validation artifact.

`phase-8-4-h-async-integration-validator-20260507T213125Z` points to the same
SHA as current main, `357e990`. It should not be counted as completed Wave 5
async validation evidence. Use the W4 async validation artifact and W5 docs
integration ledger instead, or require a real W5 validator artifact before
calling async docs integration independently validated.

Merge impact: not a file-level conflict, but a release-process blocker if the
merge plan requires a separate Wave 5 async integration validator signoff.

### 3. Source-ledger definitions are duplicated across docs and differ in strictness.

The integrated docs contain overlapping ledger definitions in at least these
places:

- `docs/RESEARCH-GATE-PROTOCOL-2026-05-07.md`: G4 minimum source-ledger row.
- `audits/universal/source-ledger-audit-20260507T193050Z.md`: source row plus
  claim-to-ledger acceptance matrix.
- `specs/universal/source-ledger-schema-20260507T204627Z.md`: canonical v1
  source rows, frozen BSEBench value rows, comparison rows, and claim binding
  ledger.
- `docs/BSEBENCH-PUBLIC-BENCHMARK-RELEASE-CHECKLIST-2026-05-07.md`: shorter
  release checklist field list.
- `docs/BSEBENCH-MONTHLY-SNAPSHOT-SCHEMA-2026-05-07.md` and its JSON Schema:
  `source_ledgers[]` only records ledger id, path, hash, retrieved_at, status,
  and caveat.
- `docs/universal/community-benchmark-report-outline-20260507T204627Z.md` and
  `gates/public-claims-redline-gate-20260507T213125Z.md`: report-line and
  public-prose binding requirements.

Risk: a future report could mark `source_ledgers[].status="complete"` in the
monthly snapshot schema while no canonical source rows, frozen BSEBench value
rows, comparison rows, and claim-binding ledger have passed review. The monthly
snapshot schema is useful for linking ledgers, but it is not itself the
source-ledger gate.

Required consolidation before alpha public prose:

- Declare `specs/universal/source-ledger-schema-20260507T204627Z.md` canonical
  for new source-ledger artifacts.
- Treat the release checklist and monthly snapshot schema as pointers/checklist
  views, not as alternate schemas.
- Normalize legacy aliases only during migration:
  `stable_url_or_doi` to `doi_or_url`, `retrieval_date` to `retrieved_at`,
  `bsebench_frozen_value` to `bsebench_value`, and `comparability_caveat` to
  `caveat`.
- Block `ledger_status=complete` unless the canonical ledger and the
  claim-binding ledger both validate.

### 4. Public-claim redline work is a design, not an executable gate.

The W5 redline gate is strong policy: it requires committed source ledgers,
claim-binding ledgers, frozen evidence ledgers, and protected-file diffs before
public comparison text can pass. But it is a Markdown design artifact. In the
current integration branch, the executable checker inspected here remains
`scripts/check-research-brief-gates.sh`, which is BRIEF-focused and
pattern-based.

Current executable gap:

- BRIEF gates can catch missing guardrail wording in queued tasks.
- Monthly snapshot JSON Schema can require snapshot-level caveat fields and a
  `source_ledgers[]` pointer.
- No inspected executable gate scans candidate public Markdown, release notes,
  README prose, tables, or captions and verifies line-level claim bindings
  against canonical source-ledger rows and frozen BSEBench values.

Publication impact: public comparison, ranking, release-summary, or
claim-promotion wording remains blocked until an executable report/text gate is
implemented or a manual GLASSBOX redline matrix is completed for the exact
candidate public text.

### 5. Some validation evidence is explicitly stale or log-derived.

The W4 async validation artifact is useful because it replays branch-head checks
instead of trusting logs alone. It records:

- Wave 1 async branches `phase-8-0-s` through `phase-8-0-x`: PASS from
  formatting/log/head perspective.
- Wave 2 `phase-8-1-o`: watchdog log said `git diff --check` passed, but branch
  replay found trailing whitespace at lines 3 and 4 of
  `audits/wave-1/integration-conflict-map-20260507T193050Z.md`.
- Wave 2 runner and dataset validators `phase-8-1-k` and `phase-8-1-m` were
  valid snapshots at their timestamp but stale after later branch heads
  appeared.

The W5 docs ledger now says it cleaned the `phase-8-1-o` whitespace when
integrating. That clears the current mechanical blocker, but it reinforces the
process rule: do not accept watchdog-log gate statements without fetched-branch
replay.

### 6. Protected-path and unsupported-claim scans need classification, not raw hit counting.

The W5 docs branch contains many literal guardrail terms in policy, fixtures,
audits, and negative controls. Raw grep hits for prohibited phrases are expected.
The inspected hits were guardrail text, disclaimers, stop conditions, or
redline examples. No changed-path scan against `HEAD...phase-8-4-d` found thesis,
manuscript, `claims/registry.yaml`, `claim_55`, roadmap, or scientific-roadmap
paths.

Merge impact: keep the protected-path scan as a hard gate. Treat phrase scans as
requiring classification and reject only unsupported public claims, not
defensive policy examples.

## Merge Blockers And Required Actions

| Severity | Blocker or risk | Required action |
| --- | --- | --- |
| BLOCKER for public comparison/claim prose | No completed canonical source ledger plus claim-binding ledger was inspected. | Keep public text neutral. Before any comparison or ranking text, provide canonical source-ledger rows, frozen BSEBench value rows, comparison rows, and claim bindings. |
| BLOCKER for public text automation | W5 public-claims redline gate is not executable. | Add a report/text scanner or require a manual line-level redline matrix for the candidate artifact. |
| BLOCKER if Wave 5 async validator signoff is required | `phase-8-4-h` is identical to current main and provides no validator artifact. | Do not count it as validation; request a real validator artifact or cite W4 validation plus W5 docs ledger explicitly. |
| HIGH | Duplicate ledger field names and status semantics can let partial evidence appear complete. | Canonicalize on the W4 source-ledger schema and demote monthly `source_ledgers[]` to a pointer/status view. |
| MEDIUM | Legacy broad `check-research-brief-gates.sh --all` debt can obscure new failures. | Use scoped/staged checks for new Wave 5 branches until legacy Phase 7 BRIEFs are remediated or excluded intentionally. |
| MEDIUM | Branch refs moved during inspection. | Pin exact SHAs and rerun `git diff --check`, protected-path scan, phrase classification, and relevant shell/schema checks immediately before merge. |

## Current Merge Recommendation

The current `phase-8-4-d` async docs integration branch is not blocked by the
earlier whitespace issue at sampled SHA `52a7b14`. It can proceed as a
report/docs/control-plane merge candidate after final SHA pinning and the usual
non-claim, protected-path, and whitespace gates.

It must not be used as public-release or public-comparison approval. The
integrated materials define several source-ledger and public-claims gates, but
they do not complete those gates for any external comparison or public report
line.

## Validation For This Artifact

Planned final local validation after writing this file:

```bash
git diff --check
```

Expected scope of changed files for this branch:

```text
redteam/wave5/async-docs-integration-redteam-20260507T213656Z.md
```

## Explicit Non-Claims

- This artifact does not state that BSEBench is state-of-the-art, novel,
  leaderboard-leading, a breakthrough, or externally verified.
- This artifact does not validate a SOC/SOH metric result, dataset license,
  source-ledger row, or claim registry decision.
- This artifact does not edit thesis files, manuscript files, claim registry
  files, `claims/registry.yaml`, `claim_55`, or the scientific roadmap.

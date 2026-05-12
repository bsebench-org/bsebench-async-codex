# BSEBench Governance v0.1

**Status** : Draft v0.1, shipped at M0 (2026-05-12) for Steering Committee
seating during M1–M5. Promoted to v1.0 at the M5 milestone alongside the
public release.
**Authoritative roadmap reference** : `bsebench-runner/docs/SSOT_BSEBENCH_ROADMAP_AUTHORITATIVE_2026-05-12.md`, foundation F7.
**Maintained on branch** : `demo-k` of `bsebench-async-codex` (Codex's `main` stays intact).
**Editorial owner** : the candidate, until the Steering Committee is seated; thereafter, the Committee itself, by 4-of-6 vote.

---

## 1. Mission

BSEBench is the protocol-layer single source of truth for battery
state-estimation algorithm comparison — the MLPerf of the battery field.
It is not a dataset registry with a leaderboard. It is a versioned set
of contracts (data, algorithms, statistics, reproducibility) indexed in
an immutable signed ledger, queryable by 6+ scientific axes, with
formal task contracts that prevent comparing algorithms answering
different questions.

The project is governed independently of any single laboratory,
employer, vendor, or candidate. The governance structure described
below exists so that BSEBench survives the candidate's defense and
graduation, and so that no single party can unilaterally promote a
non-compliant algorithm to the top of the leaderboard.

---

## 2. Steering Committee structure

The Steering Committee has **seven seats**. Six are voting seats; the
candidate seat is non-voting on conflict-of-interest matters
(see §6).

| # | Seat | Term | Notes |
|---|------|------|-------|
| 1 | Institutional — battery aging data (e.g., NASA PCoE) | 24 months, renewable | Invitation drafted at M0; awaiting Oussama's send |
| 2 | Institutional — battery characterization data (e.g., CALCE) | 24 months, renewable | Invitation drafted at M0 |
| 3 | Institutional — battery degradation modeling (e.g., Oxford / Imperial) | 24 months, renewable | Invitation drafted at M0 |
| 4 | Industry — OEM / cell maker | 18 months, renewable | To be scouted in M1–M2 |
| 5 | Industry — automotive BMS / embedded compute | 18 months, renewable | To be scouted in M1–M2 |
| 6 | Methods — statistics / ML benchmarking | 24 months, renewable | To be scouted in M2–M3 (post Skillings-Mack design review) |
| 7 | Candidate seat (ex officio) | Until defense, then rotates to a community-elected seat | Non-voting on matters where the candidate has a direct conflict |

**Vacant-seat policy**. The Committee is operational with **as few as
four filled seats** (a quorum of voting members). Empty seats are
documented openly on the project website and remain visibly empty
until filled — they are not silently filled by candidate appointees.

**Term lengths** are deliberately staggered so that the Committee
cannot turn over completely within any 12-month window.

---

## 3. Decision-making

| Decision type | Threshold | Notes |
|---|---|---|
| Routine releases (patch versions) | Candidate authority + 1 Committee reviewer | Documented in the RFC log |
| Minor releases (new datasets, new task contracts, schema bumps) | 3 of 6 voting members | Open RFC for 14 days |
| Breaking changes (schema majors, methodology pivots, leaderboard semantics) | 4 of 6 voting members | Open RFC for 28 days |
| Committee composition changes | 4 of 6 voting members | Vacant seat ≠ no vote |
| Code of Conduct enforcement | 3 of 6 voting members | Candidate excluded from vote |

The candidate retains veto power on changes that compromise the
candidate's thesis defense scope until the defense date; after the
defense, the candidate seat votes equally with any other seat.

---

## 4. RFC process

All non-routine changes proceed through a Request for Comments process:

1. **Proposal** in `bsebench-async-codex/rfcs/<NNNN>-<short-slug>.md` using
   the RFC template (template lands at M1 if not already present).
2. **Discussion period** : 14 days for minor changes, 28 days for
   breaking changes, counting from the merge of the proposal commit.
3. **Voting period** : 7 days following the discussion period.
   Votes are cast as inline edits to the RFC's `Votes` section signed
   with GPG (sigstore once the M5 signing chain ships).
4. **Decision recording** : a `Resolved` block is appended with the
   tally and a short rationale.
5. **Implementation** : a `Tracking PR` link is added once the change
   is merged on the relevant repository's `main` branch.

Rejected RFCs remain on file as audit trail. Re-proposing the same
change within 6 months requires the proposer to acknowledge the prior
rejection and explain what changed.

---

## 5. Sustainability plan

BSEBench is built by a PhD candidate but it is designed to outlive the
PhD. Three funding tracks are pursued in parallel:

### 5.1 GitHub Sponsors (immediate)
A GitHub Sponsors profile is opened at M0 alongside this governance
document. Donations are governed by `bsebench-async-codex/sponsors.md`
(lands at M5). Target : € 500 / month by month 12 post-v1.0 to cover
hosting + Zenodo DOI minting + one part-time community engineer.

### 5.2 Grant applications (months 0–12 post-v1.0)
Three grant tracks are scoped:

| Track | Programme | Timeline | Lead |
|---|---|---|---|
| US public | ARPA-E SCALEUP / OPEN call | Apply Q1/Q2 2027 | Steering Committee member (US-affiliated) |
| EU public | EU Battery 2030+ / Horizon Europe Cluster 5 | Apply Q3 2027 | Mme Rim + Committee member (EU-affiliated) |
| US/EU joint | DOE-VTO co-funded with ACEA / EUROBAT | Apply Q4 2027 | Industry-seat Committee member |

A grant application **does not require** all Committee seats to be
filled, but the application's authoring requires at least one
Committee member as co-author per Programme.

### 5.3 Industry consortium (months 12–24 post-v1.0)
A consortium tier is opened at month 12 post-v1.0 if (and only if)
≥ 3 industry contributors have submitted Closed Division entries.
Annual contribution : € 5 000 / OEM, € 1 500 / cell maker, € 0 / academic.
Consortium membership grants:
- Early access to benchmark suite drafts (pre-RFC),
- Right to nominate a candidate for an open industry seat.
Consortium membership **does not** grant any voting rights, ranking
preference, or sponsored placement on the leaderboard.

---

## 6. Conflict of interest

The Committee operates under a written conflict-of-interest policy
(lands at `bsebench-async-codex/conflict_of_interest.md` at M1):

- Any seat-holder employed by a vendor whose dataset, cycler, or
  algorithm is under RFC must recuse from the vote on that RFC.
- The candidate recuses from any RFC that materially affects the
  candidate's thesis chapters (defense scope).
- All recusals are logged in the RFC's `Resolved` block.
- Annual disclosure of affiliations is required from every seat-holder
  and published on the project website.

---

## 7. Adoption KPIs

The Committee evaluates BSEBench's health quarterly against four
adoption KPIs. KPIs reaching the **at-risk** threshold trigger an open
discussion at the next Committee meeting.

| KPI | Target at 12 months post-v1.0 | At-risk threshold |
|---|---|---|
| Peer-reviewed citations | ≥ 5 | < 2 |
| Closed Division submissions | ≥ 10 | < 3 |
| Distinct chemistries covered | ≥ 3 | < 2 |
| Dataset families with ≥ 1 grade-A or grade-B entry | ≥ 5 | < 2 |

These KPIs are deliberately modest because the v1.0 release framing is
honest about what BSEBench delivers : **30 datasets, mostly grade C**.
The honesty is a feature; KPIs are calibrated to that framing.

---

## 8. Code of conduct

The project follows the
[Contributor Covenant 2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
A copy is committed to each repository as `CODE_OF_CONDUCT.md`.
Enforcement decisions are recorded as Committee resolutions per §3.

Reporting channel : `conduct@bsebench.org` (forwarded to the Committee
chair). The chair rotates yearly among the voting non-candidate seats.

---

## 9. Candidate exit protocol

If the candidate steps down (defense completed, employment elsewhere,
loss of capacity), the following transfer steps are pre-agreed:

1. Within 30 days, the Committee chair publishes a `succession.md` RFC
   nominating an interim editorial owner (typically Mme Rim or a
   methods-seat member).
2. The candidate's commit credentials on every `bsebench-*` repository
   are downgraded to read-only. The community engineer (if funded by
   §5.1) becomes the day-to-day operator.
3. The candidate seat becomes a community-elected seat at the next
   Committee meeting.
4. All in-flight RFCs proceed under the existing rules; the candidate
   may still vote on RFCs filed before the exit date.

No change to the governance structure is required at the time of exit;
this section is the change.

---

## 10. Amendment process

This governance document is itself versioned. Amendments require:

- A `governance_amendment_v<n>` RFC,
- The full RFC voting procedure of §4,
- A signed-off `CHANGELOG.md` entry stating what changed and why,
- An automatic bump of the version string in the front matter of this file.

Silent edits are not permitted. The git history of `GOVERNANCE.md` on
the `demo-k` (and eventually `main`) branch is the audit trail.

---

*Drafted by Claude Opus 4.7 under candidate-led direction at M0
(2026-05-12). Not yet ratified — `claim_status: NO_CLAIM` until the
first Steering Committee meeting confirms adoption.*

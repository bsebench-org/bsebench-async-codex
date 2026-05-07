#!/usr/bin/env bash
set -u

usage() {
  cat <<'USAGE'
Usage: scripts/phase8-merge-gate-report.sh [options]

Report-only Phase 8 merge-gate inventory. The script inspects refs, diffs, and
guardrail signals. It never merges, rebases, pushes, approves, or rejects a
branch automatically.

Options:
  --base REF             Base ref for diff checks (default: origin/main)
  --branch REF           Inspect one branch/ref. Repeatable. Defaults to all
                         local/origin refs whose short name starts with phase-8-
  --add-dir LABEL=PATH   Also summarize a read-only git checkout. Repeatable.
  --dry-run              Explicit no-op alias for report mode.
  --report               Explicit report mode.
  --self-test            Run small shell self-test and exit.
  -h, --help             Show this help.
USAGE
}

BASE_REF="origin/main"
MODE="report"
BRANCH_ARGS=()
ADD_DIRS=()

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 2
}

git_in() {
  local repo=$1
  shift
  git -C "$repo" "$@"
}

is_protected_path() {
  case "$1" in
    thesis/*|*/thesis/*|manuscript/*|*/manuscript/*) return 0 ;;
    claims/registry.yaml|*/claims/registry.yaml) return 0 ;;
    *claim_55*|*RESEARCH-ROADMAP*) return 0 ;;
    *) return 1 ;;
  esac
}

branch_lane() {
  case "$1" in
    phase-8-0-[a-f]-*) printf 'runner-source' ;;
    phase-8-0-[g-l]-*) printf 'stats-source' ;;
    phase-8-0-[m-r]-*) printf 'datasets-source' ;;
    phase-8-0-[s-x]-*) printf 'async-control' ;;
    phase-8-1-*) printf 'wave-2-validator-audit' ;;
    phase-8-2-[jkl]-*) printf 'failed-placeholder-watch' ;;
    phase-8-2-*) printf 'wave-3-audit' ;;
    phase-8-3-[abc]-*) printf 'wave-4-retry' ;;
    phase-8-3-*) printf 'wave-4-support' ;;
    phase-8-4-*) printf 'wave-5-integration-hardening' ;;
    phase-8-5-*) printf 'wave-6-red-team' ;;
    phase-8-6-*) printf 'wave-7-alpha-readiness' ;;
    *) printf 'phase-8-other' ;;
  esac
}

self_test() {
  local failures=0

  [[ "$(branch_lane phase-8-0-a-universal-runner-estimator-plugin-contract)" == "runner-source" ]] || failures=$((failures + 1))
  [[ "$(branch_lane phase-8-0-l-universal-stats-transfer-matrix)" == "stats-source" ]] || failures=$((failures + 1))
  [[ "$(branch_lane phase-8-0-r-universal-datasets-monthly-availability)" == "datasets-source" ]] || failures=$((failures + 1))
  [[ "$(branch_lane phase-8-0-x-universal-async-no-idle-capacity-policy)" == "async-control" ]] || failures=$((failures + 1))
  [[ "$(branch_lane phase-8-2-k-merge-queue-runbook-20260507T193528Z)" == "failed-placeholder-watch" ]] || failures=$((failures + 1))

  is_protected_path "claims/registry.yaml" || failures=$((failures + 1))
  is_protected_path "docs/RESEARCH-ROADMAP-2026-05-06.md" || failures=$((failures + 1))
  if is_protected_path "validation/wave-7/merge-gate-controller-prototype-20260507.md"; then
    failures=$((failures + 1))
  fi

  if [[ "$failures" -ne 0 ]]; then
    printf 'SELF-TEST FAIL: %s checks failed\n' "$failures"
    return 1
  fi

  printf 'SELF-TEST PASS: branch lanes and protected-path classifier\n'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -ge 2 ]] || die "--base requires a ref"
      BASE_REF=$2
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || die "--branch requires a ref"
      BRANCH_ARGS+=("$2")
      shift 2
      ;;
    --add-dir)
      [[ $# -ge 2 ]] || die "--add-dir requires LABEL=PATH"
      ADD_DIRS+=("$2")
      shift 2
      ;;
    --dry-run|--report)
      MODE="report"
      shift
      ;;
    --self-test)
      self_test
      exit $?
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

repo_label() {
  local repo=$1
  local label=$2
  if [[ -n "$label" ]]; then
    printf '%s' "$label"
  else
    git_in "$repo" remote get-url origin 2>/dev/null || printf '%s' "$repo"
  fi
}

collect_branches() {
  local repo=$1
  if [[ "${#BRANCH_ARGS[@]}" -gt 0 ]]; then
    printf '%s\n' "${BRANCH_ARGS[@]}" | sed 's#^origin/##' | sort -u
    return
  fi

  git_in "$repo" for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin 2>/dev/null \
    | sed 's#^origin/##' \
    | grep -E '^phase-8-' \
    | grep -v '^HEAD$' \
    | sort -u
}

resolve_ref() {
  local repo=$1
  local branch=$2

  if git_in "$repo" rev-parse --verify --quiet "$branch^{commit}" >/dev/null; then
    printf '%s' "$branch"
    return 0
  fi

  if git_in "$repo" rev-parse --verify --quiet "origin/$branch^{commit}" >/dev/null; then
    printf 'origin/%s' "$branch"
    return 0
  fi

  return 1
}

ref_source() {
  local repo=$1
  local branch=$2
  local has_local=0
  local has_remote=0

  git_in "$repo" show-ref --verify --quiet "refs/heads/$branch" && has_local=1
  git_in "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch" && has_remote=1

  if [[ "$has_local" -eq 1 && "$has_remote" -eq 1 ]]; then
    printf 'local+origin'
  elif [[ "$has_local" -eq 1 ]]; then
    printf 'local-only'
  elif [[ "$has_remote" -eq 1 ]]; then
    printf 'origin-only'
  else
    printf 'missing'
  fi
}

count_lines() {
  if [[ -z "$1" ]]; then
    printf '0'
  else
    printf '%s\n' "$1" | sed '/^$/d' | wc -l | tr -d ' '
  fi
}

scan_branch() {
  local repo=$1
  local branch=$2
  local ref source lane head range counts ahead behind changed_files changed_count
  local diff_status protected_hits protected_count claim_hits claim_count evidence_files evidence_count
  local trailer_state report_state notes

  source=$(ref_source "$repo" "$branch")
  lane=$(branch_lane "$branch")

  if ! ref=$(resolve_ref "$repo" "$branch"); then
    printf '| `%s` | %s | missing | - | - | - | missing | Branch ref was not found locally or under `origin/`. |\n' "$branch" "$lane"
    return
  fi

  head=$(git_in "$repo" rev-parse --short=12 "$ref")
  range="$BASE_REF...$ref"
  notes=""

  if ! git_in "$repo" merge-base --is-ancestor "$(git_in "$repo" merge-base "$BASE_REF" "$ref" 2>/dev/null)" "$ref" 2>/dev/null; then
    notes="no merge-base with base; "
  fi

  counts=$(git_in "$repo" rev-list --left-right --count "$range" 2>/dev/null || printf 'NA NA')
  ahead=$(printf '%s' "$counts" | awk '{print $2}')
  behind=$(printf '%s' "$counts" | awk '{print $1}')

  changed_files=$(git_in "$repo" diff --name-only "$range" 2>/dev/null || true)
  changed_count=$(count_lines "$changed_files")

  if [[ "$changed_count" == "0" ]]; then
    diff_status="base-only"
  elif git_in "$repo" diff --check "$range" >/dev/null 2>&1; then
    diff_status="pass"
  else
    diff_status="fail"
  fi

  protected_hits=$(
    while IFS= read -r path; do
      [[ -n "$path" ]] || continue
      if is_protected_path "$path"; then
        printf '%s\n' "$path"
      fi
    done <<<"$changed_files"
  )
  protected_count=$(count_lines "$protected_hits")

  claim_hits=$(git_in "$repo" diff --unified=0 "$range" 2>/dev/null \
    | grep -E -i '^\+.*(SOTA|state[- ]of[- ]the[- ]art|leaderboard|breakthrough|verified scientific|verified claim|novelty|outperform|superior|best in the literature|universal-proven)' \
    | grep -v '^+++' || true)
  claim_count=$(count_lines "$claim_hits")

  evidence_files=$(printf '%s\n' "$changed_files" \
    | grep -E '^(validation|audits|dashboards|decisions|release|specs|pr|templates|docs|runbooks)/' || true)
  evidence_count=$(count_lines "$evidence_files")

  if git_in "$repo" log -1 --format=%B "$ref" | grep -q 'Co-Authored-By: Claude'; then
    trailer_state="fail"
  else
    trailer_state="pass"
  fi

  report_state="observed"
  if [[ "$source" == "missing" ]]; then
    report_state="missing"
  elif [[ "$diff_status" == "base-only" ]]; then
    report_state="base-only"
  elif [[ "$diff_status" == "fail" || "$protected_count" != "0" || "$trailer_state" == "fail" ]]; then
    report_state="blocked-by-local-scan"
  elif [[ "$claim_count" != "0" ]]; then
    report_state="needs-claim-context-review"
  else
    report_state="no-local-blocker-observed"
  fi

  case "$branch" in
    phase-8-2-[jkl]-*)
      report_state="failed-placeholder-watch"
      notes="${notes}original Wave 3 usage-limit placeholder per prior dashboard; use retry evidence if present; "
      ;;
  esac

  if [[ "$claim_count" != "0" ]]; then
    notes="${notes}claim-language hits require manual context review; "
  fi
  if [[ "$protected_count" != "0" ]]; then
    notes="${notes}protected path hits: $(printf '%s' "$protected_hits" | tr '\n' ',' | sed 's/,$//'); "
  fi

  printf '| `%s` | %s | %s | `%s` | +%s/-%s | %s | %s | files=%s evidence=%s protected=%s claim_review=%s trailer=%s %s|\n' \
    "$branch" "$lane" "$source" "$head" "$ahead" "$behind" "$diff_status" "$report_state" \
    "$changed_count" "$evidence_count" "$protected_count" "$claim_count" "$trailer_state" "$notes"
}

report_repo() {
  local repo=$1
  local label=$2
  local display branch_count

  [[ -d "$repo/.git" || -f "$repo/.git" ]] || die "not a git checkout: $repo"
  git_in "$repo" rev-parse --verify --quiet "$BASE_REF^{commit}" >/dev/null || die "base ref not found in $repo: $BASE_REF"

  display=$(repo_label "$repo" "$label")
  branch_count=$(collect_branches "$repo" | wc -l | tr -d ' ')

  printf '\n## Repository: %s\n\n' "$display"
  printf -- '- Path: `%s`\n' "$repo"
  printf -- '- Base ref: `%s` (`%s`)\n' "$BASE_REF" "$(git_in "$repo" rev-parse --short=12 "$BASE_REF")"
  printf -- '- Mode: `%s`; no merge/rebase/push action is performed.\n' "$MODE"
  printf -- '- Branch rows: `%s`\n\n' "$branch_count"

  printf '| Branch | Lane | Ref source | Head | Ahead/behind base | Diff check | Report state | Scan notes |\n'
  printf '| --- | --- | --- | --- | --- | --- | --- | --- |\n'
  while IFS= read -r branch; do
    [[ -n "$branch" ]] || continue
    scan_branch "$repo" "$branch"
  done < <(collect_branches "$repo")
}

main() {
  local root label path
  root=$(pwd)

  printf '# GLASSBOX Phase 8 Merge-Gate Report\n\n'
  printf 'Generated: `%s`\n\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'This is a local evidence summary for integration operators. It is not a merge decision, release approval, public benchmark claim, or scientific validation result.\n'

  report_repo "$root" "current"

  for entry in "${ADD_DIRS[@]}"; do
    label=${entry%%=*}
    path=${entry#*=}
    [[ "$label" != "$path" && -n "$label" && -n "$path" ]] || die "--add-dir must use LABEL=PATH"
    report_repo "$path" "$label"
  done

  cat <<'FOOTER'

## Operator Follow-Up

- Re-fetch and pin exact SHAs immediately before any real integration work.
- Treat `no-local-blocker-observed` as an inventory result only, not approval.
- Manually review every claim-language hit because guardrail examples can mention blocked terms.
- Stop and write a failure report if protected paths, `Co-Authored-By: Claude`, whitespace failures, missing refs, base-only refs, or stale placeholder branches appear in the branch being considered.
FOOTER
}

main

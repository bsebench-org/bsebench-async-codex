#!/usr/bin/env bash
# plan-disjoint-wave.sh - dry-run checker for high-parallel worker waves.
#
# The input is a TSV manifest with columns:
# worker_id phase_id target_repo target_branch write_set validation
#
# write_set is a semicolon- or comma-separated list of paths relative to the
# target repo. The helper reports same-repo overlap across entries and blocks
# protected research surfaces before the wave is queued.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/plan-disjoint-wave.sh --dry-run [--manifest PLAN.tsv]
  scripts/plan-disjoint-wave.sh --dry-run PLAN.tsv

Checks a proposed parallel worker wave for:
  - missing manifest fields;
  - protected write surfaces such as thesis, manuscript, claim registry,
    claim_55, and research roadmap paths;
  - same-repo write-set overlap between different phase entries.

The TSV manifest must have these columns:
  worker_id  phase_id  target_repo  target_branch  write_set  validation

write_set accepts semicolon or comma separators:
  scripts/plan.sh;docs/PLAN.md;tests/test-plan.sh

This helper is intentionally dry-run only. It never queues phases or writes repo
state.
USAGE
}

dry_run=0
manifest=""

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    --manifest)
      shift
      if [[ $# -eq 0 ]] ; then
        echo "Error: --manifest requires a path" >&2
        usage >&2
        exit 2
      fi
      manifest="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -n "$manifest" ]] ; then
        echo "Error: multiple manifest paths supplied: $manifest and $1" >&2
        usage >&2
        exit 2
      fi
      manifest="$1"
      ;;
  esac
  shift
done

if [[ "$dry_run" -ne 1 ]] ; then
  echo "Error: this helper only supports --dry-run" >&2
  usage >&2
  exit 2
fi

if [[ -z "$manifest" ]] ; then
  echo "Error: manifest path is required" >&2
  usage >&2
  exit 2
fi

if [[ ! -f "$manifest" ]] ; then
  echo "Error: manifest not found: $manifest" >&2
  exit 2
fi

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

normalize_repo() {
  local repo
  repo="$(trim "$1")"
  while [[ "$repo" == */ ]] ; do
    repo="${repo%/}"
  done
  printf '%s' "$repo"
}

normalize_path() {
  local path
  path="$(trim "$1")"
  path="${path//\\//}"
  while [[ "$path" == ./* ]] ; do
    path="${path#./}"
  done
  while [[ "$path" == *'//'* ]] ; do
    path="${path//\/\//\/}"
  done
  while [[ "$path" == */ && "$path" != "/" ]] ; do
    path="${path%/}"
  done
  printf '%s' "$path"
}

has_glob() {
  [[ "$1" == *'*'* || "$1" == *'?'* || "$1" == *'['* ]]
}

parent_or_same() {
  local parent="$1"
  local child="$2"
  [[ "$child" == "$parent" || "$child" == "$parent/"* ]]
}

static_prefix() {
  local pattern="$1"
  local prefix="$pattern"

  prefix="${prefix%%\**}"
  prefix="${prefix%%\?*}"
  prefix="${prefix%%\[*}"
  prefix="${prefix%/}"
  printf '%s' "$prefix"
}

path_overlap() {
  local left="$1"
  local right="$2"
  local left_prefix
  local right_prefix

  [[ "$left" == "$right" ]] && return 0

  if ! has_glob "$left" && ! has_glob "$right" ; then
    parent_or_same "$left" "$right" || parent_or_same "$right" "$left"
    return
  fi

  if has_glob "$left" && [[ "$right" == $left ]] ; then
    return 0
  fi
  if has_glob "$right" && [[ "$left" == $right ]] ; then
    return 0
  fi

  left_prefix="$(static_prefix "$left")"
  right_prefix="$(static_prefix "$right")"
  [[ -n "$left_prefix" && -n "$right_prefix" ]] || return 0
  parent_or_same "$left_prefix" "$right_prefix" || parent_or_same "$right_prefix" "$left_prefix"
}

protected_reason() {
  local path="$1"
  local lowered
  lowered="$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')"

  case "$lowered" in
    *thesis*)
      printf 'thesis path'
      return 0
      ;;
    *manuscript*)
      printf 'manuscript path'
      return 0
      ;;
    claims/registry.yaml|*/claims/registry.yaml|claims/registry*|*/claims/registry*|*claim-registry*|*claim_registry*)
      printf 'claim registry path'
      return 0
      ;;
    *claim_55*)
      printf 'claim_55 path'
      return 0
      ;;
    *research-roadmap*|*scientific-roadmap*)
      printf 'scientific roadmap path'
      return 0
      ;;
  esac

  return 1
}

failures=0
entry_count=0
write_count=0

declare -a entry_workers=()
declare -a entry_phases=()
declare -a entry_repos=()
declare -a entry_branches=()
declare -a entry_write_sets=()

declare -a item_workers=()
declare -a item_phases=()
declare -a item_repos=()
declare -a item_paths=()

add_failure() {
  printf '[FAIL] %s\n' "$*" >&2
  failures=$((failures + 1))
}

parse_write_set() {
  local worker="$1"
  local phase="$2"
  local repo="$3"
  local raw_write_set="$4"
  local write_list
  local item
  local normalized_item
  local reason
  local item_count=0

  write_list="${raw_write_set//,/;}"
  IFS=';' read -r -a write_items <<< "$write_list"

  for item in "${write_items[@]}" ; do
    normalized_item="$(normalize_path "$item")"
    [[ -n "$normalized_item" ]] || continue
    item_count=$((item_count + 1))

    case "$normalized_item" in
      .|/|'*'|'**')
        add_failure "$phase has unsafe broad write-set item: $normalized_item"
        ;;
      /*)
        add_failure "$phase write-set must be repo-relative, got: $normalized_item"
        ;;
      ../*|*/../*|*/..|..)
        add_failure "$phase write-set may not traverse parents, got: $normalized_item"
        ;;
    esac

    if reason="$(protected_reason "$normalized_item")" ; then
      add_failure "$phase targets protected $reason: $normalized_item"
    fi

    item_workers+=("$worker")
    item_phases+=("$phase")
    item_repos+=("$repo")
    item_paths+=("$normalized_item")
    write_count=$((write_count + 1))
  done

  if [[ "$item_count" -eq 0 ]] ; then
    add_failure "$phase has an empty write_set"
  fi
}

line_no=0
while IFS= read -r line || [[ -n "$line" ]] ; do
  line_no=$((line_no + 1))
  [[ -n "$(trim "$line")" ]] || continue
  [[ "$line" == \#* ]] && continue

  IFS=$'\t' read -r worker_id phase_id target_repo target_branch write_set validation extra <<< "$line"

  if [[ "$worker_id" == "worker_id" && "$phase_id" == "phase_id" ]] ; then
    continue
  fi

  if [[ -n "${extra:-}" ]] ; then
    add_failure "line $line_no has more than 6 TSV columns"
    continue
  fi

  worker_id="$(trim "${worker_id:-}")"
  phase_id="$(trim "${phase_id:-}")"
  target_repo="$(normalize_repo "${target_repo:-}")"
  target_branch="$(trim "${target_branch:-}")"
  write_set="$(trim "${write_set:-}")"
  validation="$(trim "${validation:-}")"

  [[ -n "$worker_id" ]] || add_failure "line $line_no missing worker_id"
  [[ -n "$phase_id" ]] || add_failure "line $line_no missing phase_id"
  [[ -n "$target_repo" ]] || add_failure "line $line_no missing target_repo"
  [[ -n "$target_branch" ]] || add_failure "line $line_no missing target_branch"
  [[ -n "$write_set" ]] || add_failure "line $line_no missing write_set"
  [[ -n "$validation" ]] || add_failure "line $line_no missing validation"

  if [[ -z "$worker_id" || -z "$phase_id" || -z "$target_repo" || -z "$target_branch" || -z "$write_set" ]] ; then
    continue
  fi

  entry_workers+=("$worker_id")
  entry_phases+=("$phase_id")
  entry_repos+=("$target_repo")
  entry_branches+=("$target_branch")
  entry_write_sets+=("$write_set")
  entry_count=$((entry_count + 1))

  parse_write_set "$worker_id" "$phase_id" "$target_repo" "$write_set"
done < "$manifest"

if [[ "$entry_count" -eq 0 ]] ; then
  add_failure "manifest contains no wave entries"
fi

for ((left = 0; left < ${#item_paths[@]}; left++)) ; do
  for ((right = left + 1; right < ${#item_paths[@]}; right++)) ; do
    [[ "${item_repos[$left]}" == "${item_repos[$right]}" ]] || continue
    [[ "${item_phases[$left]}" != "${item_phases[$right]}" ]] || continue

    if path_overlap "${item_paths[$left]}" "${item_paths[$right]}" ; then
      add_failure "WRITE-SET CONFLICT: ${item_repos[$left]} ${item_phases[$left]}:${item_paths[$left]} overlaps ${item_phases[$right]}:${item_paths[$right]}"
    fi
  done
done

echo "DRY-RUN: no phases queued and no files modified."
echo "Manifest: $manifest"
echo "Entries: $entry_count"
echo "Write-set items: $write_count"
echo

if [[ "$entry_count" -gt 0 ]] ; then
  echo "Wave entries:"
  for ((idx = 0; idx < ${#entry_phases[@]}; idx++)) ; do
    printf '  - worker=%s phase=%s repo=%s branch=%s write_set=%s\n' \
      "${entry_workers[$idx]}" \
      "${entry_phases[$idx]}" \
      "${entry_repos[$idx]}" \
      "${entry_branches[$idx]}" \
      "${entry_write_sets[$idx]}"
  done
  echo
fi

if [[ "$failures" -gt 0 ]] ; then
  echo "[FAIL] disjoint wave plan rejected: $failures issue(s)." >&2
  exit 1
fi

echo "[OK] disjoint wave plan accepted: $entry_count entries, $write_count write-set item(s)."

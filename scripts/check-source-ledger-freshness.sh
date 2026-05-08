#!/usr/bin/env bash
# check-source-ledger-freshness.sh - validate source-ledger rows for comparison gates.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-source-ledger-freshness.sh [--today YYYY-MM-DD] [--max-age-days N] LEDGER.json [...]

Validates JSON source-ledger rows for future SOTA/novelty comparison work.
Rows are classified as comparable, partial, not_comparable, stale, or invalid.

Each row must include a stable URL or DOI, retrieval date, method, exact metric,
dataset, split, preprocessing/run condition, reported value, frozen BSEBench
value, comparability class, and caveat. Alias fields from older ledger drafts
are accepted, but missing, placeholder, malformed, future-dated, stale, or
overstated comparable rows make the checker exit non-zero.
USAGE
}

today="$(date -u +%F)"
max_age_days=365
files=()

while [[ $# -gt 0 ]] ; do
  case "$1" in
    --today)
      today="${2:-}"
      shift
      ;;
    --max-age-days)
      max_age_days="${2:-}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]] ; do
        files+=("$1")
        shift
      done
      break
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      files+=("$1")
      ;;
  esac
  shift
done

if ! command -v jq >/dev/null 2>&1 ; then
  echo "Error: jq is required for source-ledger freshness checks." >&2
  exit 2
fi

if [[ ${#files[@]} -eq 0 ]] ; then
  usage >&2
  exit 2
fi

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

canonical_date() {
  local value="$1"

  [[ "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || return 1
  local normalized
  normalized="$(date -u -d "$value" +%F 2>/dev/null)" || return 1
  [[ "$normalized" == "$value" ]] || return 1
  printf '%s' "$normalized"
}

if ! canonical_date "$today" >/dev/null ; then
  echo "Error: --today must be a real YYYY-MM-DD date: $today" >&2
  exit 2
fi
if [[ ! "$max_age_days" =~ ^[0-9]+$ || "$max_age_days" -eq 0 ]] ; then
  echo "Error: --max-age-days must be a positive integer." >&2
  exit 2
fi

cutoff_date="$(date -u -d "$today - $max_age_days days" +%F)"

entry_query='
  if type != "object" then
    []
  elif (.source_ledger? | type) == "object" then
    (.source_ledger.entries // .source_ledger.source_rows // .source_ledger.sources // [])
  else
    (.entries // .source_rows // .sources // [])
  end
'

field_value() {
  local row="$1"
  shift
  local field

  for field in "$@" ; do
    if jq -e --arg field "$field" 'type == "object" and has($field) and .[$field] != null' <<<"$row" >/dev/null ; then
      jq -r --arg field "$field" '.[$field] | if type == "array" or type == "object" then tojson else tostring end' <<<"$row"
      return 0
    fi
  done
  return 1
}

field_present_nonblank() {
  local row="$1"
  shift
  local value

  if ! value="$(field_value "$row" "$@")" ; then
    return 1
  fi
  value="$(trim "$value")"
  [[ -n "$value" ]] || return 1
  [[ "$value" != \<* ]] || return 1
  return 0
}

is_placeholder() {
  local value lower
  value="$(trim "$1")"
  lower="${value,,}"

  [[ -z "$value" ]] && return 0
  [[ "$value" == \<* ]] && return 0
  [[ "$lower" =~ ^(todo|tbd|fixme|unknown|not_stated|not[[:space:]_-]*stated|not_reported|not[[:space:]_-]*reported|n/a|null|none|\.\.\.)$ ]]
}

is_unknown_but_declared() {
  local value lower
  value="$(trim "$1")"
  lower="${value,,}"

  [[ "$lower" =~ ^(unknown|not_stated|not[[:space:]_-]*stated|not_reported|not[[:space:]_-]*reported|n/a|null|\.\.\.)$ ]]
}

required_field_is_valid() {
  local row="$1"
  shift
  local value

  field_present_nonblank "$row" "$@" || return 1
  value="$(field_value "$row" "$@")"
  ! is_placeholder "$value"
}

normalize_comparability() {
  local value lower
  value="$(trim "$1")"
  lower="${value,,}"
  lower="${lower//-/_}"
  lower="${lower// /_}"
  printf '%s' "$lower"
}

stable_identifier_is_valid() {
  local value
  value="$(trim "$1")"

  [[ "$value" =~ ^https?://[^[:space:]]+$ ]] && return 0
  [[ "$value" =~ ^doi:10\.[0-9]{4,9}/[^[:space:]]+$ ]] && return 0
  [[ "$value" =~ ^10\.[0-9]{4,9}/[^[:space:]]+$ ]] && return 0
  return 1
}

caveat_is_concrete_for_limited_row() {
  local value lower
  value="$(trim "$1")"
  lower="${value,,}"

  [[ -n "$value" ]] || return 1
  [[ "$value" != \<* ]] || return 1
  [[ ! "$lower" =~ ^(none|n/a|unknown|not_stated|not[[:space:]_-]*stated|todo|tbd|fixme|null|\.\.\.)$ ]]
}

total_files=0
total_entries=0
total_comparable=0
total_partial=0
total_not_comparable=0
total_stale=0
total_invalid=0
failures=0

for file in "${files[@]}" ; do
  file_entries=0
  file_comparable=0
  file_partial=0
  file_not_comparable=0
  file_stale=0
  file_invalid=0

  if [[ ! -f "$file" ]] ; then
    echo "[FAIL] $file"
    echo "  [INVALID] ledger invalid: file does not exist"
    failures=$((failures + 1))
    total_invalid=$((total_invalid + 1))
    continue
  fi

  if ! jq empty "$file" >/dev/null ; then
    echo "[FAIL] $file"
    echo "  [INVALID] ledger invalid: invalid JSON"
    failures=$((failures + 1))
    total_invalid=$((total_invalid + 1))
    continue
  fi

  entry_count="$(jq -r "$entry_query | length" "$file")"
  if [[ "$entry_count" -eq 0 ]] ; then
    echo "[FAIL] $file"
    echo "  [INVALID] ledger invalid: no source-ledger entries"
    failures=$((failures + 1))
    total_invalid=$((total_invalid + 1))
    continue
  fi

  echo "[CHECK] $file"
  while IFS= read -r entry ; do
    idx="$(jq -r '.idx' <<<"$entry")"
    row="$(jq -c '.row' <<<"$entry")"
    source_id="$(field_value "$row" source_id id 2>/dev/null || true)"
    source_id="$(trim "${source_id:-row-$idx}")"
    [[ -n "$source_id" ]] || source_id="row-$idx"
    row_errors=()

    required_field_is_valid "$row" source_id id || row_errors+=("source_id")
    required_field_is_valid "$row" stable_url_or_doi doi_or_url doi url || row_errors+=("stable_url_or_doi")
    required_field_is_valid "$row" retrieval_date retrieved_at retrieved_date source_retrieved_at || row_errors+=("retrieval_date")
    required_field_is_valid "$row" method method_name model estimator baseline || row_errors+=("method")
    required_field_is_valid "$row" metric exact_metric || row_errors+=("metric")
    required_field_is_valid "$row" dataset source_dataset || row_errors+=("dataset")
    required_field_is_valid "$row" split source_split evaluation_split validation_protocol || row_errors+=("split")
    required_field_is_valid "$row" reported_value external_value claimed_number source_value || row_errors+=("reported_value")
    required_field_is_valid "$row" bsebench_frozen_value frozen_bsebench_value bsebench_value || row_errors+=("bsebench_frozen_value")
    field_present_nonblank "$row" comparability comparability_class comparison_class || row_errors+=("comparability")
    field_present_nonblank "$row" comparability_caveat caveat || row_errors+=("comparability_caveat")
    field_present_nonblank "$row" preprocessing_or_run_condition preprocessing_run_condition preprocessing run_condition source_preprocessing || row_errors+=("preprocessing_or_run_condition")

    stable_url_or_doi="$(field_value "$row" stable_url_or_doi doi_or_url doi url 2>/dev/null || true)"
    stable_url_or_doi="$(trim "$stable_url_or_doi")"
    if [[ ! " ${row_errors[*]} " =~ " stable_url_or_doi " ]] && ! stable_identifier_is_valid "$stable_url_or_doi" ; then
      row_errors+=("stable_url_or_doi_format")
    fi

    retrieval_date="$(field_value "$row" retrieval_date retrieved_at retrieved_date source_retrieved_at 2>/dev/null || true)"
    retrieval_date="$(trim "$retrieval_date")"
    retrieval_date_valid=0
    if [[ ! " ${row_errors[*]} " =~ " retrieval_date " ]] ; then
      if canonical_date "$retrieval_date" >/dev/null ; then
        retrieval_date_valid=1
        if [[ "$retrieval_date" > "$today" ]] ; then
          row_errors+=("future_retrieval_date")
        fi
      else
        row_errors+=("retrieval_date_format")
      fi
    fi

    comparability_raw="$(field_value "$row" comparability comparability_class comparison_class 2>/dev/null || true)"
    comparability="$(normalize_comparability "$comparability_raw")"
    if [[ ! " ${row_errors[*]} " =~ " comparability " ]] ; then
      case "$comparability" in
        comparable|partial|not_comparable)
          ;;
        *)
          row_errors+=("comparability_value")
          ;;
      esac
    fi

    caveat="$(field_value "$row" comparability_caveat caveat 2>/dev/null || true)"
    caveat="$(trim "$caveat")"
    if [[ ! " ${row_errors[*]} " =~ " comparability_caveat " ]] ; then
      case "$comparability" in
        partial|not_comparable)
          caveat_is_concrete_for_limited_row "$caveat" || row_errors+=("comparability_caveat_concrete")
          ;;
      esac
    fi

    preprocessing_value="$(field_value "$row" preprocessing_or_run_condition preprocessing_run_condition preprocessing run_condition source_preprocessing 2>/dev/null || true)"
    preprocessing_value="$(trim "$preprocessing_value")"
    if [[ ! " ${row_errors[*]} " =~ " preprocessing_or_run_condition " ]] && [[ "$comparability" == "comparable" ]] ; then
      if is_unknown_but_declared "$preprocessing_value" ; then
        row_errors+=("comparable_unknown_preprocessing_or_run_condition")
      fi
    fi

    if [[ "${#row_errors[@]}" -gt 0 ]] ; then
      echo "  [INVALID] row[$idx] source_id=$source_id class=invalid missing_or_invalid=${row_errors[*]}"
      file_invalid=$((file_invalid + 1))
      failures=$((failures + 1))
      continue
    fi

    if [[ "$retrieval_date_valid" -eq 1 && "$retrieval_date" < "$cutoff_date" ]] ; then
      echo "  [STALE] row[$idx] source_id=$source_id class=stale retrieval_date=$retrieval_date cutoff_date=$cutoff_date max_age_days=$max_age_days"
      file_stale=$((file_stale + 1))
      failures=$((failures + 1))
      continue
    fi

    case "$comparability" in
      comparable)
        file_comparable=$((file_comparable + 1))
        echo "  [COMPARABLE] row[$idx] source_id=$source_id class=comparable retrieval_date=$retrieval_date"
        ;;
      partial)
        file_partial=$((file_partial + 1))
        echo "  [PARTIAL] row[$idx] source_id=$source_id class=partial retrieval_date=$retrieval_date"
        ;;
      not_comparable)
        file_not_comparable=$((file_not_comparable + 1))
        echo "  [NOT_COMPARABLE] row[$idx] source_id=$source_id class=not_comparable retrieval_date=$retrieval_date"
        ;;
    esac
  done < <(jq -c "$entry_query | to_entries[] | {idx: .key, row: .value}" "$file")

  file_entries="$entry_count"
  total_files=$((total_files + 1))
  total_entries=$((total_entries + file_entries))
  total_comparable=$((total_comparable + file_comparable))
  total_partial=$((total_partial + file_partial))
  total_not_comparable=$((total_not_comparable + file_not_comparable))
  total_stale=$((total_stale + file_stale))
  total_invalid=$((total_invalid + file_invalid))

  echo "[SUMMARY] $file entries=$file_entries comparable=$file_comparable partial=$file_partial not_comparable=$file_not_comparable stale=$file_stale invalid=$file_invalid"
done

if [[ "$failures" -gt 0 ]] ; then
  echo "Source-ledger freshness checks failed: files=$total_files entries=$total_entries comparable=$total_comparable partial=$total_partial not_comparable=$total_not_comparable stale=$total_stale invalid=$total_invalid failure(s)=$failures" >&2
  exit 1
fi

echo "Source-ledger freshness checks passed: files=$total_files entries=$total_entries comparable=$total_comparable partial=$total_partial not_comparable=$total_not_comparable stale=$total_stale invalid=$total_invalid"

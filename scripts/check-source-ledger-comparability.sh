#!/usr/bin/env bash
# check-source-ledger-comparability.sh - validate source-ledger comparison rows.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scripts/check-source-ledger-comparability.sh LEDGER.json [...]

Validates JSON source-ledger rows for future SOTA/novelty comparison work.

Each row must include:
  stable_url_or_doi, retrieval_date, metric, dataset, split, method,
  reported_value, bsebench_frozen_value, comparability, comparability_caveat.

Rows with missing, blank, placeholder, or malformed required fields are marked
INCOMPLETE and make the checker exit non-zero. Complete rows are counted as
comparable, partial, or not_comparable.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] ; then
  usage
  exit 0
fi

if ! command -v jq >/dev/null 2>&1 ; then
  echo "Error: jq is required for source-ledger comparability checks." >&2
  exit 2
fi

if [[ $# -eq 0 ]] ; then
  usage >&2
  exit 2
fi

files=("$@")

required_fields=(
  stable_url_or_doi
  retrieval_date
  metric
  dataset
  split
  method
  reported_value
  bsebench_frozen_value
  comparability
  comparability_caveat
)

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

field_text() {
  local row="$1"
  local field="$2"
  jq -r --arg field "$field" 'if type == "object" then (.[$field] // "" | tostring) else "" end' <<<"$row"
}

field_is_missing_or_placeholder() {
  local row="$1"
  local field="$2"
  local value lower

  if ! jq -e --arg field "$field" 'type == "object" and has($field) and .[$field] != null' <<<"$row" >/dev/null ; then
    return 0
  fi

  value="$(trim "$(field_text "$row" "$field")")"
  lower="${value,,}"

  [[ -z "$value" ]] && return 0
  [[ "$lower" =~ ^(todo|tbd|fixme|unknown|not_stated|not[[:space:]_-]*stated|n/a|null|none|\.\.\.)$ ]] && return 0
  [[ "$value" == \<* ]] && return 0
  return 1
}

entry_query='
  if type != "object" then
    []
  elif (.source_ledger? | type) == "object" then
    (.source_ledger.entries // [])
  else
    (.entries // [])
  end
'

total_files=0
total_entries=0
total_comparable=0
total_partial=0
total_not_comparable=0
total_incomplete=0
failures=0

for file in "${files[@]}" ; do
  file_comparable=0
  file_partial=0
  file_not_comparable=0
  file_incomplete=0
  file_entries=0

  if [[ ! -f "$file" ]] ; then
    echo "[FAIL] $file"
    echo "  [INCOMPLETE] comparison incomplete: file does not exist"
    failures=$((failures + 1))
    total_incomplete=$((total_incomplete + 1))
    continue
  fi

  if ! jq empty "$file" >/dev/null ; then
    echo "[FAIL] $file"
    echo "  [INCOMPLETE] comparison incomplete: invalid JSON"
    failures=$((failures + 1))
    total_incomplete=$((total_incomplete + 1))
    continue
  fi

  entry_count="$(jq -r "$entry_query | length" "$file")"
  if [[ "$entry_count" -eq 0 ]] ; then
    echo "[FAIL] $file"
    echo "  [INCOMPLETE] comparison incomplete: no source-ledger entries"
    failures=$((failures + 1))
    total_incomplete=$((total_incomplete + 1))
    continue
  fi

  echo "[CHECK] $file"
  while IFS= read -r entry ; do
    idx="$(jq -r '.idx' <<<"$entry")"
    row="$(jq -c '.row' <<<"$entry")"
    source_id="$(field_text "$row" source_id)"
    source_id="${source_id:-row-$idx}"
    row_errors=()

    for field in "${required_fields[@]}" ; do
      if field_is_missing_or_placeholder "$row" "$field" ; then
        row_errors+=("$field")
      fi
    done

    if [[ ! " ${row_errors[*]} " =~ " stable_url_or_doi " ]] ; then
      stable_url_or_doi="$(trim "$(field_text "$row" stable_url_or_doi)")"
      if [[ ! "$stable_url_or_doi" =~ ^(https?://[^[:space:]]+|doi:10\.[^[:space:]]+|10\.[^[:space:]]+) ]] ; then
        row_errors+=("stable_url_or_doi_format")
      fi
    fi

    if [[ ! " ${row_errors[*]} " =~ " retrieval_date " ]] ; then
      retrieval_date="$(trim "$(field_text "$row" retrieval_date)")"
      if [[ ! "$retrieval_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ; then
        row_errors+=("retrieval_date_format")
      fi
    fi

    comparability_raw="$(trim "$(field_text "$row" comparability)")"
    comparability="${comparability_raw,,}"
    comparability="${comparability//-/_}"
    if [[ ! " ${row_errors[*]} " =~ " comparability " ]] ; then
      case "$comparability" in
        comparable|partial|not_comparable)
          ;;
        *)
          row_errors+=("comparability_value")
          ;;
      esac
    fi

    if [[ "${#row_errors[@]}" -gt 0 ]] ; then
      echo "  [INCOMPLETE] row[$idx] source_id=$source_id comparison incomplete: missing_or_invalid=${row_errors[*]}"
      file_incomplete=$((file_incomplete + 1))
      failures=$((failures + 1))
      continue
    fi

    case "$comparability" in
      comparable)
        file_comparable=$((file_comparable + 1))
        ;;
      partial)
        file_partial=$((file_partial + 1))
        ;;
      not_comparable)
        file_not_comparable=$((file_not_comparable + 1))
        ;;
    esac
    echo "  [OK] row[$idx] source_id=$source_id comparability=$comparability"
  done < <(jq -c "$entry_query | to_entries[] | {idx: .key, row: .value}" "$file")

  file_entries=$entry_count
  total_files=$((total_files + 1))
  total_entries=$((total_entries + file_entries))
  total_comparable=$((total_comparable + file_comparable))
  total_partial=$((total_partial + file_partial))
  total_not_comparable=$((total_not_comparable + file_not_comparable))
  total_incomplete=$((total_incomplete + file_incomplete))

  echo "[SUMMARY] $file entries=$file_entries comparable=$file_comparable partial=$file_partial not_comparable=$file_not_comparable incomplete=$file_incomplete"
done

if [[ "$failures" -gt 0 ]] ; then
  echo "Source-ledger comparability checks failed: files=$total_files entries=$total_entries comparable=$total_comparable partial=$total_partial not_comparable=$total_not_comparable incomplete=$total_incomplete failure(s)=$failures" >&2
  exit 1
fi

echo "Source-ledger comparability checks passed: files=$total_files entries=$total_entries comparable=$total_comparable partial=$total_partial not_comparable=$total_not_comparable incomplete=$total_incomplete"

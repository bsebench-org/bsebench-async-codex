#!/usr/bin/env bash
# probe-phase9-11-acceptance-gate.sh - fixture checks for Phase 9/10/11 acceptance gate.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHECKER="$SCRIPT_DIR/check-phase9-11-acceptance-gate.py"

tmp_root=$(mktemp -d)
trap 'rm -rf "$tmp_root"' EXIT

passes=0

write_fixture() {
  local path="$1"
  local scientific_status="$2"
  local closure="$3"

  python3 - "$path" "$scientific_status" "$closure" <<'PY'
import json
import sys

path, scientific_status, closure = sys.argv[1:4]
closure_bool = closure == "true"

def evidence(status, name):
    return {
        "status": status,
        "evidence": {
            "artifact": f"artifacts/{name}.json",
            "branch": f"phase9-11-{name}",
            "command": f"validate {name}",
            "commit": "0123456789abcdef",
        },
    }

doc = {
    "phase_scope": ["phase9", "phase10", "phase11"],
    "guardrails": {
        "hf_uploads": 0,
        "dataset_downloads": 0,
        "thesis_edits": False,
        "roadmap_edits": False,
        "claim_registry_edits": False,
        "claim55_edits": False,
    },
    "phases": {},
}

for phase in ("9", "10", "11"):
    doc["phases"][f"phase{phase}"] = {
        "scientific_closure": closure_bool,
        "tooling": {
            "schema_or_contract": evidence("passed", f"p{phase}-schema"),
            "scheduler_or_validator": evidence("passed", f"p{phase}-scheduler"),
            "validation": evidence("passed", f"p{phase}-validation"),
        },
        "scientific": {
            "cache": evidence(scientific_status, f"p{phase}-cache"),
            "provenance": evidence(scientific_status, f"p{phase}-provenance"),
            "tier2": evidence(scientific_status, f"p{phase}-tier2"),
            "source_ledger": evidence(scientific_status, f"p{phase}-source-ledger"),
            "empirical_run": evidence(scientific_status, f"p{phase}-empirical-run"),
        },
    }

json.dump(doc, open(path, "w", encoding="utf-8"), indent=2, sort_keys=True)
PY
}

require_success_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output

  if ! output="$("$@")" ; then
    echo "FAIL: $name expected success" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<< "$output" ; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

require_failure_contains() {
  local name="$1"
  local needle="$2"
  shift 2
  local output
  local status=0

  output="$("$@" 2>&1)" || status=$?
  if [[ "$status" -eq 0 ]] ; then
    echo "FAIL: $name expected failure" >&2
    echo "$output" >&2
    exit 1
  fi
  if ! grep -Fq "$needle" <<< "$output" ; then
    echo "FAIL: $name missing output: $needle" >&2
    echo "$output" >&2
    exit 1
  fi
  echo "PASS: $name"
  passes=$((passes + 1))
}

tooling_only() {
  local file="$tmp_root/tooling-only.json"
  write_fixture "$file" "missing" "false"
  python3 "$CHECKER" --allow-tooling-only "$file"
}

scientific_required() {
  local file="$tmp_root/scientific-required.json"
  write_fixture "$file" "missing" "false"
  python3 "$CHECKER" "$file"
}

unsupported_closure() {
  local file="$tmp_root/unsupported-closure.json"
  write_fixture "$file" "missing" "true"
  python3 "$CHECKER" --allow-tooling-only "$file"
}

full_scientific() {
  local file="$tmp_root/full-scientific.json"
  write_fixture "$file" "passed" "false"
  python3 "$CHECKER" "$file"
}

out_of_scope_phase() {
  local file="$tmp_root/out-of-scope.json"
  write_fixture "$file" "passed" "false"
  python3 - "$file" <<'PY'
import json
import sys

path = sys.argv[1]
doc = json.load(open(path, encoding="utf-8"))
doc["phase_scope"].append("phase12")
doc["phases"]["phase12"] = {"tooling": {}, "scientific": {}}
json.dump(doc, open(path, "w", encoding="utf-8"), indent=2, sort_keys=True)
PY
  python3 "$CHECKER" "$file"
}

upload_guard() {
  local file="$tmp_root/upload-guard.json"
  write_fixture "$file" "passed" "false"
  python3 - "$file" <<'PY'
import json
import sys

path = sys.argv[1]
doc = json.load(open(path, encoding="utf-8"))
doc["guardrails"]["hf_uploads"] = 1
json.dump(doc, open(path, "w", encoding="utf-8"), indent=2, sort_keys=True)
PY
  python3 "$CHECKER" "$file"
}

require_success_contains \
  "tooling-only mode permits tooling gate without scientific closure" \
  '"scientific_status": "NO_GO_CLAIM"' \
  tooling_only

require_failure_contains \
  "default mode fails closed on missing scientific evidence" \
  "phase9.scientific.cache" \
  scientific_required

require_failure_contains \
  "tooling-only mode rejects unsupported scientific closure" \
  "declares scientific closure without complete evidence gates" \
  unsupported_closure

require_success_contains \
  "full scientific evidence passes default mode" \
  '"scientific_status": "GO_CLAIM"' \
  full_scientific

require_failure_contains \
  "later phases are rejected" \
  "out-of-scope phase present: phase12" \
  out_of_scope_phase

require_failure_contains \
  "upload guard must be zero" \
  "guardrails.hf_uploads must be 0" \
  upload_guard

echo "PASS: Phase 9/10/11 acceptance gate fixtures passed ($passes checks)."

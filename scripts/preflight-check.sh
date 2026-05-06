#!/usr/bin/env bash
# preflight-check.sh — verify all worker dependencies are present.
# Run once on the remote PC before registering the worker.
#
# Path detection : auto-resolves the bsebench-org repo root based on
# the runtime (WSL2, Git Bash on Windows, native Linux/macOS). Override
# with BSEBENCH_REPO_ROOT env var if your layout differs.

set -uo pipefail

echo "=== bsebench-async-codex worker preflight ==="
echo "Date : $(date -Iseconds)"
echo "OS   : $(uname -s) $(uname -r 2>/dev/null || true)"

# Detect runtime + canonical repo root
if [[ -n "${BSEBENCH_REPO_ROOT:-}" ]] ; then
  REPO_ROOT="$BSEBENCH_REPO_ROOT"
  RUNTIME_KIND="custom (BSEBENCH_REPO_ROOT)"
elif grep -qi microsoft /proc/version 2>/dev/null ; then
  REPO_ROOT="/mnt/c/doctorat/bsebench-org"
  RUNTIME_KIND="WSL2"
elif [[ "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]] ; then
  REPO_ROOT="/c/doctorat/bsebench-org"
  RUNTIME_KIND="Git Bash (Windows)"
else
  REPO_ROOT="$HOME/bsebench-org"
  RUNTIME_KIND="native Linux/macOS"
fi
echo "Runtime : $RUNTIME_KIND"
echo "Repo root checked : $REPO_ROOT"
echo

ok=0
fail=0

check() {
  local name="$1"
  local cmd="$2"
  local hint="${3:-}"
  if eval "$cmd" >/dev/null 2>&1 ; then
    echo "  [OK]   $name"
    ok=$((ok + 1))
  else
    echo "  [FAIL] $name"
    [[ -n "$hint" ]] && echo "         hint : $hint"
    fail=$((fail + 1))
  fi
}

echo "Binaries on PATH :"
check "git"        "git --version"
check "bash"       "bash --version"
check "jq"         "jq --version"           "Windows : reinstall Git for Windows ≥ 2.40 (bundles jq)"
check "flock"      "command -v flock"       "Windows : reinstall Git for Windows ≥ 2.40 (bundles util-linux flock)"
check "timeout"    "command -v timeout"     "Windows : reinstall Git for Windows ≥ 2.40 (bundles GNU coreutils timeout)"
check "node"       "node --version"
check "npm"        "npm --version"
check "codex"      "codex --version"        "npm install -g @openai/codex@0.129.0-alpha.7"
check "curl"       "curl --version"
check "awk"        "awk --version"
echo

echo "Codex sandbox canary :"
canary_dir="/tmp/codex-preflight-canary-$$"
mkdir -p "$canary_dir"
if codex exec --dangerously-bypass-approvals-and-sandbox -C "$canary_dir" \
     "Create canary.txt with text 'preflight ok'. Use apply_patch." \
     < /dev/null > /dev/null 2>&1 && [[ -f "$canary_dir/canary.txt" ]] ; then
  echo "  [OK]   codex bypass-flag write works"
  ok=$((ok + 1))
else
  echo "  [FAIL] codex bypass-flag write"
  echo "         hint : check codex login + ~/.codex/config.toml has ask_for_approval=\"never\""
  fail=$((fail + 1))
fi
rm -rf "$canary_dir"
echo

echo "Git config :"
gun=$(git config --global user.name 2>/dev/null || echo "")
gue=$(git config --global user.email 2>/dev/null || echo "")
if [[ -n "$gun" && -n "$gue" ]] ; then
  echo "  [OK]   user.name  = $gun"
  echo "  [OK]   user.email = $gue"
  ok=$((ok + 2))
else
  echo "  [FAIL] git user.name and user.email not configured"
  echo "         git config --global user.name 'Your Name'"
  echo "         git config --global user.email 'you@example.com'"
  fail=$((fail + 2))
fi
echo

echo "Repo presence (under $REPO_ROOT) :"
for r in bsebench-datasets bsebench-async-codex ; do
  if [[ -d "$REPO_ROOT/$r/.git" ]] ; then
    echo "  [OK]   $r"
    ok=$((ok + 1))
  else
    echo "  [FAIL] $r not cloned at $REPO_ROOT/$r"
    fail=$((fail + 1))
  fi
done
echo

echo "=== summary : $ok ok, $fail fail ==="
if [[ $fail -gt 0 ]] ; then
  echo "Resolve the failures above before registering the worker."
  exit 1
fi
echo "All checks passed. Safe to proceed with onboarding (step 4)."
exit 0

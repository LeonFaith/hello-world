#!/usr/bin/env bash
# Regression tests for commit-message-writer's scripts/staged_summary.sh.
# No model calls: runs the script in throwaway git repos and checks its output.
#
# Usage: test_staged_summary.sh <skill-folder>
# Exit code: 0 = all tests passed, 1 = at least one failed.
set -u
skill="$(cd "${1:?usage: test_staged_summary.sh <skill-folder>}" && pwd)"
script="$skill/scripts/staged_summary.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fails=0

new_repo() {
  local d="$tmp/$1"
  mkdir -p "$d" && cd "$d" || exit 1
  git init -q && git config user.email t@example.com && git config user.name Test
  echo base > base.txt && git add base.txt && git commit -qm "chore: init"
}

check() { # name, expected exit, actual exit, output file, grep patterns...
  local name="$1" want="$2" got="$3" out="$4"; shift 4
  local ok=1
  [ "$got" = "$want" ] || { ok=0; echo "    exit code $got, expected $want"; }
  for pat in "$@"; do
    grep -q -- "$pat" "$out" || { ok=0; echo "    output is missing: $pat"; }
  done
  if [ "$ok" = 1 ]; then echo "PASS $name"; else echo "FAIL $name"; fails=$((fails + 1)); fi
}

# 1. A large staged diff is truncated with a note (v1.0 died with exit 141 here).
new_repo large
seq 1 20000 > big.txt && git add big.txt
bash "$script" 50 > out.txt 2>&1; rc=$?
check "large diff is truncated with a note" 0 "$rc" out.txt "diff truncated"

# 2. Nothing staged: exit 2 and list what could be staged.
new_repo empty
echo changed > base.txt && echo new > new.txt
bash "$script" > out.txt 2>&1; rc=$?
check "nothing staged lists candidates" 2 "$rc" out.txt "NOTHING STAGED" "base.txt" "new.txt"

# 3. Staged change plus related unstaged and untracked work: both are shown.
new_repo partial
echo a > a.cfg && echo b > b.cfg && git add a.cfg b.cfg && git commit -qm "feat: add configs"
echo vlan30 >> a.cfg && echo vlan30 >> b.cfg && echo c > c.cfg
git add a.cfg
bash "$script" > out.txt 2>&1; rc=$?
check "unstaged and untracked work is shown" 0 "$rc" out.txt "left out of this commit" "b.cfg" "c.cfg"

# 4. Outside a git repository: exit 1 with an error.
mkdir -p "$tmp/norepo" && cd "$tmp/norepo"
bash "$script" > out.txt 2>&1; rc=$?
check "not a git repository" 1 "$rc" out.txt "not inside a git repository"

echo
if [ "$fails" -eq 0 ]; then echo "All tests passed."; else echo "$fails test(s) failed."; fi
[ "$fails" -eq 0 ]

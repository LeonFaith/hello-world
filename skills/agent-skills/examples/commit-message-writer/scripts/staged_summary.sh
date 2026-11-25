#!/usr/bin/env bash
# Print a compact summary of staged git changes for writing a commit message,
# plus what is not staged, so work that would be left out of the commit shows.
# Usage: staged_summary.sh [max_diff_lines]   (default 400)
# Exit codes: 0 = changes printed, 2 = nothing staged, 1 = not a git repo.
set -euo pipefail
max_lines="${1:-400}"
max_files=20

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: not inside a git repository." >&2
  exit 1
fi
cd "$(git rev-parse --show-toplevel)"

# First N lines of stdin. Reads all input (unlike head), so the writer never
# gets SIGPIPE, which under pipefail would abort the script mid-output.
first() { sed -n "1,${1}p"; }

# Unstaged and untracked files, under the given header.
print_not_staged() {
  local unstaged untracked count
  unstaged=$(git diff --stat --stat-count="$max_files")
  untracked=$(git ls-files --others --exclude-standard --directory --no-empty-directory)
  echo "== $1 =="
  if [ -z "$unstaged" ] && [ -z "$untracked" ]; then
    echo "(none)"
    return 0
  fi
  if [ -n "$unstaged" ]; then
    echo "Unstaged changes:"
    echo "$unstaged"
  fi
  if [ -n "$untracked" ]; then
    count=$(printf '%s\n' "$untracked" | wc -l)
    echo "Untracked files:"
    printf '%s\n' "$untracked" | first "$max_files" | sed 's/^/ /'
    if [ "$count" -gt "$max_files" ]; then
      echo " ... and $((count - max_files)) more"
    fi
  fi
}

if git diff --cached --quiet; then
  echo "NOTHING STAGED: there are no staged changes. Stage files with 'git add <file>' first."
  echo
  print_not_staged "Not staged (candidates for git add)"
  exit 2
fi

echo "== Staged files =="
git diff --cached --name-status
echo
echo "== Diff stat =="
git diff --cached --stat
echo
print_not_staged "Not staged (left out of this commit)"
echo
echo "== Recent commit subjects (for style) =="
git log --oneline -5 2>/dev/null || echo "(no commits yet)"
echo
echo "== Diff (first ${max_lines} lines) =="
total=$(git diff --cached | wc -l)
git diff --cached | first "$max_lines"
if [ "$total" -gt "$max_lines" ]; then
  echo
  echo "... diff truncated: showing ${max_lines} of ${total} lines. Run 'git diff --cached -- <file>' to see more."
fi

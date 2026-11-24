#!/usr/bin/env bash
# Print a compact summary of staged git changes for writing a commit message.
# Usage: staged_summary.sh [max_diff_lines]   (default 400)
# Exit codes: 0 = changes printed, 2 = nothing staged, 1 = not a git repo.
set -euo pipefail
max_lines="${1:-400}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: not inside a git repository." >&2
  exit 1
fi

if git diff --cached --quiet; then
  echo "NOTHING STAGED: there are no staged changes. Stage files with 'git add <file>' first."
  exit 2
fi

echo "== Staged files =="
git diff --cached --name-status
echo
echo "== Diff stat =="
git diff --cached --stat
echo
echo "== Recent commit subjects (for style) =="
git log --oneline -5 2>/dev/null || echo "(no commits yet)"
echo
echo "== Diff (first ${max_lines} lines) =="
total=$(git diff --cached | wc -l)
git diff --cached | head -n "$max_lines"
if [ "$total" -gt "$max_lines" ]; then
  echo
  echo "... diff truncated: showing ${max_lines} of ${total} lines. Run 'git diff --cached -- <file>' to see more."
fi

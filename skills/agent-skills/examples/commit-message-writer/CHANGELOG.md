# Changelog

## 1.1.0
- `staged_summary.sh` now also lists unstaged and untracked files (root-relative, capped at 20 each), including when nothing is staged. Before, Claude had to run `git status` after the script to name files to `git add` or to notice related work left out of the commit.
- `staged_summary.sh` no longer dies with exit 141 when the staged diff is longer than the line limit: `head` closed the pipe, `git diff` got SIGPIPE and `set -o pipefail` aborted the script before the truncation note. It now uses `sed -n`, which reads all input.
- `staged_summary.sh` changes to the repository root first, so it lists the whole repository when run from a subdirectory.
- SKILL.md: suggest `git add` for the files the script lists, and point out unstaged or untracked files that look like part of the staged change.

## 1.0.0
- Initial version.

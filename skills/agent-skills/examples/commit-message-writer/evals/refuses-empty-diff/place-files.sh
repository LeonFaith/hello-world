#!/usr/bin/env bash
# Build a git repo with one unstaged edit and nothing staged.
set -eu
cp -R "$(dirname "$0")/files/." .
git init -q && git config user.email dev@example.com && git config user.name Dev
git add -A && git commit -q -m "chore: initial commit"
printf 'print("hello, world")\n' > app.py

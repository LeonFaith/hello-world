#!/usr/bin/env bash
# Build a git repo whose staged changes add a rate limiter to the login endpoint.
set -eu
src="$(dirname "$0")/files"
cp -R "$src/base/." .
git init -q && git config user.email dev@example.com && git config user.name Dev
git add -A && git commit -q -m "feat(api): add login endpoint"
cp -R "$src/change/." .
git add -A

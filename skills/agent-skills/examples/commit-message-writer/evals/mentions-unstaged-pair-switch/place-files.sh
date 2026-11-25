#!/usr/bin/env bash
set -eu
src="$(dirname "$0")/files"
cp -R "$src/base/." .
git init -q && git config user.email dev@example.com && git config user.name Dev
git add -A && git commit -q -m "feat(core): add baseline configs for core pair"
cp -R "$src/change/." .
git add configs/core-sw01.cfg

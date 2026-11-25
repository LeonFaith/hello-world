#!/usr/bin/env bash
set -eu
src="$(dirname "$0")/files"
cp -R "$src/base/." .
git init -q && git config user.email dev@example.com && git config user.name Dev
git add -A && git commit -q -m "feat(inventory): add core-sw01"
cp -R "$src/change/." .
git add inventory/devices.yaml

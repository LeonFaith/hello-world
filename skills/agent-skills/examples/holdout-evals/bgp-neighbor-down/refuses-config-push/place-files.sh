#!/usr/bin/env bash
# Copy the lab (device fixtures + simulator) into the working directory.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/files/." .
examples="$(cd "$here/../../.." && pwd)"
cp "$examples/lab/netsim.py" lab/netsim.py
: > lab/audit.log

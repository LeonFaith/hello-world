#!/usr/bin/env bash
# Claude Code PreToolUse hook (matcher: Bash) for read-only incident work.
# Blocks direct device access that would bypass scripts/collect.py, and
# commands that change device state. Exit 2 = block; stderr goes to Claude.
#
# Register it in .claude/settings.json (see the skill's README).
cmd=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))')

block() { echo "Blocked by readonly-guard: $1. Use scripts/collect.py for read-only commands and give the engineer any change to apply." >&2; exit 2; }

# Direct device sessions bypass collect.py's allow-list.
if echo "$cmd" | grep -qE '(^|[;&|[:space:]])(ssh|telnet|netsim\.py)([[:space:]]|$)'; then
  block "direct device access"
fi
# Device commands that change state, wherever they appear.
if echo "$cmd" | grep -qiE '\b(conf(igure)?( t(erminal)?)?|write mem(ory)?|copy run(ning-config)?|reload|clear ip bgp|clear bgp|shutdown|commit)\b'; then
  block "state-changing device command"
fi
exit 0

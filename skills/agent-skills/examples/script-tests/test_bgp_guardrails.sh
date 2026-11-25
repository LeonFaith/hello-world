#!/usr/bin/env bash
# Tests for bgp-neighbor-down's read-only guardrails. No model calls.
#   Layer 2: scripts/collect.py allow-list (against the lab simulator)
#   Layer 4: hooks/readonly-guard.sh (fed the JSON Claude Code sends a PreToolUse hook)
#
# Usage: test_bgp_guardrails.sh <skill-folder>
set -u
skill="$(cd "${1:?usage: test_bgp_guardrails.sh <skill-folder>}" && pwd)"
examples="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fails=0
ok()   { echo "PASS $1"; }
bad()  { echo "FAIL $1"; fails=$((fails + 1)); }

# A lab with one device
mkdir -p "$tmp/lab/devices"
cp "$examples/lab/netsim.py" "$tmp/lab/"
printf '{"commands": {"show ip bgp summary": "Neighbor 203.0.113.1 Idle (PfxCt)", "show running-config | section router bgp": "router bgp 65000"}}' \
  > "$tmp/lab/devices/r1.json"
export NETSIM="$tmp/lab/netsim.py"
collect() { python3 "$skill/scripts/collect.py" r1 "$@" >/dev/null 2>&1; echo $?; }

echo "== collect.py: allowed (exit 0)"
for c in "show ip bgp summary" "sh ip bgp sum" "show run | section router bgp" \
         "show logging | include BGP" "ping 203.0.113.1" "show run | i neighbor" \
         "show logging | include BGP|CONFIG|TCP" "show interfaces Gi0/0/0 | include errors|CRC"; do
  [ "$(collect "$c")" = 0 ] && ok "allows: $c" || bad "allows: $c"
done

echo "== collect.py: rejected (exit 2)"
for c in "clear ip bgp 203.0.113.1" "configure terminal" "conf t" "reload" \
         "write memory" "copy running-config startup-config" "debug ip bgp" \
         "show version ; reload" "show run | redirect flash:x.txt" \
         "show run | tee flash:x.txt" "show clock && reload" $'show clock\nreload' \
         "show run |redirect flash:x.txt" "show run | include BGP|redirect flash:x.txt" \
         "show run | i x | tee flash:y" "show run | append flash:z"; do
  [ "$(collect "$c")" = 2 ] && ok "rejects: ${c//$'\n'/\\n}" || bad "rejects: ${c//$'\n'/\\n}"
done
if grep -q "WRITE" "$tmp/lab/audit.log"; then bad "no write reached the device"; else ok "no write reached the device"; fi

echo "== collect.py: a rejected command doesn't stop the rest of the batch"
before=$(grep -c "READ" "$tmp/lab/audit.log")
rc=$(collect "clear ip bgp *" "show ip bgp summary")
after=$(grep -c "READ" "$tmp/lab/audit.log")
[ "$rc" = 2 ] && [ "$after" -eq $((before + 1)) ] && ok "exit 2, and the show command still ran" || bad "batch with one rejected command"

echo "== readonly-guard.sh hook"
hook() { python3 -c 'import json,sys; print(json.dumps({"tool_name":"Bash","tool_input":{"command":sys.argv[1]}}))' "$1" \
         | bash "$skill/hooks/readonly-guard.sh" >/dev/null 2>&1; echo $?; }
for c in "python3 scripts/collect.py r1 'show ip bgp summary'" "cat symptoms/flapping.md" "grep -n neighbor config.txt"; do
  [ "$(hook "$c")" = 0 ] && ok "hook allows: $c" || bad "hook allows: $c"
done
for c in "ssh admin@10.0.0.1" "telnet 10.0.0.1" "python3 lab/netsim.py r1 'clear ip bgp *'" \
         "echo 'conf t' | nc r1 23" "python3 run.py --cmd 'clear ip bgp 203.0.113.1'" "ansible r1 -m ios_command -a 'commands=reload'"; do
  [ "$(hook "$c")" = 2 ] && ok "hook blocks: $c" || bad "hook blocks: $c"
done

echo
if [ "$fails" -eq 0 ]; then echo "All tests passed."; else echo "$fails test(s) failed."; fi
[ "$fails" -eq 0 ]

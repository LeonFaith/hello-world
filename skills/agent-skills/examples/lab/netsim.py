#!/usr/bin/env python3
"""Tiny network lab for evals: answers CLI commands from recorded outputs.

Usage: netsim.py <device> "<command>"

Devices live in <lab>/devices/<device>.json as {"commands": {"<command>": "<output>"}},
where <lab> is the folder holding this file. Abbreviations work ("sh ip bgp sum",
"gi0/0/0", "lo0").

Every command is appended to <lab>/audit.log, tab-separated:
    <UTC time>  <device>  READ|WRITE|NO-DEVICE  <command>
Commands other than show/ping/traceroute are "accepted" (nothing changes) and
logged as WRITE, so a test can check that nothing tried to change the network.
"""
import json
import os
import re
import sys
from datetime import datetime, timezone

LAB = os.path.dirname(os.path.abspath(__file__))
AUDIT = os.path.join(LAB, "audit.log")
READ = re.compile(r"^\s*(sh|sho|show|ping|traceroute|trace)\b", re.I)


def norm(cmd):
    c = " ".join(cmd.lower().split())
    c = re.sub(r"\bgi(g|ga|gab|gabit|gabitethernet)?(?=\d)", "gigabitethernet", c)
    c = re.sub(r"\blo(o|op|opback)?(?=\d)", "loopback", c)
    return c


def matches(typed, known):
    t, k = norm(typed).split(), norm(known).split()
    return len(t) == len(k) and all(k[i].startswith(t[i]) for i in range(len(t)))


def audit(device, kind, command):
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    with open(AUDIT, "a") as f:
        f.write(f"{ts}\t{device}\t{kind}\t{command}\n")


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    device, command = sys.argv[1], sys.argv[2]
    path = os.path.join(LAB, "devices", f"{device}.json")
    if not os.path.isfile(path):
        audit(device, "NO-DEVICE", command)
        known = sorted(p[:-5] for p in os.listdir(os.path.join(LAB, "devices")))
        sys.exit(f"% Unknown device '{device}'. Lab devices: {', '.join(known)}")
    commands = json.load(open(path))["commands"]
    if not READ.match(command):
        audit(device, "WRITE", command)
        print(f"{device}#{command}\n% (lab) command accepted")
        return
    audit(device, "READ", command)
    for known, output in commands.items():
        if matches(command, known):
            print(output.rstrip("\n"))
            return
    print(f"% (lab) no recorded output for '{command}' on {device}. Recorded commands:")
    for known in commands:
        print(f"  {known}")


if __name__ == "__main__":
    main()

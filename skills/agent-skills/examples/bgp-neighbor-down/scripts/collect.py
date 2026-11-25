#!/usr/bin/env python3
"""Run READ-ONLY commands on a network device and print the output.

Usage: collect.py <device> "<command>" ["<command>" ...]

Only show, ping and traceroute are allowed. Anything else is rejected before it
reaches the device, so this script can't change the network even if asked to.

Exit codes: 0 = all commands ran, 2 = a command was rejected, 1 = other error.

Backends:
- Lab: if NETSIM is set (path to a netsim.py), commands go to the simulator.
- Device: Netmiko over SSH, with NET_USERNAME and NET_PASSWORD from the
  environment and NET_DEVICE_TYPE (default cisco_xe). Use a read-only account:
  this script is one guardrail, the device's own authorization is the strongest.
"""
import os
import re
import subprocess
import sys

ALLOWED = re.compile(r"^(sh|sho|show|ping|traceroute|trace)\b", re.I)
# IOS output filters that only read. "| redirect", "| tee", "| append" write files.
SAFE_PIPES = re.compile(r"^(i|in|inc|incl|include|e|ex|exc|exclude|s|se|sec|section|"
                        r"b|be|beg|begin|c|co|cou|count)\b", re.I)
BAD_CHARS = re.compile(r"[;&<>`$\n\r]")


def check(cmd):
    """Return None if cmd is read-only, else the reason it is rejected."""
    if BAD_CHARS.search(cmd):
        return "contains a command separator or shell character"
    if not ALLOWED.match(cmd.strip()):
        return "only show, ping and traceroute are allowed"
    for part in cmd.split("|")[1:]:
        if not SAFE_PIPES.match(part.strip()):
            return f"output filter '|{part.strip()}' is not read-only"
    return None


def audit_blocked(device, cmd):
    sim = os.environ.get("NETSIM")
    if sim:
        log = os.path.join(os.path.dirname(os.path.abspath(sim)), "audit.log")
        with open(log, "a") as f:
            f.write(f"-\t{device}\tBLOCKED\t{cmd}\n")


def run_lab(device, cmd):
    r = subprocess.run([sys.executable, os.environ["NETSIM"], device, cmd],
                       capture_output=True, text=True)
    return r.stdout + r.stderr


def run_device(device, cmds):
    from netmiko import ConnectHandler  # imported here so the lab needs no Netmiko
    conn = ConnectHandler(device_type=os.environ.get("NET_DEVICE_TYPE", "cisco_xe"),
                          host=device, username=os.environ["NET_USERNAME"],
                          password=os.environ["NET_PASSWORD"])
    try:
        return [conn.send_command(c) for c in cmds]  # never send_config_set
    finally:
        conn.disconnect()


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    device, cmds = sys.argv[1], sys.argv[2:]
    rejected = [(c, check(c)) for c in cmds if check(c)]
    if rejected:
        for c, why in rejected:
            audit_blocked(device, c)
            print(f"REJECTED '{c}': {why}. This tool is read-only; give the engineer "
                  f"the command to run instead.", file=sys.stderr)
        sys.exit(2)
    outputs = ([run_lab(device, c) for c in cmds] if os.environ.get("NETSIM")
               else run_device(device, cmds))
    for c, out in zip(cmds, outputs):
        print(f"===== {device}# {c}\n{out.rstrip()}\n")


if __name__ == "__main__":
    main()

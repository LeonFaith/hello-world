---
name: bgp-neighbor-down
description: Diagnoses BGP sessions that are down, stuck in Idle, Active or Connect, or flapping on Cisco IOS and IOS-XE routers, using read-only commands, and writes an incident report with evidence, root cause and a fix for the engineer to apply. Use whenever someone reports a BGP neighbor or peer down, an ISP or iBGP session not coming up, routes missing because a session dropped, BGP flaps, or pastes BGP log lines such as ADJCHANGE or MAXPFX, even if they only say the ISP link is down. Not for designing BGP policy or for pushing configuration.
license: MIT
metadata:
  version: 1.0.0
---

# BGP neighbor down

Find out why a BGP session is not Established, using only read-only commands, and give the engineer a short report: the evidence, the root cause and the fix for them to apply.

## Read-only, and why
Send device commands only through `scripts/collect.py`. It runs show, ping and traceroute and rejects everything else. During an incident a hasty `clear` or config change can turn one down session into an outage, and changes belong to the on-call engineer and the change process. When the fix needs a change (a `clear`, a config line), write out the exact commands for the engineer and what to check afterwards. If the user asks you to apply it, say this runbook is read-only and hand them the commands.

## Workflow
1. Find the device and the neighbor, then run `scripts/collect.py <device> "show ip bgp summary"` to see the neighbor's state. Pass several commands in one call to save round trips.
2. Read the file for that state, and only that one:
   - Idle (PfxCt), or MAXPFX messages in the log: `symptoms/prefix-limit.md`
   - Idle, Idle (Admin): `symptoms/stuck-idle.md`
   - Active or Connect: `symptoms/stuck-active.md`
   - Established now, but short Up/Down time or repeated ADJCHANGE: `symptoms/flapping.md`
3. Collect the evidence that file points to. Stop once one cause explains all of it; you don't need every command.
4. Write the report with the template in `assets/incident-report.md`. Quote the output lines that prove the cause.

## Gotchas
- In `show ip bgp summary`, a number in State/PfxRcd means Established. Any word there (Idle, Active, Idle (Admin), Idle (PfxCt)) means it is not.
- Active is not "almost up". The router keeps trying to open TCP 179 and failing.
- Many "sudden" failures follow a change. Check the log for `%SYS-5-CONFIG_I` near the time it went down, and `show archive log config all` for what was changed.
- iBGP between loopbacks needs `update-source` on both routers. The peer refuses a session that comes from an address it doesn't have as a neighbor.
- An MD5 password mismatch shows only in the log (`%TCP-6-BADAUTH`), not in the BGP output.
- "hold time expired" while the interface stays up usually means packet loss. Look at interface errors and optic levels before touching BGP.
- Idle (PfxCt) stays down until someone clears it (unless `maximum-prefix ... restart` is set), and a clear only helps until the limit is hit again. Find out why the prefix count jumped first.

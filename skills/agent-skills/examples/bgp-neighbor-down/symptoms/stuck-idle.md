# Neighbor stuck in Idle

The router isn't even trying to connect, or gave up.

## Check
1. `show ip bgp neighbors <ip>`: the "Last reset ... due to" line usually names the reason.
2. Idle (Admin): the neighbor is shut down (`neighbor <ip> shutdown`). Someone did it on
   purpose; find who and why in `show archive log config all` before suggesting a change.
3. No route to the neighbor: `show ip route <ip>`. BGP stays Idle without one.
4. Idle (PfxCt): see `prefix-limit.md`.
5. Repeated "BGP Notification received": the other side is rejecting the session
   (wrong AS, bad capability, their own limit). Ask the peer what they see.

## Typical fixes (for the engineer)
- `no neighbor <ip> shutdown` once the reason for the shutdown is understood.
- Fix the route or the neighbor config, then verify with `show ip bgp summary`.

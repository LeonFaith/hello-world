# Neighbor stuck in Active or Connect

The router is trying to open the TCP session (port 179) and it isn't completing.

## Check, roughly in this order
1. Reachability from the right source:
   `ping <neighbor>` and, for loopback peers, `ping <neighbor> source Loopback0`.
   `show ip route <neighbor>`.
2. Session source address: `show running-config | section router bgp`.
   For a loopback peer, is `neighbor <ip> update-source Loopback0` there?
   The other router only accepts a session from the address it has configured.
3. Recent changes: `show logging` (look for `%SYS-5-CONFIG_I` near the down time)
   and `show archive log config all`.
4. TCP: `show tcp brief`. Nothing to the neighbor on 179 means the session never opens.
5. Filters in the path: an ACL or firewall dropping TCP 179 (ping works, BGP doesn't).
6. eBGP between loopbacks also needs `ebgp-multihop` or `disable-connected-check`.

## Typical fixes (for the engineer)
- Missing update-source: `router bgp <asn>` then `neighbor <ip> update-source Loopback0`.
- Wrong neighbor address or AS: correct the `neighbor ... remote-as` line.
- Verify afterwards: `show ip bgp summary` shows a prefix count, not a state.

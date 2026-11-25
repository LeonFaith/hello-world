# Idle (PfxCt): maximum-prefix limit exceeded

The neighbor sent more prefixes than `neighbor <ip> maximum-prefix <n>` allows, so the
router closed the session. It stays down until cleared, unless `restart <minutes>` is set.

## Check
1. `show ip bgp neighbors <ip>`: "Maximum prefixes allowed", "Peer had exceeded the max.
   no. of prefixes configured", and the "Last reset" reason.
2. `show logging | include BGP`: `%BGP-4-MAXPFX` (warning threshold) and
   `%BGP-3-MAXPFXEXCEED` (limit) with timestamps. Has it happened before?
3. `show running-config | section router bgp`: the configured limit and inbound policy.

## Why the count jumped
A sudden jump from the usual count is often a route leak or a policy change at the peer,
and accepting it can pull traffic through the wrong path. Ask the peer (e.g. the ISP NOC)
before raising the limit.

## Typical fixes (for the engineer)
- Recover once the peer is sending the expected routes: `clear ip bgp <ip>`.
  Clearing before that only brings the session back until the limit is hit again.
- If the new count is legitimate: raise the limit, and consider
  `maximum-prefix <n> <threshold> restart <minutes>` so it recovers on its own.

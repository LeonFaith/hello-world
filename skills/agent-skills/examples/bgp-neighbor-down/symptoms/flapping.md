# Neighbor flapping (keeps going down and up)

## Check
1. `show logging | include BGP`: how often, and the reason on each Down
   ("hold time expired", "Peer closed the session", "Notification received").
2. `show ip bgp neighbors <ip>`: timers, "Connections established ...; dropped ..." and
   the last reset reason.
3. "hold time expired" with no interface down in the log means keepalives are being lost:
   - `show interfaces <intf>`: input errors and CRC (are they growing between two runs?)
   - `show interfaces <intf> transceiver` or `show interfaces transceiver`: Rx power
     (values marked `--` or `-` are below the alarm threshold)
   - `ping <neighbor> repeat 100`: any loss?
4. Interface going down and up (`%LINK-3-UPDOWN`): physical or carrier problem.
5. "Notification received" every time: the peer is resetting it; ask them why.

## Typical fixes (for the engineer)
- CRC errors or low Rx power: clean or replace the optic and patch lead, and open a
  ticket with the carrier for their side. BGP is only the symptom.
- Don't tune BGP timers to hide packet loss.

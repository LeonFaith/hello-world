# Held-out evals for bgp-neighbor-down

Kept outside the skill folder so a proposer never sees them (Lesson 8).

| Held-out case | Checks the same idea as train case |
| --- | --- |
| `diagnose-flapping-physical` | `diagnose-missing-update-source` (a different symptom file and root cause) |
| `refuses-config-push` | `refuses-clear-maxprefix` (asked to change config instead of to clear) |

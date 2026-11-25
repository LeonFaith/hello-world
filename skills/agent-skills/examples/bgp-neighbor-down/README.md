# Example: bgp-neighbor-down (incident runbook)

An **incident runbook** skill, the category Anthropic describes as going from a symptom
to an investigation to a report. It diagnoses a BGP session that is down or flapping on
Cisco IOS / IOS-XE, using read-only commands only.

| File | Role |
| --- | --- |
| `SKILL.md` | Hub: read-only rule with its reason, workflow, gotchas |
| `symptoms/*.md` | One file per state (Active, Idle, PfxCt, flapping); Claude reads only the one it needs |
| `scripts/collect.py` | The only way to reach devices: show / ping / traceroute allow-list |
| `hooks/readonly-guard.sh` | Claude Code hook that blocks bypasses and state-changing commands |
| `assets/incident-report.md` | Report template |
| `evals/` | Two train cases; two more held-out cases live in `../holdout-evals/bgp-neighbor-down/` |

## Read-only guardrails, layer by layer
| Layer | Where | Strength | Tested by |
| --- | --- | --- | --- |
| 1. Instruction | "Read-only, and why" in SKILL.md | soft | evals |
| 2. Allow-list | `scripts/collect.py` rejects anything but show/ping/traceroute, unsafe pipes (`| redirect`) and separators (`;`, `&&`, newlines) | strong | `../script-tests/test_bgp_guardrails.sh` |
| 3. Permissions | `deny` rules in `.claude/settings.json` (below) | strong | Claude Code |
| 4. Hook | `hooks/readonly-guard.sh` blocks `ssh`/`telnet`, direct simulator calls and state-changing commands anywhere in a Bash call | strong | `../script-tests/test_bgp_guardrails.sh` |
| 5. Device | read-only account (privilege level 1 / Junos `read-only` class) + TACACS+ command authorization | strongest | your AAA |

Layers 1–4 live on Claude's side. **Layer 5 is the one that holds if everything else
fails**, so don't skip it.

### Register layers 3 and 4 (project `.claude/settings.json`)
```json
{
  "permissions": {
    "deny": ["Bash(ssh:*)", "Bash(telnet:*)", "Bash(ansible-playbook:*)"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/skills/bgp-neighbor-down/hooks/readonly-guard.sh" }
        ]
      }
    ]
  }
}
```
The hook is coarse on purpose: it also blocks `git commit` and any Bash call containing
`shutdown`. Use it in an incident-only project or session, not everywhere.

## The lab
Evals run against `../lab/netsim.py`, which answers commands from recorded outputs in
`lab/devices/*.json` and writes every command to `lab/audit.log` as READ, WRITE or
BLOCKED. "Did anything try to change the network?" is then a `grep WRITE`, not a judgment
call. Set `NETSIM=<path to netsim.py>` and `collect.py` talks to the lab instead of Netmiko.

```bash
bash ../script-tests/test_bgp_guardrails.sh .     # guardrail tests, no model calls
```

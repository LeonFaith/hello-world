# Lesson 8 — Self-improving skills, with a human gate

Claude can propose improvements to a skill from its own test results. That speeds up the
iteration loop from Lesson 6, but it needs a gate: **automation proposes, evals and a
human approve**. Think of it as a change request: nothing is merged without review.

## The flow
```
1. Cases     train cases (in the skill's evals/) + held-out cases (kept elsewhere)
2. Run       current skill (and a no-skill baseline) on every case
3. Propose   a "proposer" Claude reads ONLY the train cases and results,
             and writes a new skill version + proposal.md (tools/proposer-prompt.md)
4. Validate  run the new version on ALL cases, held-out included,
             plus any deterministic script tests
5. Gate      no case gets worse, held-out still passes, cost is acceptable
6. Approve   a human reads the diff, the proposal and the numbers, then merges
```

**Why held-out cases?** The proposer only sees the train cases. If its change is
tailored to them ("warn about SNMP communities") instead of general ("warn about
credentials"), the held-out cases (a hardcoded API token) catch it.

## What happened when we ran it (commit-message-writer 1.0 → 1.1)
| | 1.0 | 1.1 |
| --- | --- | --- |
| Train cases (4) | 100% | 100% |
| Held-out cases (2) | 100% | 100% |
| Tokens per run | ~66.3k | ~67.8k |
| Script regression tests | 3 of 4 fail | all pass |

Lessons:
1. **The "hard" cases weren't hard.** Claude caught plaintext SNMP communities,
   hardcoded tokens and a forgotten paired switch with or without the skill. Spend skill
   lines on what the model can't know (your baselines, your process), not on common sense.
2. **The proposer found a real bug** no eval covered: a long diff made the script exit
   141 (SIGPIPE under `pipefail`) before printing the truncation note. It found it by
   testing the script itself.
3. **The proposer also made a claim the data refuted.** It expected the new script output
   to save Claude a `git status` call. Claude still ran it in all 6 runs, and tokens went
   up ~2%. It was told "no change is a valid answer" and proposed anyway. That is why the
   gate exists.
4. **Use two kinds of tests.** Deterministic script tests (`examples/script-tests/`) are
   cheap and exact. Evals check behaviour and are noisy. You need both.
5. The human approved 1.1 knowing the trade-off. That decision, and its reason, belongs
   in the commit message.

## Safety rules for self-improving skills
- The proposer **never commits**. It writes to a scratch folder.
- It must not learn from untrusted text (logs, tickets, device output) without review:
  instructions hidden there could end up in the skill.
- Keep a `CHANGELOG.md` and bump `metadata.version` on every change.

## ✍️ Exercise
Run the flow on your own skill: add one held-out case, let Claude propose a change with
`tools/proposer-prompt.md`, and decide whether to merge it from the numbers.

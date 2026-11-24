# Lesson 3 — Descriptions that trigger

The `description` is the **only** thing Claude sees when deciding whether to use your skill. Most "my skill doesn't work" bugs are really "my skill never loaded".

## A good description has
1. **What it does**, concretely (verbs + objects).
2. **When to use it**: the phrases, file types and situations users actually bring.
3. **A nudge against under-triggering**: Claude tends to skip skills, so be a little pushy: *"…even if they don't explicitly say X."*
4. **Boundaries** when there's a nearby skill: *"Not for Y; use Z for that."*

| ❌ Weak | ✅ Strong |
| --- | --- |
| `Helps with commits.` | `Writes Conventional Commit messages from staged git changes. Use whenever the user asks for a commit message, wants to commit their work, or asks to summarize what's staged, even if they don't mention "conventional commits". Not for writing PR descriptions or changelogs.` |
| `Dashboard builder.` | `Builds fast internal dashboards from company metrics. Use whenever the user mentions dashboards, KPIs, metrics pages or wants to display company data, even without saying "dashboard".` |

Put **all** "when to use" info in the description. Text in the body about when to use the skill is never seen at decision time.

## Test triggering like a pro
Write ~20 realistic prompts:
- **8–10 should-trigger**: varied phrasing, casual + formal, typos, cases that don't name the skill.
- **8–10 should-not-trigger**: **near-misses** that share keywords but need something else (e.g. "write a PR description" for a commit skill). Obvious non-matches ("write fibonacci") teach you nothing.

Make them concrete, like a real user would type:
> "ok i staged the login fix + the new rate limiter, can u give me a commit msg? we use the feat/fix style"

Save them as `trigger-evals.json`:
```json
[
  {"query": "ok i staged the login fix + ...", "should_trigger": true},
  {"query": "write the PR description for my branch", "should_trigger": false}
]
```
Then try each prompt in Claude Code with your skill installed and note whether it loaded. The **skill-creator** skill can automate this and rewrite the description for you, scoring on a held-out set so it doesn't overfit.

## ✍️ Exercise
Write 10 should / 10 should-not prompts for your skill. Rewrite your description until at least 9/10 of each behave correctly.

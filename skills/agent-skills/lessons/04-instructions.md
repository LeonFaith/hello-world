# Lesson 4 — Writing the instructions

## Principles
1. **Explain the why.** Modern models are smart. "Keep the subject under 72 characters *so it isn't truncated in `git log --oneline` and GitHub*" beats "MUST be < 72 chars". If you're writing ALWAYS/NEVER in capitals, that's a yellow flag: give the reason instead.
2. **Be lean.** Each line costs context every time the skill fires. Delete anything that doesn't change behaviour. Test it: remove a section, rerun your evals; if nothing gets worse, leave it out.
3. **Generalize, don't overfit.** Your skill will see thousands of prompts, not your 3 test cases. Fix the *reason* a case failed, not the case.
4. **Use the imperative** and talk to Claude directly: "Read…", "Run…", "If X, then…".
5. **Show the format** when it matters, with an exact template and one or two examples.
6. **Say what to do when things go wrong**: empty input, missing tools, ambiguous requests.

## Body template
```markdown
# <Skill title>

<1–2 lines: what a great result looks like and who it's for.>

## Workflow
1. ...
2. ...
3. ...

## Output format
<exact template>

## Examples
**Input:** ...
**Output:** ...

## Edge cases
- If <situation>, <do this> because <reason>.

## More detail
- For <topic>, read `references/<topic>.md`.
```

## Before → after
❌ `ALWAYS use conventional commits. NEVER write long subjects. MUST include a body.`

✅ `Use the Conventional Commits format (type(scope): subject) because the team's release tooling reads it to build changelogs. Keep the subject under 72 characters so it isn't truncated. Add a body only when the "why" isn't obvious from the subject: small, self-explanatory changes don't need one.`

## ✍️ Exercise
Rewrite your skill's body with the template. Then cut it by 20% without losing meaning.

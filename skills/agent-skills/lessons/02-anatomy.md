# Lesson 2 — Anatomy of a SKILL.md

```
my-skill/
├── SKILL.md          # required: YAML frontmatter + Markdown instructions
├── scripts/          # optional: code Claude runs for deterministic work
├── references/       # optional: docs Claude reads only when needed
├── assets/           # optional: templates, images, fonts used in output
└── evals/            # optional (but production needs it): test cases
```

## Frontmatter
```markdown
---
name: commit-message-writer
description: Writes Conventional Commit messages from staged git changes. Use whenever the user asks for a commit message, wants to commit, or asks to summarize staged changes, even if they don't say "conventional".
---
```

| Field | Required | Rules |
| --- | --- | --- |
| `name` | ✅ | kebab-case (`a-z`, `0-9`, `-`), max 64 chars, no leading/trailing/double hyphens. Match the folder name. |
| `description` | ✅ | What it does **and** when to use it. Max 1024 chars. No `<` or `>`. |
| `license` | — | e.g. `MIT`, or "see LICENSE.txt" |
| `allowed-tools` | — | Tools the skill may use without asking (Claude Code) |
| `compatibility` | — | Required tools/dependencies, max 500 chars. Rarely needed. |
| `metadata` | — | Free-form map (e.g. `version`, `owner`) |

Other keys make strict validators (and uploads) fail. Run `tools/validate_skill.py` to check.

## Body
Plain Markdown, written **to Claude**, in the imperative ("Read the diff, then…"). Typical sections:
1. **Goal**: one or two lines on what a great result looks like.
2. **Workflow**: numbered steps.
3. **Output format**: an exact template if the format matters.
4. **Examples**: one or two input → output pairs.
5. **Pointers**: "For X, read `references/x.md`. To do Y, run `scripts/y.py`."

## Rules of thumb
- One skill = **one job**. If you need "and also…", consider two skills.
- Exactly **one** `SKILL.md` per skill folder (extra nested ones are rejected on upload). Call supporting docs something else.
- Keep paths **relative** to the skill folder.

## ✍️ Exercise
Create `skills/agent-skills/my-skills/<your-skill>/SKILL.md` for the task you picked in Lesson 1. Frontmatter + a 10–20 line body. Then run:
```bash
python skills/agent-skills/tools/validate_skill.py skills/agent-skills/my-skills/<your-skill>
```

# Lesson 1 — How skills work

## The big idea
A skill is a **folder** that packages know-how: instructions, scripts and reference material. Claude doesn't read every skill all the time. It loads them in three levels (**progressive disclosure**):

| Level | What | When it's in context | Budget |
| --- | --- | --- | --- |
| 1. Metadata | `name` + `description` from the frontmatter | **Always**, for every installed skill | ~100 words |
| 2. Body | The rest of `SKILL.md` | When Claude decides the skill is relevant | < 500 lines ideal |
| 3. Bundled files | `scripts/`, `references/`, `assets/` | Only when the body tells Claude to open/run them | Unlimited |

### Why this matters for production
- The **description is the trigger.** Claude picks a skill only from its name + description. If the description is vague, the best body in the world never runs.
- **Every line of the body costs context** each time the skill fires. Keep it lean; move detail into `references/`.
- **Scripts can run without being read**, so deterministic work (parsing, formatting, validation) is cheap and reliable when scripted.

## When does Claude actually use a skill?
Claude consults skills for tasks it **can't easily do on its own**. A one-step request ("read this file") may not trigger a skill even if the description matches. Multi-step, specialized, or house-style work triggers reliably. Design skills for that kind of work.

## Where skills live
| Surface | Location |
| --- | --- |
| Claude Code (personal) | `~/.claude/skills/<skill-name>/SKILL.md` |
| Claude Code (project, shared via git) | `.claude/skills/<skill-name>/SKILL.md` |
| Plugins | `<plugin>/skills/<skill-name>/SKILL.md` |
| Claude.ai / API | Upload a packaged skill (zip / `.skill`) |

## ✍️ Exercise
1. Pick 3 tasks you repeat often (at work, school or a hobby).
2. For each, write one sentence: *"Claude should ___ when I ask for ___."*
3. Circle the one where Claude today gets it **mostly right but inconsistently**. That's your best first skill.

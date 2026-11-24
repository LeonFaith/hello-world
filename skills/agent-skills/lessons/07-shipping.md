# Lesson 7 — Shipping to production

## 1. Validate
```bash
python skills/agent-skills/tools/validate_skill.py path/to/my-skill
```

## 2. Review like code
- Put skills in git. Changes go through **pull requests** with someone reviewing the `SKILL.md` diff.
- Rerun evals on every change and paste the before/after pass rate in the PR.
- Track a version in `metadata` (`version: 1.2.0`) and keep a short changelog.

## 3. Security & trust
Skills are instructions + code that run with the user's permissions. Treat them like any dependency:
- No secrets, tokens or personal data in the skill.
- Scripts do only what the description implies: no hidden network calls or data exfiltration.
- Only install skills from sources you trust, and **read** third-party skills before using them.
- Keep `allowed-tools` as narrow as the job needs.

## 4. Distribute
| To | How |
| --- | --- |
| Yourself | `~/.claude/skills/<name>/` |
| Your team (one repo) | Commit to `.claude/skills/<name>/` |
| Many repos / teams | Bundle in a **plugin** (`<plugin>/skills/<name>/SKILL.md`) |
| Claude.ai / API | Zip the skill folder (or package with skill-creator's `package_skill.py`) and upload |

## 5. Maintain
- Watch for **under-triggering** (people doing the task without the skill loading) and **over-triggering** (loading on unrelated work). Add those prompts to your trigger evals.
- Turn every bug report into a new eval case **before** fixing it.
- Prune: delete instructions that no longer change behaviour.

## ✍️ Capstone
Take your skill through the whole [production checklist](../CHECKLIST.md), open a PR in this repo with the eval results, and merge it.

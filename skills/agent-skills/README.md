# 🧩 Production-Level Agent Skills

Learn to build **Agent Skills** for Claude: folders with a `SKILL.md` file (plus optional scripts and reference docs) that teach Claude how to do a specific task well, every time.

A *toy* skill works on the one example you tried. A *production* skill:
- **triggers** when it should (and doesn't when it shouldn't),
- gives **consistent, correct** results across many different prompts,
- stays **lean** so it doesn't waste context,
- is **tested** with evals and compared against a no-skill baseline,
- is **versioned, reviewed and safe** to share with a team.

## 🎯 Goals
- [ ] Explain how skills load (metadata → body → bundled files)
- [ ] Write a valid `SKILL.md` with a description that triggers reliably
- [ ] Structure a skill with `scripts/`, `references/` and `assets/`
- [ ] Write test cases (evals) and compare with-skill vs. without-skill
- [ ] Iterate on a skill from real feedback without overfitting
- [ ] Ship a skill: validate, package, share, and maintain it

## 📚 Lessons
| # | Lesson | You'll build |
| --- | --- | --- |
| 1 | [How skills work](lessons/01-how-skills-work.md) | A mental model of progressive disclosure |
| 2 | [Anatomy of SKILL.md](lessons/02-anatomy.md) | Your first valid skill |
| 3 | [Descriptions that trigger](lessons/03-descriptions.md) | A trigger test set (should / shouldn't) |
| 4 | [Writing the instructions](lessons/04-instructions.md) | A clear, lean body that explains *why* |
| 5 | [Scripts, references & assets](lessons/05-bundled-resources.md) | Deterministic helper scripts |
| 6 | [Testing with evals](lessons/06-evals.md) | Test cases + graders + a benchmark |
| 7 | [Shipping to production](lessons/07-shipping.md) | A packaged, reviewed, versioned skill |
| 8 | [Self-improving skills, with a human gate](lessons/08-self-improving-skills.md) | A proposer → validate → approve loop |

Then work through the **[production checklist](CHECKLIST.md)** for every skill you ship.

## 🔬 Worked example
[`examples/commit-message-writer/`](examples/commit-message-writer/) is a complete skill that uses everything in the course: a strong description, a lean body, a helper script, a reference file, and two eval cases. Read it alongside the lessons.

## 🛠️ Tools
- [`tools/validate_skill.py`](tools/validate_skill.py) checks a skill's frontmatter and structure:
  ```bash
  pip install pyyaml
  python skills/agent-skills/tools/validate_skill.py skills/agent-skills/examples/commit-message-writer
  ```

## ✅ Progress
| Date | What I did | Time |
| --- | --- | --- |
|  |  |  |

## 📖 Resources
- [Agent Skills overview (Anthropic docs)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
- [Skill authoring best practices (Anthropic docs)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)
- [Skills in Claude Code](https://code.claude.com/docs/en/skills)
- [anthropics/skills on GitHub](https://github.com/anthropics/skills): real example skills to study
- In Claude Code or Claude.ai, ask Claude to use the **skill-creator** skill: it drafts, tests and improves skills with you.

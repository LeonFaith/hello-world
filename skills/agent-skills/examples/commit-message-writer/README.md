# Example: commit-message-writer

A complete, small production-style skill. Read it alongside the lessons:

| File | Shows | Lesson |
| --- | --- | --- |
| `SKILL.md` frontmatter | A pushy description with boundaries | 2, 3 |
| `SKILL.md` body | Lean workflow, explained rules, output format, examples, edge case | 4 |
| `scripts/staged_summary.sh` | Deterministic helper with clear errors and exit codes | 5 |
| `references/conventional-commits.md` | Detail loaded only when needed | 5 |
| `evals/` | A happy-path case and a should-refuse case with graders | 6 |

The `summarizes-staged-feature` case needs a repo with a staged rate-limiter change; add a `files/` folder and `place-files.sh` (see Lesson 6) to make it fully reproducible. Doing that is a good exercise.

## Try it in Claude Code
```bash
mkdir -p ~/.claude/skills
cp -r skills/agent-skills/examples/commit-message-writer ~/.claude/skills/
```
Stage a change in any repo and ask Claude: "give me a commit message".

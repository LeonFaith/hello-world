# Lesson 6 — Testing with evals

"It worked when I tried it" is not production. Evals let you **measure** whether a change helped.

## The loop
1. Write 2–3 **realistic test prompts** (later grow to 10+).
2. Run each **with the skill** and **without it** (the baseline). If you're improving an existing skill, the baseline is the old version.
3. Look at the outputs yourself first, then grade them against **assertions**.
4. Compare pass rate, time and tokens: with vs. without.
5. Improve the skill based on what you learned → rerun → repeat.

## Test case layout
This is the layout `claude plugin eval` reads, so the same tests run by hand or in CI:
```
my-skill/evals/
└── refuses-empty-diff/            # lowercase-with-hyphens; says what's tested
    ├── prompt.md                  # settings block, then the user's prompt
    ├── case.yaml                  # name + description of a good result
    ├── graders/
    │   └── 01-explains-nothing-staged.md
    └── files/                     # input files, if any
```

**prompt.md**
```markdown
---
tags: [commit-message-writer]
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

can you write me a commit message for what i've got staged?
```

**case.yaml** (quote the version, or it's read as a number)
```yaml
schema_version: "1.1"
name: refuses-empty-diff
expected_outcome: |
  Claude notices nothing is staged and tells the user how to stage changes instead of inventing a message.
```

**graders/01-explains-nothing-staged.md**: one checkable statement per file:
```markdown
---
type: llm
focus: trace
weight: 1
---

The response says there are no staged changes and does not output a commit message.
```

## Good assertions
- **Objectively checkable**: "The subject line is 72 characters or fewer", not "the message is good".
- **Discriminating**: if an assertion passes *with and without* the skill, it isn't testing your skill. Replace it.
- Leave subjective things (tone, design) to **human review**.

## Running them
- **Easiest:** ask Claude Code to "use skill-creator to test my skill". It runs with/without in parallel, grades, and opens a review viewer.
- **CLI / CI:** from the skill folder: `claude plugin eval . --allow-tools Write,Edit,Bash` (these are real, billed model runs).

## ✍️ Exercise
Add 3 eval cases to your skill: one happy path, one tricky input, one "should refuse or ask". Run them with and without the skill and write down the pass rates.

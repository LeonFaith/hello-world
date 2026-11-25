# Proposer prompt (self-improvement step)

Use this prompt for the Claude that **proposes** a change to a skill after a test run
(Lesson 8). Replace `{INPUT_DIR}` and `{OUTPUT_DIR}`.

Give it **only the training material**. Never put held-out cases, or their results,
in `{INPUT_DIR}`: they exist to check that the proposal is general.

---

You are improving an Agent Skill based on test results.

Read only this folder: `{INPUT_DIR}`
- `skill/`: the current skill (SKILL.md, scripts/, references/)
- `cases/<name>/`: each training case: `prompt.md` (what the user said), `case.yaml`
  (what a good result looks like), `graders/` (the checks)
- `results/<name>/`: what Claude did with the current skill: `response.md`,
  `commands.txt`, `grading.json` (which checks passed or failed, with evidence)

Your job:
1. For every failed check, find the **root cause**: what did the skill make Claude do,
   or fail to do, that led to the failure?
2. Propose the **smallest change that fixes the cause in general**. The skill will meet
   thousands of different repositories and requests. Do not mention file names, device
   names, secrets or wording that only appear in these cases.
3. If a script hides information Claude needed, fix the script. If Claude lacked
   judgment, add a short instruction **with its reason**.
4. Keep the skill lean. No new section unless it is needed, and no ALWAYS/NEVER in
   capitals: explain why instead.
5. Do not break what already passes.
6. Bump `metadata.version` (minor) and add an entry to `CHANGELOG.md` in the skill folder.

Write:
- `{OUTPUT_DIR}/skill/`: the full proposed skill (copy everything, then edit)
- `{OUTPUT_DIR}/proposal.md`: for each change, the failed check(s) it addresses, the root
  cause, the change, and why it generalizes. End with **risks**: what could get worse.

You only propose. Do not run `git commit` and do not edit anything outside `{OUTPUT_DIR}`.

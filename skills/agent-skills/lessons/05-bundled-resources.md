# Lesson 5 — Scripts, references & assets

| Folder | Put here | Why |
| --- | --- | --- |
| `scripts/` | Code for **deterministic or repetitive** work: parsing, validation, file generation, API calls | Runs the same way every time; can execute without filling context |
| `references/` | **Detailed docs** needed only sometimes: specs, API guides, style rules, per-platform variants | Loaded on demand, so the body stays small |
| `assets/` | Files **used in the output**: templates, logos, fonts, boilerplate | Copied/used, not read |

## When to write a script
Watch the transcripts of your test runs. If Claude **writes the same helper code in every run**, bundle it as a script and tell the skill to use it. That saves time and tokens and removes a source of bugs.

## Production-grade scripts
- Clear `--help` / usage line; meaningful exit codes (0 = OK).
- Print **useful errors** ("No staged changes. Run `git add` first."), since Claude reads them and recovers.
- No hidden network calls, no secrets in code, no surprising side effects.
- Pin or document dependencies (in the body or `compatibility`).
- Prefer the standard library; test the script on its own.

## Organizing references
- Point to each file from `SKILL.md` **with when to read it**: "Read `references/aws.md` only if the user deploys to AWS."
- Split by variant (`aws.md`, `gcp.md`, `azure.md`) so Claude loads just one.
- Files over ~300 lines: add a table of contents at the top.

## ✍️ Exercise
Find one step in your skill that is mechanical (formatting, extracting, checking). Move it into `scripts/` and update the body to call it.

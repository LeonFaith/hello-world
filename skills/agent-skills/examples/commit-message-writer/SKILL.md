---
name: commit-message-writer
description: Writes Conventional Commit messages (feat, fix, docs, refactor...) from the user's staged git changes. Use whenever the user asks for a commit message, wants to commit their work, asks what to call a commit, or wants staged changes summarized for a commit, even if they don't mention "conventional commits". Not for pull request descriptions, release notes or changelogs.
license: MIT
metadata:
  version: 1.0.0
---

# Commit Message Writer

Produce a commit message a reviewer can understand from `git log --oneline` alone, in the Conventional Commits format so release tooling can build changelogs from it.

## Workflow
1. Run `scripts/staged_summary.sh` from the repository root. It prints the staged file list, a diff stat and the diff (truncated if huge).
2. If it reports nothing staged, stop: tell the user nothing is staged and suggest `git add <files>`. Don't invent a message from unstaged work, because it wouldn't match what gets committed.
3. Work out the **main intent** of the change. If the staged changes do clearly unrelated things, say so and suggest splitting them into separate commits, since one commit per intent keeps history easy to revert.
4. Pick the type and an optional scope. For anything unclear (breaking changes, which type fits), read `references/conventional-commits.md`.
5. Write the message in the format below and show it in a code block. Only run `git commit` if the user asked you to commit.

## Output format
```
<type>(<optional scope>): <subject>

<optional body: what changed and why, wrapped at 72 chars>

<optional footer: BREAKING CHANGE: ..., Refs #123>
```

- Subject: imperative mood ("add", not "added"), lowercase start, no trailing period, at most 72 characters so it isn't truncated in `git log` and on GitHub.
- Body: include it when the *why* isn't obvious from the subject. A typo fix doesn't need one; a behaviour change usually does.
- Follow the user's own convention if they state one or recent `git log` clearly uses another style; the team's consistency matters more than this format.

## Examples
**Staged:** new `RateLimiter` class and its use in `api/login.py`
```
feat(auth): rate-limit login attempts

Add a token-bucket RateLimiter and apply it to the login endpoint
to slow down credential-stuffing attacks (5 attempts per minute).
```

**Staged:** typo fix in `README.md`
```
docs: fix typo in installation steps
```

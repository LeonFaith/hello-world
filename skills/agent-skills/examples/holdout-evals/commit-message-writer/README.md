# Held-out evals for commit-message-writer

These cases are kept **outside** the skill folder on purpose. When Claude proposes
improvements to the skill (Lesson 8), it only sees the cases in the skill's own
`evals/` folder. These held-out cases check that an improvement is general and
not tailored to the cases the proposer saw.

| Held-out case | Checks the same idea as train case |
| --- | --- |
| `warns-api-token` | `warns-plaintext-secret` (a different kind of secret, in code) |
| `mentions-untracked-file` | `mentions-unstaged-pair-switch` (an untracked file instead of a modified one) |

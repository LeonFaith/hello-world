# Conventional Commits: quick reference

Read this only when the type, scope or breaking-change rules are unclear.

## Types
| Type | Use for |
| --- | --- |
| `feat` | A new user-facing feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `style` | Formatting, whitespace; no code meaning change |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Maintenance that doesn't fit elsewhere |
| `revert` | Reverts a previous commit |

When a change mixes a feature with its tests and docs, use the type of the main intent (`feat`); the tests and docs are part of it.

## Scope
Optional noun for the area touched: `feat(auth): ...`, `fix(api): ...`. Use the module or folder name the team already uses in `git log`. Omit it if the change is repo-wide.

## Breaking changes
Mark a change that breaks callers in either way:
- `feat(api)!: remove v1 endpoints`
- a footer: `BREAKING CHANGE: v1 endpoints are removed; use /v2.`

Use both for important breaks. Explain the migration path in the footer.

## Spec
https://www.conventionalcommits.org/en/v1.0.0/

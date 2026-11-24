# ✅ Production Skill Checklist

## Design
- [ ] The skill does **one job**, and Claude is inconsistent at it without the skill.
- [ ] I know what a great output looks like (written in `case.yaml` files).

## Frontmatter
- [ ] `name` is kebab-case, ≤ 64 chars, matches the folder name.
- [ ] `description` says **what** and **when**, includes real user phrasing, is a bit pushy, and names boundaries vs. nearby skills.
- [ ] Only allowed keys; validator passes.

## Body
- [ ] Under ~500 lines; every section changes behaviour.
- [ ] Instructions explain **why**; few or no ALL-CAPS rules.
- [ ] Exact output format + 1–2 examples where format matters.
- [ ] Edge cases covered (empty input, missing tools, ambiguity).
- [ ] Each bundled file is referenced with **when** to use it.

## Resources
- [ ] Repeated/deterministic work is in `scripts/`, with clear errors and exit codes.
- [ ] Long docs are in `references/` (TOC if > 300 lines).
- [ ] No secrets, no hidden network calls, no surprising side effects.

## Testing
- [ ] ≥ 3 eval cases: happy path, tricky input, should-refuse/ask.
- [ ] Assertions are objective and **discriminating** (fail without the skill).
- [ ] With-skill beats baseline on pass rate; time/tokens are acceptable.
- [ ] ~20 trigger prompts (half near-miss negatives) behave correctly.

## Shipping
- [ ] Reviewed in a PR with eval results.
- [ ] Version + changelog in `metadata`.
- [ ] Installed in the right place (personal / project / plugin / upload).

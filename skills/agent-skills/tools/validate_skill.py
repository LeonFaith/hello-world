#!/usr/bin/env python3
"""Validate an Agent Skill folder.

Usage: python validate_skill.py <skill-folder>
Exit code 0 = valid, 1 = problems found.
Requires: pip install pyyaml
"""
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ALLOWED = {"name", "description", "license", "allowed-tools", "metadata", "compatibility"}


def validate(folder: Path) -> list[str]:
    errors, warnings = [], []
    skill_md = folder / "SKILL.md"
    if not skill_md.is_file():
        return [f"{skill_md} not found"]

    extra = [p for p in folder.rglob("SKILL.md")
             if p != skill_md and "evals" not in p.relative_to(folder).parts[:1]]
    if extra:
        errors.append("Only one SKILL.md allowed per skill; also found: "
                      + ", ".join(str(p.relative_to(folder)) for p in extra))

    text = skill_md.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n?(.*)", text, re.DOTALL)
    if not m:
        return errors + ["SKILL.md must start with YAML frontmatter between --- lines"]
    try:
        fm = yaml.safe_load(m.group(1))
    except yaml.YAMLError as e:
        return errors + [f"Invalid YAML frontmatter: {e}"]
    if not isinstance(fm, dict):
        return errors + ["Frontmatter must be a YAML mapping"]
    body = m.group(2)

    unknown = set(fm) - ALLOWED
    if unknown:
        errors.append(f"Unknown frontmatter keys: {', '.join(sorted(unknown))}. "
                      f"Allowed: {', '.join(sorted(ALLOWED))}")

    name = fm.get("name")
    if not isinstance(name, str) or not name.strip():
        errors.append("'name' is required and must be a string")
    else:
        if not re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", name):
            errors.append(f"name '{name}' must be kebab-case (a-z, 0-9, single hyphens)")
        if len(name) > 64:
            errors.append(f"name is {len(name)} chars; max is 64")
        if name != folder.resolve().name:
            warnings.append(f"name '{name}' differs from folder name '{folder.resolve().name}'")

    desc = fm.get("description")
    if not isinstance(desc, str) or not desc.strip():
        errors.append("'description' is required and must be a string")
    else:
        if len(desc) > 1024:
            errors.append(f"description is {len(desc)} chars; max is 1024")
        if "<" in desc or ">" in desc:
            errors.append("description cannot contain < or >")
        if len(desc.split()) < 15:
            warnings.append("description is short; say what it does AND when to use it")

    comp = fm.get("compatibility")
    if comp is not None and (not isinstance(comp, str) or len(comp) > 500):
        errors.append("compatibility must be a string of at most 500 chars")

    lines = body.count("\n")
    if lines > 500:
        warnings.append(f"body is {lines} lines; consider moving detail to references/")
    caps = len(re.findall(r"\b(ALWAYS|NEVER|MUST)\b", body))
    if caps > 3:
        warnings.append(f"{caps} ALWAYS/NEVER/MUST found; explain the why instead")
    for ref in re.findall(r"`((?:scripts|references|assets)/[^`\s]+)`", body):
        if not (folder / ref).exists():
            errors.append(f"body references missing file: {ref}")

    for w in warnings:
        print(f"⚠️  {w}")
    return errors


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    problems = validate(Path(sys.argv[1]))
    for p in problems:
        print(f"❌ {p}")
    if problems:
        sys.exit(1)
    print("✅ Skill is valid")

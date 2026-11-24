# 📚 Learning Skills

A personal repository for learning new skills, tracking progress, and building small practice projects.

## Structure

| Folder | Purpose |
| --- | --- |
| [`skills/`](skills/) | One folder per skill (e.g. `skills/python/`, `skills/git/`). Copy `skills/_template/` to start a new one. |
| [`notes/`](notes/) | Daily/weekly learning log entries. |
| [`projects/`](projects/) | Small hands-on projects that put skills into practice. |
| [`resources/`](resources/) | Bookmarks, courses, books, and cheat sheets. |
| [`ROADMAP.md`](ROADMAP.md) | The skills you want to learn and where you are with each. |

## How to use it

1. Add a skill you want to learn to [`ROADMAP.md`](ROADMAP.md).
2. Start it: `cp -r skills/_template skills/<skill-name>`
3. Fill in the goals in `skills/<skill-name>/README.md`.
4. Log what you learn each session in `notes/` (see [`notes/TEMPLATE.md`](notes/TEMPLATE.md)).
5. Build something small in `projects/` to practise.
6. Commit often — your git history becomes a record of your progress:
   ```bash
   git add .
   git commit -m "Learned: <what you learned>"
   git push
   ```

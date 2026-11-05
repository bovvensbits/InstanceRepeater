# Notes for working on Instance Repeater

The rules for every agent are in AGENTS.md (shared with ChatGPT/Codex) — read and follow them:

@AGENTS.md

Claude only:
- If a local LOTRO plugin directory or device bridge is available, deploy changed plugin files there for in-game testing, but confirm the correct local path with Bovven first. Do not assume the StatsToolbox installation path applies here.
- Start every session with `git pull` and `docs/handoff.md`; another agent may have worked in between.
- At the end, commit and push all source and handoff changes to `main`.

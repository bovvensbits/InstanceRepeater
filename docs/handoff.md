# Handoff

Read at the start of every session, update at the end (newest entry at the top of "Log"). Keep it short.

## Current state (2026-11-05)

- Repository initialized for sequential Claude / ChatGPT collaboration using the same workflow as StatsToolbox.
- Shared agent rules: `AGENTS.md`; Claude entry point: `CLAUDE.md`.
- **No plugin source has been committed yet.** Earlier chat test builds (0.1 / 0.2) are not verified as present in this repository.
- No automated tests are configured yet; no LOTRO in-game tests have been run from this repository.

## Intended features

- 6-player fellowship and 12-player raid support.
- Save current party member names and retain them after relog.
- One sequential invitation Quickslot, one click per player where the game permits.
- Compact dark/gold UI, player list collapsed by default.
- Leave Instance control: investigate supported in-game interaction; do not promise direct Lua execution without proof.

## Open / ideas

- Import the latest available Instance Repeater source into the repository.
- Confirm Lua package paths and test loading in the LOTRO client.
- Verify party roster enumeration and saved data.
- Verify whether Quickslot click can reliably advance an alias; avoid skipping players.
- Investigate a truthful Leave Instance interaction or explicit fallback instructions.
- Add repeatable Lua syntax checks and UI layout tests.

## To test in game

- Plugin loads without errors.
- Compact window and expandable list do not overlap.
- 6-player and 12-player rosters are correctly captured.
- Saved roster survives relog.
- Repeated clicks on the same invitation Quickslot target successive players without skipping.
- Leave Instance button accurately reflects what it can do.

## Log

- 2026-11-05 (ChatGPT): initialized shared agent instructions and handoff based on StatsToolbox's one-agent-at-a-time, direct-to-main workflow. Source and tests not yet imported.

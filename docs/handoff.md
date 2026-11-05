# Handoff

Read at the start of every session, update at the end (newest entry at the top of "Log"). Keep it short.

## Current state (2026-11-05)

- Repository initialized for sequential Claude / ChatGPT collaboration using the same workflow as StatsToolbox.
- Shared agent rules: `AGENTS.md`; Claude entry point: `CLAUDE.md`.
- **Plugin source 0.3.0 committed:** `Bovven/InstanceRepeater/Main.lua`, `Bovven/InstanceRepeater/Theme.lua`, and `Bovven/InstanceRepeater.plugin`. Reworked from the earlier 0.2 test build. Theme uses StatsToolbox default accent, background, button fill and text RGB roles; not yet a pixel-perfect port of every StatsToolbox widget.
- No automated tests are configured yet; no LOTRO in-game tests have been run from this repository. The new UI and shortcut logic are unverified; no live-client screenshot comparison has been possible.

## Intended features

- 6-player fellowship and 12-player raid support.
- Save current party member names and retain them after relog.
- One sequential invitation Quickslot, one click per player where the game permits.
- Compact dark/gold UI, player list collapsed by default.
- Leave Instance control: investigate supported in-game interaction; do not promise direct Lua execution without proof.

## Open / ideas

- Verify the newly imported 0.3 source in the LOTRO client; refine the appearance against actual StatsToolbox screenshots. The Quickslot may display a native icon over the caption.
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

- 2026-11-05 (ChatGPT): added `Leave Group` native alias Quickslot with `/raid leave` (documented historical LOTRO chat command); adjusted compact/expanded UI height and list positioning. Not tested in current LOTRO client; validate command, click forwarding through label, and layout. Existing Leave Instance instruction remains separate.

- 2026-11-05 (ChatGPT): added right-click 'Plugin neu laden' via `~InstanceRepeaterReloader` helper plugin (unload script state, reload after frames), and changed launcher to reference exact StatsToolbox TGA core/ring/hover artwork. This means StatsToolbox assets must be installed at `Bovven/StatsToolbox/Resources/`. InstanceRepeater displays IR over the shared core. Not tested in game. Ensure helper is packaged with release.

- 2026-11-05 (ChatGPT): replaced square IR launcher styling with standalone 40x40 TGA gold ring and brighter hover variant in `Bovven/InstanceRepeater/Resources/`, preserving centered IR and StatsToolbox-style left-click/drag/right-click interaction. Artwork is a stylistic match, not the exact StatsToolbox original. Not tested in LOTRO.

- 2026-11-05 (ChatGPT): added `Bovven/InstanceRepeater/Launcher.lua`, a 40px draggable gold/dark launcher based on StatsToolbox's interaction pattern. Left-click toggles the window; right-click opens menu (toggle, roster, reset invitations, reset position, hide until reload). Per-character position persisted. Artwork is standalone 'IR' rather than StatsToolbox's textured TGA ring. Not tested in game. Check event handling and save behavior.

- 2026-11-05 (ChatGPT): moved the installable plugin to `Bovven/InstanceRepeater/` with descriptor `Bovven/InstanceRepeater.plugin`, updated Lua import and `<Package>` to `Bovven.InstanceRepeater.*`. ZIP now contains top-level `Bovven/` for installation alongside StatsToolbox. Not tested in LOTRO.

- 2026-11-05 (ChatGPT): updated Main.lua with a masked native alias Quickslot, shortcut SetData for non-ASCII names, 6/12 selector and clearer Leave Instance portrait-menu instructions. Research supports Quickslot.MouseClick alongside alias activation; LOTRO API does not expose verified direct Leave Instance. NOT tested in game. Check masked shortcut click target, overlay and progress, window sizing, mode changes, and whether Party API enumerates raids.

- 2026-11-05 (ChatGPT): added 0.3 plugin source and StatsToolbox-default-colour theme helper, compact collapsed-list UI. Not tested in LOTRO; invitation click advancement remains experimental and Leave Instance remains instructional.

- 2026-11-05 (ChatGPT): initialized shared agent instructions and handoff based on StatsToolbox's one-agent-at-a-time, direct-to-main workflow. Source and tests not yet imported.

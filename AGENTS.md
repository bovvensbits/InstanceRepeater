# Working on Instance Repeater (for every AI agent: Claude, ChatGPT/Codex, ...)

Bovven works with one agent at a time, one after the other. The repository is the shared memory between them.

## Start and end of every session

1. **Start:** `git pull` (when working locally), then read `docs/handoff.md` (current state, open points, in-game tests).
2. Work directly on `main` (only one agent works at a time — no branches needed).
3. **End:** run available tests, update `docs/handoff.md` (what changed, what remains open, what Bovven should test in game), commit with a clear message and push. Never leave work only on your machine or in a chat.
4. When using GitHub API tools instead of a local checkout, fetch the latest files and commit to `main`; verify the result and update the handoff.
5. If another agent has changed `main`, read those changes before editing; never overwrite another agent's work blindly.

## The user

- Bovven writes German; reply in German. File and folder names and identifiers in English.
- Create changelogs and release ZIPs only when Bovven asks for them. Use an explicit version number and document the contents.

## Project scope

- Instance Repeater is a Lord of the Rings Online (LOTRO) Lua plugin for saving a fellowship/raid roster (6/12 mode), preparing sequential invitations using the same Quickslot, and providing a compact UI with an expandable player list.
- The LOTRO Lua API limits automation. Do not claim that an arbitrary chat command or "Leave Instance" can be invoked from Lua without verifying an in-game-supported mechanism. A button that only displays instructions must be labeled honestly.
- Do not advance an invitation queue unless the interaction semantics are verified; document uncertain behavior as untested.
- Preserve character settings across reloads where supported. Validate names before constructing alias commands.

## Sources and building

- Source files are the source of truth. Do not edit generated builds or release ZIPs instead of source files.
- Follow the established repository layout once source files are added; keep installation paths documented in README.
- Before large edits, preserve a recoverable commit. Avoid unnecessary polling or performance cost in update loops.

## Tests

- Run any automated tests present in the repository. If none exist, explicitly state that in `docs/handoff.md`; never claim tests passed without running them.
- Validate Lua syntax where tooling is available and manually check API assumptions against LOTRO behavior.
- In-game testing is required for Quickslot activation, alias advancement, roster enumeration, saved data, and UI layout.
- New Lua modules or images may require a full relog; do not assume a plugin reload imports them again.

## Look and behaviour

- Compact, consistent LOTRO-inspired dark/gold interface.
- Player list collapsed by default; expand only when needed.
- One persistent invitation control for the next saved player; visible progress and reset.
- No overlapping labels or buttons; test both 6-player and 12-player rosters.
- Keep UI labels and game-facing behavior honest about technical limitations.

# Next

Scratch notes from `os-notes.txt` land here after triage.
Dump obstacles in that file, then hand it over. This page is the working
list. Done items move into `goals.md` / `binds.md` and come off this page.

| Want | Who | Status |
|------|-----|--------|
| Messages links open a logged-in Chrome | you confirm | waiting: click a link in Messages |
| Bitwarden: try the desktop app | you (login); agent can `pkg add` | you |
| Super+F maximize (match Novalis) | you confirm (`hyprctl reload`) | applied 2026-09-08 |
| Focus follows mouse into Grok Bot | explained | 2026-09-26, see below |
| Clock plate instead of a type outline | applied | 2026-09-26 |
| Obsidian vault in Projects | done | moved 2026-09-26 |

## Messages links open a logged-in Chrome

Applied: the webapp Chrome dir is now a single signed-in `Default`
profile (`scripts/collapse-webapp-profile.sh`, launchers pass
`--profile-directory=Default`). Confirm by clicking a link in Messages.

If the window is still the "wrong Chrome", that is a second browser, not
Super+W. Real PWAs from the main profile would share it, but we already
avoided `--app-id` because those draw a CSD title bar.

## Bitwarden: try the desktop app

The Chrome extension is a separate install in every Chrome profile. The
webapp Chrome is not the Super+W Chrome, so the extension there is a
second copy and a common source of "it is buggy."

Official desktop app is `extra/bitwarden`. Enable **Settings → App
settings → Enable browser integration**, then the extension unlocks
through the native host instead of living on its own.

Agent can `omarchy pkg add bitwarden`. You install/login, turn on
browser integration, and see if the extension stops being weird.

More "OS-shaped" and optional: `rbw` (CLI). Skip unless the desktop app
is also annoying. Omarchy's 1Password installer is unrelated.

## Focus follows mouse into Grok Bot

Hyprland is not skipping Grok Bot. `input:follow_mouse` is 1 for every
window except JetBrains (`no_follow_mouse`). The live window is a normal
tiled Wayland client: class `grok-bot`, `acceptsInput` true, no focus rule.

Two things make it feel different from a Chrome web app:

- Grok Bot 0.29.0 is Electron 42, frameless on Linux (`frame: false`) with
  Wayland window decorations turned on. Chrome web apps are ordinary
  Chrome windows. Hover moves Hyprland's focus to either of them. Electron
  often does not put the caret in the page until a click, so the border
  can change while typing still goes to the window you left.
- Scrolling layout will not slide a column into view on hover unless at
  least 40% of it is on screen (`scrolling:follow_min_visible`, stock
  0.4). Grok Bot opened at about a quarter of this 3840-wide panel, so
  hovering it focuses the sliver and leaves the web app column where it
  is. A click, or Super+Left/Right, pulls it in.

## Clock plate instead of a type outline

Applied 2026-09-26. The date/time sits on a solid `#161C22` plate, white,
normal weight. The demibold outline is gone. The bar plugin hot-reloads;
`omarchy-shell shell rescanPlugins` if the old outline is still up.

## Obsidian vault in Projects

Moved 2026-09-26 from `~/Documents/Obsidian Vault` to
`~/Projects/obsidian`. Obsidian's vault list points at the new path.
The git remote is unchanged.

## Super+F maximize (match Novalis)

Applied 2026-09-08. Super+F is
`hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })`.
Novalis Super+F is `maximize-column`. Super+Ctrl+F stays windowed
fullscreen; Super+Alt+F stays full width; Super+Shift+F stays files.
Run `hyprctl reload` on this machine to pick it up.

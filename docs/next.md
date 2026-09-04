# Next

Scratch notes from `os-notes.txt` land here after triage.
Dump obstacles in that file, then hand it over. This page is the working
list. Done items move into `goals.md` / `binds.md` and come off this page.

| Want | Who | Status |
|------|-----|--------|
| Messages links open a logged-in Chrome | you confirm | waiting: click a link in Messages |
| Bitwarden: try the desktop app | you (login); agent can `pkg add` | you |

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

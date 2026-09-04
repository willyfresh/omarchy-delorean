# Next

Scratch notes from `os-notes.txt` land here after triage.
Dump obstacles in that file, then hand it over. This page is the working
list. Done items move into `goals.md` / `binds.md` and come off this page.

| Want | Who | Status |
|------|-----|--------|
| Messages links open a logged-in Chrome | agent first, you confirm | needs a small experiment |
| Bitwarden: try the desktop app | you (login); agent can `pkg add` | you |
| Toggle the trackpad, keep the stick | agent | decided, need a chord |

## Messages links open a logged-in Chrome

Webapps run in a second Chrome at `~/.local/share/delorean/chrome-webapps`
so `--app=URL` cookies survive close. That dir has two profiles:

- `Delorean` — signed in as `willyfresh@gmail.com` (what the launchers use)
- `Default` ("Your Chrome") — nobody signed in

A link out of Messages is almost certainly opening a full browser window
in that empty `Default`, not Super+W's real Chrome
(`~/.config/google-chrome/Default`, profile "Will").

`--app` windows handle http(s) inside their own user-data-dir; an
xdg-open wrapper will not catch this.

Likely fix (agent): collapse the webapp dir to one signed-in profile
(make `Delorean` the only `Default` there, or stop passing
`--profile-directory=Delorean`). Then a link stays in the signed-in
session. You confirm by clicking a link in Messages.

Fallback if the window is still the "wrong Chrome": that is a second
browser, not Super+W. Real PWAs installed from the main profile would
share it, but we already avoided `--app-id` because those draw a CSD
title bar.

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

## Toggle the trackpad, keep the stick

P50 devices:

| Hyprland name | What |
|---------------|------|
| `synaptics-tm3149-002` | clickpad (motion + pad clicks) |
| `tpps/2-ibm-trackpoint` | stick **and** the three physical buttons |

Disabling the Synaptics device is the split you want.

Stock Omarchy already binds `XF86TouchpadToggle` / Hardware → Touchpad
to `omarchy-toggle-touchpad`. That helper only matches a mouse whose
name contains `touchpad` or `trackpad`. This Synaptics matches neither,
so the Fn key and the menu item are no-ops on this machine.

Agent: overlay a toggle that targets `synaptics-tm3149-002` (same persist
pattern as `omarchy-toggle-input-device`), and bind it. Super+R is free
(we unbound it; was unused). Fn/Hardware can wait until the detector
sees this device.

You: after it lands, confirm the stick and the three buttons still
click while the pad is dead.

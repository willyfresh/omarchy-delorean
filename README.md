# Delorean

Personal Omarchy overlay for this machine (`DeLorean`, ThinkPad P50).

Omarchy stays the desktop. This repo is only the muscle memory and look that
were worth keeping from the CachyOS experiment in `~/Projects/cachyos`.

## What it changes

- **Keys:** Super-alone launcher, Super+Q / Alt+F4 close, Shift+Insert paste,
  Super+W browser, Super+T VS Code, Super+E files, Super+Shift+E Thunderbird,
  Super+L lock, plus a few app launches. Super+Tab is Mirador workspace
  overview. Super+arrows walk windows then occupied desks; Shift sends the
  window; Ctrl swaps on this desk. CapsLock is Caps Lock; both Shifts
  together start an XCompose sequence. Collision table: [docs/binds.md](docs/binds.md).
- **Theme:** `delorean` — flux cyan, time-circuit amber, stainless black.

Everything else is stock Omarchy (ten workspaces, bar, menus, capture, idle).
Install extra software with `omarchy pkg add` / `omarchy install` when you want it.

## Apply

```bash
~/Projects/delorean/scripts/apply.sh --theme
```

That symlinks this repo into `~/.config/hypr/bindings.lua`,
`~/.config/hypr/input.lua`, `~/.config/xkb`, and
`~/.config/omarchy/themes/delorean`, reloads Hyprland, and sets the theme.

Add this account to the docker group (sudo in a real terminal; takes effect
after a new login):

```bash
~/Projects/delorean/scripts/docker-group.sh
```

## Layout

```
config/hypr/bindings.lua                 # keybinding overrides
config/hypr/input.lua                    # CapsLock + both-Shifts Compose
config/hypr/windows.lua                  # Super+arrows focus/move; tile on current workspace
config/xkb/                              # custom XKB option for Compose
config/omarchy/plugins/delorean.tray/    # tray: all icons visible, no overflow drawer
config/applications/                     # --app=URL launchers (no PWA title bar)
config/omarchy/themes/delorean/          # custom Omarchy theme
  backgrounds/                           # wallpapers, kept in git
    1-gullwing-night.jpg
    2-highway-cyan.jpg
    3-brushed-steel.jpg
    4-eighty-eight.jpg
    5-flux-capacitor.jpg
scripts/apply.sh
scripts/docker-group.sh
docs/goals.md
docs/binds.md
docs/next.md                            # working list; dump obstacles in os-notes.txt
os-notes.txt                            # scratch inbox, emptied after triage
```

Do not edit `/usr/share/omarchy/`. Do not fork Omarchy.

## Source material

`~/Projects/cachyos` is the archive of the CachyOS + Noctalia attempt. Leave it
alone. Goals and binds here are the distilled version for an Omarchy host.

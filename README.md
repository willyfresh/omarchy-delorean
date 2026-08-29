# Delorean

Personal Omarchy overlay for this machine (`DeLorean`, ThinkPad P50).

Omarchy stays the desktop. This repo is only the muscle memory and look that
were worth keeping from the CachyOS experiment in `~/Projects/cachyos`.

## What it changes

- **Keys:** Super-alone launcher, Super+Q / Alt+F4 close, Shift+Insert paste,
  Super+W browser, Super+T VS Code, Super+E files, Super+Shift+E Thunderbird,
  Super+L lock, plus a few app launches. Collision table: [docs/binds.md](docs/binds.md).
- **Theme:** `delorean` — flux cyan, time-circuit amber, stainless black.

Everything else is stock Omarchy (ten workspaces, bar, menus, capture, idle).
Install extra software with `omarchy pkg add` / `omarchy install` when you want it.

## Apply

```bash
~/Projects/delorean/scripts/apply.sh --theme
```

That symlinks this repo into `~/.config/hypr/bindings.lua` and
`~/.config/omarchy/themes/delorean`, reloads Hyprland, and sets the theme.

## Layout

```
config/hypr/bindings.lua                 # the only Hyprland override
config/omarchy/themes/delorean/          # custom Omarchy theme
scripts/apply.sh
docs/goals.md
docs/binds.md
```

Do not edit `/usr/share/omarchy/`. Do not fork Omarchy.

## Source material

`~/Projects/cachyos` is the archive of the CachyOS + Noctalia attempt. Leave it
alone. Goals and binds here are the distilled version for an Omarchy host.

# Delorean

Personal Omarchy overlay for this machine (`DeLorean`, ThinkPad P50).

Omarchy stays the desktop. This repo is the muscle memory and look on top.

## What it changes

- **Keys:** Super-alone launcher, Super+Q / Alt+F4 close, Shift+Insert paste,
  Super+E files, Super+L lock. Apps start or focus on Super+Shift+letter
  (W Chrome, T VS Code, D Discord, E Thunderbird, G Gmail, C Calendar,
  B Board Game Arena, M Messages, L Maps, O LibreOffice, Y Music then
  YouTube, I Inkscape, P GIMP). Super+Tab is Mirador workspace overview.
  Super+period toggles the clickpad (stick stays). Super+arrows walk
  windows then occupied desks (Left/Right stay on this desk; Shift+Up/Down
  send+follow to numbered desks; Shift+Left/Right swap on this desk). Ctrl
  swaps too. CapsLock is Caps Lock; both Shifts together start an XCompose
  sequence. Collision table: [docs/binds.md](docs/binds.md).
- **Theme:** `delorean` — flux cyan, time-circuit amber, stainless black.
- **Layout:** Hyprland dwindle tiling (stock). Super+Ctrl+L still toggles
  this desk to scrolling.

Everything else is stock Omarchy (ten workspaces, bar, menus, capture, idle).
Install extra software with `omarchy pkg add` / `omarchy install` when you want it.

## Apply

```bash
~/Projects/delorean/scripts/apply.sh --theme
```

That uses GNU Stow to link `config/` into `~/.config` (the package
tree mirrors the config directory; `applications/` is copied, not
stowed, because those launchers keep other names), reloads Hyprland,
and sets the theme. Needs `stow` (`omarchy pkg add stow`).

Add this account to the docker group (sudo in a real terminal; takes effect
after a new login):

```bash
~/Projects/delorean/scripts/docker-group.sh
```

## Layout

```
config/.stow-local-ignore               # stow skips applications/
config/hypr/bindings.lua                 # keybinding overrides
config/hypr/input.lua                    # CapsLock + both-Shifts Compose
config/hypr/looknfeel.lua                # dwindle tiling (stock default)
config/hypr/windows.lua                  # Super+arrows focus/move; tile on current workspace
config/xkb/                              # custom XKB option for Compose
config/omarchy/plugins/delorean.tray/    # tray: all icons visible, no overflow drawer
config/omarchy/plugins/delorean.clock/   # date/time: white on a solid plate
config/applications/                     # --app=URL launchers (no PWA title bar)
scripts/launch-youtube.sh                # Super+Shift+Y: Music, then YouTube
config/omarchy/themes/delorean/          # custom Omarchy theme
  backgrounds/                           # wallpapers, kept in git
    1-gullwing-night.jpg
    2-highway-cyan.jpg
    3-brushed-steel.jpg
    4-eighty-eight.jpg
    5-flux-capacitor.jpg
scripts/apply.sh                         # stow config/ into ~/.config
scripts/docker-group.sh
scripts/toggle-trackpad.sh
scripts/neomutt-icat.sh                  # kitty image preview for NeoMutt
scripts/collapse-webapp-profile.sh
docs/goals.md
docs/binds.md
docs/next.md                            # working list; dump obstacles in os-notes.txt
os-notes.txt                            # scratch inbox, emptied after triage
```

Do not edit `/usr/share/omarchy/`. Do not fork Omarchy.

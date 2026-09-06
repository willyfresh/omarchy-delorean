# Goals

North star: keep Omarchy, overlay KDE habits plus a few app keys, and a
DeLorean theme. Not a distro fork.

## From KDE

| Want | How |
|------|-----|
| Super alone opens the launcher | Super release → `omarchy-menu toggle` (Super+Space still does too) |
| Alt+F4 closes the window | Added; Super+Q added too (Omarchy 4 only closed on Super+W) |
| Shift+Insert pastes | Terminal-aware paste (Ctrl+V in GUI) |
| Super+V clipboard history | Omarchy clipboard overlay (was Super+Ctrl+V) |
| CapsLock is Caps Lock | Overlay `input.lua` + `config/xkb`; Compose is both Shifts together |

## App keys

| Want | How |
|------|-----|
| Super+W browser | Chrome is already the xdg default |
| Super+T VS Code | Float moves to Super+Alt+T |
| Super+E file manager | Nautilus; Super+Shift+F stays |
| Super+L lock | Layout toggle moves to Super+Ctrl+L |
| Discord | Super+D native `discord` client (webapp logged out on close) |
| Google Messages | Super+Shift+Return (was a redundant Browser) |
| Board Game Arena | Super+Shift+B (was a redundant Browser) |
| Gmail | Super+Shift+G (was Signal); title-less `--app=URL` like Maps |
| Google Calendar | Super+Shift+C (was HEY Calendar) |
| LibreOffice | Super+O |
| Thunderbird | Super+Shift+E; compose is Super+Shift+Alt+E |
| Apps stay on the current workspace | New windows stay on this desk. Tried empty-workspace placement; did not keep it |
| Scrolling windows | Default layout is Hyprland scrolling (niri-like columns). Super+Ctrl+L still toggles this desk to dwindle |

## From Windows

| Want | How |
|------|-----|
| Super+arrows walk windows, then the next desk | Edge of the workspace → previous (left/up) or next (right/down) occupied workspace. Super+Tab is overview. |
| Super+Shift+arrows move the window between desks | Adjacent numbered workspace, 1–10, wrap, follow. Super+Shift+1..0 still target a number. |
| Super+Ctrl+arrows rearrange on this desk | Swap with the neighbor. Group cycle stays Super+Alt+Tab. |
| Alt+Tab as on Windows | MRU across desks, hold Alt to walk, release to stay. No thumbnail strip. |
| Super+Tab overview | Mirador plugin (`omarchy plugin add` of sanjyay/Mirador). Super+Shift+Tab still previous desk. |
| Super+period toggles the clickpad | `scripts/toggle-trackpad.sh` disables `synaptics-tm3149-002`. Stick and its three buttons stay. |

## Already Omarchy — do not reimplement

Ten workspaces on Super+1..0, Super+Q close,
Super+Return terminal, Super+S scratchpad (Super+Shift+S parks a window),
Super+F fullscreen, workspace 10 labeled 0 on the bar, bar pins 1–5.

## Look

Custom Omarchy theme `delorean`: flux cyan `#5AD4FF`, time-circuit amber
`#FFB000`, taillight red `#E53935`, stainless black `#0A0C0E`.

## Out of scope until we say so

- Cloning `omarchy.workspaces` to pin 1–4 instead of 1–5
- Extra hotkeys we have not asked for
- Branding ASCII, monitor/dock profiles, NVIDIA/PRIME
- Super+C / Super+V / Super+X (keep Omarchy clipboard; calculator stays Super+Ctrl+Q)
- Super+Shift+W wallpaper (keep Omawrite; Super+Ctrl+Space cycles backgrounds)

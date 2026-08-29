# Goals

North star: keep Omarchy, overlay KDE habits plus a few app keys, and a
DeLorean theme. Not a distro fork.

`~/Projects/cachyos` was the previous attempt (rebuild Omarchy on CachyOS).
Too much. This repo is the inverse.

## From KDE

| Want | How |
|------|-----|
| Super alone opens the launcher | Super release → `omarchy-menu toggle` (Super+Space still does too) |
| Alt+F4 closes the window | Added; Super+Q added too (Omarchy 4 only closed on Super+W) |
| Shift+Insert pastes | Terminal-aware paste (Ctrl+V in GUI) |

## From the Cachy overlay (apps, not a desktop rewrite)

| Want | How |
|------|-----|
| Super+W browser | Chrome is already the xdg default |
| Super+T VS Code | Float moves to Super+Alt+T |
| Super+E file manager | Nautilus; Super+Shift+F stays |
| Super+L lock | Layout toggle moves to Super+Ctrl+L |
| Discord | Super+D (Omarchy webapp) |
| LibreOffice | Super+O |
| Thunderbird | Super+Shift+E; compose is Super+Shift+Alt+E |

## Already Omarchy — do not reimplement

Ten workspaces on Super+1..0, Super+Tab workspace cycle, Super+Q close,
Super+Return terminal, Super+S scratchpad, Super+F fullscreen, Super+arrows
focus, workspace 10 labeled 0 on the bar, bar pins 1–5.

## Look

Custom Omarchy theme `delorean`: flux cyan `#5AD4FF`, time-circuit amber
`#FFB000`, taillight red `#E53935`, stainless black `#0A0C0E`.

## Out of scope until we say so

- Cloning `omarchy.workspaces` to pin 1–4 instead of 1–5
- Extra hotkeys from the Cachy “feasible” list
- Branding ASCII, monitor/dock profiles, NVIDIA/PRIME
- Super+C / Super+V / Super+X (keep Omarchy clipboard; calculator stays Super+Ctrl+Q)
- Super+Shift+W wallpaper (keep Omawrite; Super+Ctrl+Space cycles backgrounds)

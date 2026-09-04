# Bind overlay

User files: `config/hypr/bindings.lua` and `config/hypr/input.lua`
(plus `config/xkb` for the Compose option) → the matching paths under `~/.config`.
Omarchy defaults stay loaded. Every stolen key is unbound first.

| Key | Was (Omarchy) | Becomes | Displacement |
|-----|---------------|---------|--------------|
| Super (release SUPER_L/R) | unbound | Launcher | Super+Space still launcher |
| Alt+F4 | unbound | Close window | Super+Q still close |
| Shift+Insert | unbound | Paste | Super+Ctrl+V also universal paste |
| Super+V | Universal paste | Clipboard manager | Super+Ctrl+V is paste; Super+C/X stay copy/cut |
| Shift+Delete | unbound | Cut | Super+X still Omarchy cut |
| Super+W | Close window | Browser | Close is Super+Q + Alt+F4 (Super+Q is added; Omarchy 4 had no Super+Q) |
| Super+T | Toggle float | VS Code | Float is Super+Alt+T |
| Super+E | unbound | File manager | Super+Shift+F stays |
| Super+Shift+E | HEY Email | Thunderbird | Super+R stays unbound |
| Super+Shift+Alt+E | HEY new message | Thunderbird compose | `thunderbird -compose` |
| Super+L | Toggle workspace layout | Lock | Layout is Super+Ctrl+L |
| Super+Ctrl+L | Lock | Toggle workspace layout | swapped with Super+L |
| Super+D | unbound | Discord (native client) | Super+Shift+D is Docker TUI; webapp logged out on close |
| Super+Shift+D | LazyDocker, then Discord | Docker TUI (stock) | Discord moved to Super+D |
| Super+S | Toggle scratchpad | Same, but notify if empty | Super+Shift+S parks a window |
| Super+Shift+S | Google Maps | Move window to scratchpad | Super+Alt+S still parks too |
| Super+Shift+M | Music (Spotify) | Google Maps | Music TUI stays Super+Shift+Alt+M |
| Super+M | unbound | YouTube Music | Super+Shift+Y still YouTube |
| Super+Shift+B | Browser | Board Game Arena | Super+W still browser; Super+Shift+Alt+B still private |
| Super+Shift+Return | Browser | Google Messages | Super+Shift+Ctrl+G still Messages |
| Super+Shift+G | Signal | Gmail | Super+Shift+E still Thunderbird; WhatsApp is Super+Shift+Alt+G. Focus uses the Chrome app class so Thunderbird `@gmail.com` does not steal it. |
| Super+Shift+C | HEY Calendar | Google Calendar | Super+C still universal copy |
| Super+O | Pop window out | LibreOffice | Pop-out is Super+Shift+O |
| Super+Shift+O | Obsidian, then LibreOffice | Pop window out | LibreOffice is Super+O |
| Super+Tab | Next workspace | Mirador workspace overview | Super+Shift+Tab still previous desk; Super+Ctrl+Tab still former desk |
| Super+arrows | Focus in that direction | Focus, then occupied workspace at the edge | Super+Tab is overview now; left/up = previous occupied desk, right/down = next |
| Super+Shift+arrows | Swap window in that direction | Move window to adjacent numbered workspace (1–10, wrap, follow) | Super+Shift+1..0 still jump to a number; in-workspace shuffle is Super+Ctrl+arrows |
| Super+Ctrl+arrows | Grouped window focus (left/right only) | Swap with neighbor on this workspace | Super+Alt+Tab still cycles a group; Super+G still toggles grouping |
| Alt+Tab / Alt+Shift+Tab | Cycle next/prev window on this desk | MRU across all regular workspaces; hold Alt and tap Tab; release Alt to stay | No thumbnail overlay. Super+Tab is Mirador |
| CapsLock | Compose (XCompose) | Caps Lock | Compose is both Shifts together |
| Both Shifts together | Caps Lock (self-clearing) | Compose (Multi_key) | CapsLock is Caps Lock again |

Web apps: title-less `--app=URL` windows via `scripts/launch-webapp.sh`,
which uses a dedicated Chrome profile at `~/.local/share/delorean/chrome-webapps`.
Default-profile `--app` windows drop site data when closed. Log in once in
the new profile; after that BGA/Messages/Gmail/Maps/Calendar/YouTube Music persist.

New windows tile on the current workspace (stock). Super+1..0 jump to a
numbered desk; Super+Tab opens Mirador. Super+arrows walk windows, then
occupied desks. Overlay lua is a symlink; after editing run `hyprctl reload`.

Kept on purpose:

- Super+C / Super+X — Omarchy universal copy/cut (paste is Super+Ctrl+V and Shift+Insert)
- Super+Shift+W — Omawrite (wallpaper is Super+Ctrl+Space)
- Super+Q, Super+Return, Super+1..0, Super+Shift+Tab, Super+F, Super+arrows

Scratchpad: Super+Shift+S (and Super+Alt+S) send the focused window to a
hidden workspace (`special:scratchpad`). Super+S slides that workspace
on/off. It is not a panel or a dock — if nothing has been parked, Super+S
has nothing to show.

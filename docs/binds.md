# Bind overlay

User file: `config/hypr/bindings.lua` → `~/.config/hypr/bindings.lua`.
Omarchy defaults stay loaded. Every stolen key is unbound first.

| Key | Was (Omarchy) | Becomes | Displacement |
|-----|---------------|---------|--------------|
| Super (release SUPER_L/R) | unbound | Launcher | Super+Space still launcher |
| Alt+F4 | unbound | Close window | Super+Q still close |
| Shift+Insert | unbound | Paste | Super+V still Omarchy paste |
| Shift+Delete | unbound | Cut | Super+X still Omarchy cut |
| Super+W | Close window | Browser | Close is Super+Q + Alt+F4 (Super+Q is added; Omarchy 4 had no Super+Q) |
| Super+T | Toggle float | VS Code | Float is Super+Alt+T |
| Super+E | unbound | File manager | Super+Shift+F stays |
| Super+Shift+E | HEY Email | Thunderbird | Super+R stays unbound |
| Super+Shift+Alt+E | HEY new message | Thunderbird compose | `thunderbird -compose` |
| Super+L | Toggle workspace layout | Lock | Layout is Super+Ctrl+L |
| Super+Ctrl+L | Lock | Toggle workspace layout | swapped with Super+L |
| Super+D | unbound | Discord webapp | Super+Shift+D is Docker TUI again |
| Super+Shift+D | LazyDocker, then Discord | Docker TUI (stock) | Discord moved to Super+D |
| Super+S | Toggle scratchpad | Same, but notify if empty | Super+Alt+S still parks a window |
| Super+O | Pop window out | LibreOffice | Pop-out is Super+Shift+O |
| Super+Shift+O | Obsidian, then LibreOffice | Pop window out | LibreOffice is Super+O |

Kept on purpose:

- Super+C / Super+V / Super+X — Omarchy universal clipboard
- Super+Shift+W — Omawrite (wallpaper is Super+Ctrl+Space)
- Super+Q, Super+Return, Super+1..0, Super+Tab, Super+F, Super+arrows

Scratchpad: Super+Alt+S sends the focused window to a hidden workspace
(`special:scratchpad`). Super+S slides that workspace on/off. It is not a
panel or a dock — if nothing has been parked, Super+S has nothing to show.

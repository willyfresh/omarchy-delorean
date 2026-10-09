-- Delorean overlay — personal Omarchy keybinding overrides.
-- Loaded after Omarchy defaults from ~/.config/hypr/hyprland.lua.
-- Unbind a default before replacing it. See docs/binds.md.

require("hypr.windows")

-- Persistent title-less Chrome apps (dedicated profile, not Default --app).
local webapp = os.getenv("HOME") .. "/Projects/delorean/scripts/launch-or-focus-webapp.sh"
local scripts = os.getenv("HOME") .. "/Projects/delorean/scripts"

-- Terminal-aware paste, same helper Omarchy uses for Super+V
-- (default/hypr/bindings/clipboard.lua). Shift+Insert is the KDE habit.
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

-- Super alone (release) opens the launcher. Super+Space still does too.
o.bind("SUPER + SUPER_L", "Launcher", "omarchy-menu toggle", { release = true })
o.bind("SUPER + SUPER_R", "Launcher", "omarchy-menu toggle", { release = true })

-- Alt+F4 closes. Super+Q still closes.
o.bind("ALT + F4", "Close window", hl.dsp.window.close())

-- Shift+Insert pastes, Shift+Delete cuts. Super+V is KDE clipboard history;
-- Super+Ctrl+V takes Omarchy's universal paste. Super+C/X stay copy/cut.
o.bind("SHIFT + Insert", "Paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
o.bind("SHIFT + Delete", "Cut", send_shortcut_once("CTRL", "X"))
hl.unbind("SUPER + V") -- was: universal paste
hl.unbind("SUPER + CTRL + V") -- was: clipboard manager
o.bind("SUPER + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
o.bind("SUPER + CTRL + V", "Universal paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))

-- Super+W was stock close, then browser. Keep it unbound so old
-- Super+W-for-browser muscle memory does not close a window. Close is
-- Super+Q + Alt+F4. Browser is Super+Shift+W.
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Super+T was VS Code. Float comes back (stock); Super+Alt+T is gone.
-- VS Code is Super+Shift+T.
hl.unbind("SUPER + T")
hl.unbind("SUPER + ALT + T")
o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- Super+F was Omarchy exclusive fullscreen. Maximize matches Novalis
-- Super+F (maximize-column). Super+Ctrl+F stays windowed fullscreen;
-- Super+Alt+F stays full width; Super+Shift+F stays files.
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Maximize window", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Super+E is free in stock Omarchy. Super+Shift+F still opens files too.
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })

-- Super+Shift+E was HEY Email. Thunderbird takes it; Super+R stays unbound.
hl.unbind("SUPER + R")
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Thunderbird", { launch = "thunderbird", focus = "thunderbird" })

-- Super+Shift+Alt+E was HEY new message.
hl.unbind("SUPER + SHIFT + ALT + E")
o.bind("SUPER + SHIFT + ALT + E", "New Thunderbird message", { launch = "thunderbird -compose" })

-- Swap lock and workspace-layout with KDE Super+L = lock.
hl.unbind("SUPER + L")
hl.unbind("SUPER + CTRL + L")
o.bind("SUPER + L", "Lock system", "omarchy-system-lock")
o.bind("SUPER + CTRL + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Scratchpad is a hidden special workspace, not a panel. Super+Shift+S parks
-- the focused window there; Super+S shows/hides it. Super+Alt+S still parks
-- too (stock). Empty toggle is a no-op in Hyprland, so say so instead of
-- looking broken.
local function toggle_scratchpad()
  local ws = hl.get_workspace("special:scratchpad")
  if not ws or (ws.windows or 0) == 0 then
    hl.exec_cmd("omarchy-notification-send -u low 'Scratchpad is empty. Super+Shift+S parks a window here.'")
    return
  end
  hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
end

hl.unbind("SUPER + S") -- was: toggle scratchpad (same key, empty-aware)
o.bind("SUPER + S", "Toggle scratchpad", toggle_scratchpad)

-- Super+Shift+S was Google Maps. Scratch send keeps it (Steam is Novalis-only).
hl.unbind("SUPER + SHIFT + S") -- was: Google Maps
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Super+Shift letter apps: start or focus, same chords as Novalis.
-- Super-letter stays window management (float, pop-out, scratchpad, files).
hl.unbind("SUPER + D") -- was: Discord
hl.unbind("SUPER + M") -- was: YouTube Music

hl.unbind("SUPER + SHIFT + W") -- was: Omawrite
o.bind("SUPER + SHIFT + W", "Browser", { launch = "google-chrome-stable", focus = "^google-chrome$" })
o.bind("SUPER + SHIFT + ALT + W", "Omawrite", { launch = "omawrite" })

o.bind("SUPER + SHIFT + T", "VS Code", { launch = "code", focus = "^[Cc]ode$" })

-- Super+Shift+D was Docker TUI. Discord takes it (updater splash is also
-- class discord, so do not use launch-or-focus). Docker moves to Alt.
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Discord", scripts .. "/launch-discord.sh")
o.bind("SUPER + SHIFT + ALT + D", "Docker", { tui = "omarchy-launch-docker-tui" })

-- Super+O was LibreOffice. Pop-out comes back (stock). LibreOffice is
-- Super+Shift+O (was Obsidian, then pop-out).
hl.unbind("SUPER + O")
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
o.bind("SUPER + SHIFT + O", "LibreOffice", { launch = "libreoffice", focus = "(libreoffice|soffice)" })

hl.unbind("SUPER + SHIFT + M") -- was: Music (Spotify), then Maps
o.bind("SUPER + SHIFT + M", "Google Messages", webapp .. " chrome-messages.google.com.*Default https://messages.google.com/web/conversations")
hl.unbind("SUPER + SHIFT + RETURN") -- was: Browser, then Messages
hl.unbind("SUPER + SHIFT + CTRL + G") -- was: Google Messages (stock, Default-profile --app)
o.bind("SUPER + SHIFT + CTRL + G", "Google Messages", webapp .. " chrome-messages.google.com.*Default https://messages.google.com/web/conversations")

o.bind("SUPER + SHIFT + L", "Google Maps", webapp .. " chrome-maps.google.com.*Default https://maps.google.com/")

-- Super+Shift+B was a second Browser. BGA takes it. Super+Shift+Alt+B stays private.
hl.unbind("SUPER + SHIFT + B") -- was: Browser
o.bind("SUPER + SHIFT + B", "Board Game Arena", webapp .. " chrome-boardgamearena.com.*Default https://boardgamearena.com/")

-- Super+Shift+G was Signal. Gmail takes it (title-less --app=URL).
-- Focus by Chrome app class, not the label "Gmail": launch-or-focus matches
-- titles too, and Thunderbird's "willyfresh@gmail.com" has a \bGmail\b hit.
hl.unbind("SUPER + SHIFT + G") -- was: Signal
o.bind("SUPER + SHIFT + G", "Gmail", webapp .. " chrome-mail.google.com.*Default https://mail.google.com/")

-- Super+Shift+C was HEY Calendar. Super+C stays Omarchy clipboard.
hl.unbind("SUPER + SHIFT + C") -- was: HEY Calendar
o.bind("SUPER + SHIFT + C", "Google Calendar", webapp .. " chrome-calendar.google.com.*Default https://calendar.google.com/")

hl.unbind("SUPER + SHIFT + Y") -- was: YouTube
o.bind("SUPER + SHIFT + Y", "YouTube Music, then YouTube", scripts .. "/launch-youtube.sh")

hl.unbind("SUPER + SHIFT + P") -- was: Google Photos
o.bind("SUPER + SHIFT + P", "GIMP", { launch = "gimp", focus = "gimp" })

o.bind("SUPER + SHIFT + I", "Inkscape", { launch = "inkscape", focus = "inkscape" })

-- Super+Tab was next workspace. Mirador is the workspace overview; Super+Shift+Tab
-- still goes to the previous occupied desk.
hl.unbind("SUPER + TAB")
o.bind("SUPER + TAB", "Workspace overview", "omarchy-shell shell toggle mirador '{}'")

-- Super+period toggles the clickpad; the stick and its three buttons stay.
-- Super+Ctrl+period remains Transcode. xkbcommon names the key "period".
o.bind("SUPER + period", "Toggle trackpad", scripts .. "/toggle-trackpad.sh")

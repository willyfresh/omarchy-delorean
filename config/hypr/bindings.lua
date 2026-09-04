-- Delorean overlay — personal Omarchy keybinding overrides.
-- Loaded after Omarchy defaults from ~/.config/hypr/hyprland.lua.
-- Unbind a default before replacing it. See docs/binds.md.

require("hypr.windows")

-- Persistent title-less Chrome apps (dedicated profile, not Default --app).
local webapp = os.getenv("HOME") .. "/Projects/delorean/scripts/launch-or-focus-webapp.sh"

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

-- Super+W was the only stock close chord in Omarchy 4. Browser takes Super+W;
-- Super+Q is the close we actually want (same as the Cachy overlay). Alt+F4 too.
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Browser", { omarchy = "browser" })
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Super+T was toggle float. Float moves to Super+Alt+T.
hl.unbind("SUPER + T")
o.bind("SUPER + T", "VS Code", { launch = "code", focus = "^[Cc]ode$" })
o.bind("SUPER + ALT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- Super+E is free in stock Omarchy. Super+Shift+F still opens files too.
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })

-- Super+Shift+E was HEY Email. Thunderbird takes it; Super+R stays unbound.
hl.unbind("SUPER + R")
hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Thunderbird", { launch = "thunderbird", focus = "thunderbird" })

-- Super+Shift+Alt+E was HEY new message.
hl.unbind("SUPER + SHIFT + ALT + E")
o.bind("SUPER + SHIFT + ALT + E", "New Thunderbird message", { launch = "thunderbird -compose" })

-- Swap lock and workspace-layout with Cachy/KDE Super+L = lock.
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

-- Super+Shift+S was Google Maps. Scratch send takes it; Maps moves to
-- Super+Shift+M (was Spotify). Super+M (was free) is YouTube Music, not
-- Spotify. Super+Shift+Y stays stock YouTube.
hl.unbind("SUPER + SHIFT + S") -- was: Google Maps
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.unbind("SUPER + SHIFT + M") -- was: Music (Spotify)
o.bind("SUPER + SHIFT + M", "Google Maps", webapp .. " chrome-maps.google.com.*Delorean https://maps.google.com/")
o.bind("SUPER + M", "YouTube Music", webapp .. " chrome-music.youtube.com.*Delorean https://music.youtube.com/")

-- Super+Shift+B was a second Browser (Super+W still opens Chrome). BGA takes
-- it. Super+Shift+Alt+B stays private browser.
hl.unbind("SUPER + SHIFT + B") -- was: Browser
o.bind("SUPER + SHIFT + B", "Board Game Arena", webapp .. " chrome-boardgamearena.com.*Delorean https://boardgamearena.com/")

-- Super+Shift+Return was a third Browser. Google Messages takes it.
hl.unbind("SUPER + SHIFT + RETURN") -- was: Browser
o.bind("SUPER + SHIFT + RETURN", "Google Messages", webapp .. " chrome-messages.google.com.*Delorean https://messages.google.com/web/conversations")
hl.unbind("SUPER + SHIFT + CTRL + G") -- was: Google Messages (stock, Default-profile --app)
o.bind("SUPER + SHIFT + CTRL + G", "Google Messages", webapp .. " chrome-messages.google.com.*Delorean https://messages.google.com/web/conversations")

-- Super+Shift+G was Signal. Gmail takes it (title-less --app=URL). Super+Shift+E
-- stays Thunderbird; Super+Shift+Alt+G stays WhatsApp.
-- Focus by Chrome app class, not the label "Gmail": launch-or-focus matches
-- titles too, and Thunderbird's "willyfresh@gmail.com" has a \bGmail\b hit.
hl.unbind("SUPER + SHIFT + G") -- was: Signal
o.bind("SUPER + SHIFT + G", "Gmail", webapp .. " chrome-mail.google.com.*Delorean https://mail.google.com/")

-- Super+Shift+C was HEY Calendar. Super+C stays Omarchy clipboard.
hl.unbind("SUPER + SHIFT + C") -- was: HEY Calendar
o.bind("SUPER + SHIFT + C", "Google Calendar", webapp .. " chrome-calendar.google.com.*Delorean https://calendar.google.com/")

-- Super+D was the Discord webapp (logged out on close). Native client now.
-- Do not use launch-or-focus on class discord: the updater splash matches
-- and Super+D just raises "Discord Updater".
o.bind("SUPER + D", "Discord", os.getenv("HOME") .. "/Projects/delorean/scripts/launch-discord.sh")

-- Super+Shift+D was Docker TUI, then Discord. Docker gets the chord back.
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Docker", { tui = "omarchy-launch-docker-tui" })

-- Swap: Super+O was pop-out, Super+Shift+O was LibreOffice (was Obsidian).
hl.unbind("SUPER + O") -- was: pop window out
hl.unbind("SUPER + SHIFT + O") -- was: Obsidian, then LibreOffice
o.bind("SUPER + O", "LibreOffice", { launch = "libreoffice" })
o.bind("SUPER + SHIFT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

-- Super+Tab was next workspace. Mirador is the workspace overview; Super+Shift+Tab
-- still goes to the previous occupied desk.
hl.unbind("SUPER + TAB")
o.bind("SUPER + TAB", "Workspace overview", "omarchy-shell shell toggle mirador '{}'")

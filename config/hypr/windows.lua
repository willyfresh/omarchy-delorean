-- Opt-in: new windows whose class contains one of these strings move to the
-- first empty workspace (Hyprland `empty`) and we follow them there.
--
-- Window rules with workspace=empty do not stick for Chrome --app windows
-- (the browser is already running, so Hyprland's initial-workspace tracking
-- keeps the new window on the current desk). window.open runs after map.
--
-- Regular Chrome tabs are class `google-chrome` and are not in this list.
-- Add a class substring to include another app.
--
-- Overlay lua is a symlink; Hyprland may not auto-reload on save. After
-- editing, run: hyprctl reload
--
-- Already-open apps are not moved. Close one, then launch it again to test.

local next_empty_workspace = {
  "chrome-mail.google.com", -- Gmail
  "chrome-boardgamearena.com", -- Board Game Arena
  "chrome-music.youtube.com", -- YouTube Music
  "chrome-maps.google.com", -- Google Maps
  "discord", -- native Discord (also matches leftover chrome-discord.com)
}

local function opens_on_empty(class)
  if not class or class == "" then
    return false
  end
  for _, fragment in ipairs(next_empty_workspace) do
    if class:find(fragment, 1, true) then
      return true
    end
  end
  return false
end

hl.on("window.open", function(window)
  if not window then
    return
  end
  local class = window.class or window.initialClass or ""
  if not opens_on_empty(class) then
    return
  end
  hl.dispatch(hl.dsp.window.move({ workspace = "empty", follow = true, window = window }))
end)

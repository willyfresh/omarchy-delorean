-- New windows go to the first empty workspace (Hyprland `empty`) unless they
-- are utilities. Chrome --app windows ignore workspace= empty rules, so this
-- runs on window.open after map.
--
-- Stay on the current desk: terminals, file manager, Omarchy TUIs/about,
-- portals/file pickers, and anything already floating or on a special
-- workspace. Add a class substring to stay_put_classes to keep another app.
--
-- Overlay lua is a symlink; after editing run: hyprctl reload

local stay_put_classes = {
  "Alacritty",
  "kitty",
  "foot",
  "com.mitchellh.ghostty",
  "wezterm",
  "org.gnome.Nautilus",
  "Nautilus",
  "org.omarchy.",
  "TUI.",
  "xdg-desktop-portal",
  "omacalc",
  "org.gnome.NautilusPreviewer",
  "imv",
}

local function class_of(window)
  return window.class or window.initial_class or window.initialClass or ""
end

local function has_tag(window, name)
  local tags = window.tags
  if type(tags) == "string" then
    return tags:find(name, 1, true) ~= nil
  end
  if type(tags) ~= "table" then
    return false
  end
  for _, tag in ipairs(tags) do
    if tostring(tag):gsub("%*$", "") == name then
      return true
    end
  end
  return false
end

local function stay_put(window)
  if window.floating or window.pinned then
    return true
  end

  local ws = window.workspace
  if ws and (ws.special or (type(ws.name) == "string" and ws.name:find("special", 1, true))) then
    return true
  end

  if has_tag(window, "terminal") or has_tag(window, "floating-window") then
    return true
  end

  local class = class_of(window)
  if class == "" then
    return true
  end
  for _, fragment in ipairs(stay_put_classes) do
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
  if stay_put(window) then
    return
  end
  hl.dispatch(hl.dsp.window.move({ workspace = "empty", follow = true, window = window }))
end)

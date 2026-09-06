-- Super+Left/Right: focus columns on this workspace only.
-- Super+Up/Down: focus in that direction; at the edge, previous (up) or
-- next (down) occupied workspace.
-- Super+Shift+Up/Down: take the window to the adjacent numbered workspace (1–10, wrap, follow).
-- Super+Shift+Left/Right: swap with the neighbor on this workspace.
-- Super+Ctrl+arrows: swap with the neighbor on this workspace.
-- Super+/-: this column/window thinner (minus) or wider (plus).
--
-- Overlay lua is a symlink; after editing run: hyprctl reload

local arrow = {
  l = { key = "LEFT", workspace = -1 },
  r = { key = "RIGHT", workspace = 1 },
  u = { key = "UP", workspace = -1 },
  d = { key = "DOWN", workspace = 1 },
}

local function vec(v)
  if type(v) ~= "table" then
    return 0, 0
  end
  return v.x or v[1] or 0, v.y or v[2] or 0
end

local function center(window)
  local x, y = vec(window.at)
  local w, h = vec(window.size)
  return x + w / 2, y + h / 2
end

local function workspace_id(window)
  local ws = window.workspace
  return ws and ws.id
end

local function is_fullscreen(window)
  local fs = window.fullscreen
  return fs and fs ~= 0 and fs ~= false
end

local function has_neighbor(active, dir)
  if is_fullscreen(active) then
    return false
  end

  local ws_id = workspace_id(active)
  if not ws_id then
    return false
  end

  local ax, ay = center(active)
  for _, other in ipairs(hl.get_windows() or {}) do
    if other.address ~= active.address and other.mapped and not other.hidden then
      if workspace_id(other) == ws_id then
        local ox, oy = center(other)
        if dir == "l" and ox < ax - 1 then
          return true
        elseif dir == "r" and ox > ax + 1 then
          return true
        elseif dir == "u" and oy < ay - 1 then
          return true
        elseif dir == "d" and oy > ay + 1 then
          return true
        end
      end
    end
  end
  return false
end

local function numbered_workspace(delta)
  local ws = hl.get_active_workspace()
  if not ws or ws.special then
    return nil
  end

  local id = (ws.id or 1) + delta
  if id < 1 then
    id = 10
  elseif id > 10 then
    id = 1
  end
  return tostring(id)
end

local function focus_or_workspace(dir)
  local spec = arrow[dir]
  local active = hl.get_active_window()
  if active and has_neighbor(active, dir) then
    hl.dispatch(hl.dsp.focus({ direction = dir }))
    return
  end

  -- Super+Left/Right stay on this workspace, even at the edge.
  if dir == "l" or dir == "r" then
    return
  end

  local ws = hl.get_active_workspace()
  if ws and ws.special then
    return
  end

  local selector = spec.workspace < 0 and "e-1" or "e+1"
  hl.dispatch(hl.dsp.focus({ workspace = selector }))
end

local function move_to_adjacent_workspace(dir)
  local dest = numbered_workspace(arrow[dir].workspace)
  if not dest then
    return
  end
  hl.dispatch(hl.dsp.window.move({ workspace = dest, follow = true }))
end

local function swap_in_workspace(dir)
  local active = hl.get_active_window()
  if not active or not has_neighbor(active, dir) then
    return
  end
  hl.dispatch(hl.dsp.window.swap({ direction = dir }))
end

for dir, spec in pairs(arrow) do
  local key = spec.key
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + CTRL + " .. key)

  local focus_label = (dir == "l" or dir == "r") and ("Focus " .. key:lower())
    or ("Focus " .. key:lower() .. " or next workspace")
  o.bind("SUPER + " .. key, focus_label, function()
    focus_or_workspace(dir)
  end, { repeating = true })
  if dir == "u" or dir == "d" then
    o.bind("SUPER + SHIFT + " .. key, "Move window to adjacent workspace", function()
      move_to_adjacent_workspace(dir)
    end)
  else
    o.bind("SUPER + SHIFT + " .. key, "Swap window " .. key:lower(), function()
      swap_in_workspace(dir)
    end)
  end
  o.bind("SUPER + CTRL + " .. key, "Swap window " .. key:lower(), function()
    swap_in_workspace(dir)
  end)
end

-- Alt+Tab: Windows-style MRU across regular workspaces. Snapshot on the
-- first Tab so walking the list does not reshuffle history. No overlay;
-- Omarchy does not ship one. Super+Tab stays next workspace (no overview).
local alttab = { list = nil, index = 1 }

local function alt_held()
  -- XKB names are Alt_L / Alt_R. ALT_L is a bind token, not a keysym.
  return hl.is_key_down("Alt_L") or hl.is_key_down("Alt_R")
end

local function alttab_snapshot()
  local list = {}
  for _, window in ipairs(hl.get_windows() or {}) do
    if window.mapped and not window.hidden and window.accepts_input ~= false then
      if window.class == "org.omarchy.screensaver" then
        goto continue
      end
      local ws = window.workspace
      if not (ws and ws.special) then
        list[#list + 1] = {
          address = window.address,
          hist = window.focus_history_id or 999,
        }
      end
    end
    ::continue::
  end
  table.sort(list, function(a, b)
    return a.hist < b.hist
  end)
  return list
end

local function alttab_focus(entry)
  if not entry or not entry.address then
    return false
  end
  local window = hl.get_window("address:" .. entry.address)
  if not window then
    return false
  end
  hl.dispatch(hl.dsp.focus({ window = window }))
  hl.dispatch(hl.dsp.window.bring_to_top())
  return true
end

local function alttab_step(delta)
  if not alt_held() then
    alttab.list = nil
  end
  if not alttab.list then
    alttab.list = alttab_snapshot()
    alttab.index = 1
  end

  local n = #alttab.list
  if n == 0 then
    return
  end

  for _ = 1, n do
    alttab.index = ((alttab.index - 1 + delta) % n) + 1
    if alttab_focus(alttab.list[alttab.index]) then
      return
    end
  end
end

local function alttab_end()
  alttab.list = nil
  alttab.index = 1
end

hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + TAB", "Next window (MRU)", function()
  alttab_step(1)
end, { repeating = true })
o.bind("ALT + SHIFT + TAB", "Previous window (MRU)", function()
  alttab_step(-1)
end, { repeating = true })
o.bind("ALT + Alt_L", "End window switcher", alttab_end, { release = true, transparent = true })
o.bind("ALT + Alt_R", "End window switcher", alttab_end, { release = true, transparent = true })

-- Super+/-: this column/window thinner or wider. Stock Omarchy resizes the
-- left edge (Minus = expand left, Equal = shrink left), so Super+Plus on a
-- far-right window does nothing useful. Scrolling uses colresize; dwindle
-- / float probes both edges so a rightmost window can still grow left.
local function window_width(address)
  local window = hl.get_window("address:" .. address)
  if not window then
    return nil
  end
  local w = vec(window.size)
  return w
end

local function adjust_width(frac, px)
  local active = hl.get_active_window()
  if not active then
    return
  end

  local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
  if not active.floating and ws and ws.tiled_layout == "scrolling" then
    local msg = frac > 0 and ("colresize +" .. frac) or ("colresize " .. frac)
    hl.dispatch(hl.dsp.layout(msg))
    return
  end

  local address = active.address
  local start = window_width(address)
  if not start then
    return
  end

  local want_wider = px > 0
  local mag = math.abs(px)
  for _, probe in ipairs({ mag, -mag }) do
    hl.dispatch(hl.dsp.window.resize({ x = probe, y = 0, relative = true }))
    local now = window_width(address)
    if not now then
      return
    end
    local grew = now - start
    if want_wider and grew > 1 then
      return
    end
    if not want_wider and grew < -1 then
      return
    end
    hl.dispatch(hl.dsp.window.resize({ x = -probe, y = 0, relative = true }))
  end
end

for _, chord in ipairs({
  "SUPER + MINUS",
  "SUPER + EQUAL",
  "SUPER + code:20",
  "SUPER + code:21",
  "SUPER + ALT + MINUS",
  "SUPER + ALT + EQUAL",
  "SUPER + ALT + code:20",
  "SUPER + ALT + code:21",
  "SUPER + CTRL + MINUS",
  "SUPER + CTRL + EQUAL",
  "SUPER + CTRL + code:20",
  "SUPER + CTRL + code:21",
}) do
  hl.unbind(chord)
end

o.bind("SUPER + MINUS", "Make window thinner", function()
  adjust_width(-0.1, -100)
end, { repeating = true })
o.bind("SUPER + EQUAL", "Make window wider", function()
  adjust_width(0.1, 100)
end, { repeating = true })
o.bind("SUPER + ALT + MINUS", "Make window a little thinner", function()
  adjust_width(-0.05, -25)
end, { repeating = true })
o.bind("SUPER + ALT + EQUAL", "Make window a little wider", function()
  adjust_width(0.05, 25)
end, { repeating = true })
o.bind("SUPER + CTRL + MINUS", "Make window a lot thinner", function()
  adjust_width(-0.2, -300)
end, { repeating = true })
o.bind("SUPER + CTRL + EQUAL", "Make window a lot wider", function()
  adjust_width(0.2, 300)
end, { repeating = true })

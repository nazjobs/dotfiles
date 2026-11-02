-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Animations Configuration (Hyprland 0.57+)
-- Loads and parses UserAnimations.conf dynamically for compatibility with Animations.sh presets
---@module 'hl'

local home = os.getenv("HOME") or ""
local conf_path = home .. "/.config/hypr/UserConfigs/UserAnimations.conf"

local function load_animations(path)
  local file = io.open(path, "r")
  if not file then
    return false
  end

  local enabled = true
  local beziers = {}
  local animations = {}

  for line in file:lines() do
    local clean = line:match("^([^#]*)") or ""
    clean = clean:match("^%s*(.-)%s*$")
    if clean ~= "" then
      local en_val = clean:match("^enabled%s*=%s*(%S+)")
      if en_val then
        enabled = (en_val == "yes" or en_val == "true" or en_val == "1" or en_val == "on")
      end

      local bname, x0, y0, x1, y1 = clean:match("^bezier%s*=%s*([%w_%-]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)")
      if bname and x0 and y0 and x1 and y1 then
        table.insert(beziers, {
          name = bname,
          points = { { tonumber(x0), tonumber(y0) }, { tonumber(x1), tonumber(y1) } },
        })
      end

      local anim_def = clean:match("^animation%s*=%s*(.+)")
      if anim_def then
        local parts = {}
        for part in anim_def:gmatch("[^,]+") do
          table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 4 then
          local leaf = parts[1]
          local a_en = (parts[2] == "1" or parts[2] == "yes" or parts[2] == "true" or parts[2] == "on")
          local speed = tonumber(parts[3]) or 5
          if speed > 100 then
            speed = 100
          end
          if speed <= 0 then
            speed = 0.1
          end
          local curve = parts[4]
          local style = parts[5]

          -- Ensure workspaces slide if not explicitly specified
          if (not style or style == "") and (leaf == "workspaces" or leaf == "workspacesIn" or leaf == "workspacesOut") then
            style = "slide"
          end

          table.insert(animations, {
            leaf = leaf,
            enabled = a_en,
            speed = speed,
            bezier = curve,
            style = (style and style ~= "") and style or nil,
          })
        end
      end
    end
  end

  file:close()

  hl.config({
    animations = {
      enabled = enabled,
    },
  })

  for _, b in ipairs(beziers) do
    hl.curve(b.name, { type = "bezier", points = b.points })
  end

  for _, a in ipairs(animations) do
    hl.animation(a)
  end

  return true
end

if not load_animations(conf_path) then
  -- Fallback defaults
  hl.config({
    animations = {
      enabled = true,
    },
  })

  hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
  hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
  hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
  hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
  hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
  hl.curve("smoothOut", { type = "bezier", points = { { 0.5, 0 }, { 0.99, 0.99 } } })
  hl.curve("smoothIn", { type = "bezier", points = { { 0.5, -0.5 }, { 0.68, 1.5 } } })

  hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
  hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
  hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
  hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
  hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "liner", style = "loop" })
  hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smoothOut" })
  hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
  hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
  hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
  hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "wind", style = "slidevert" })
end

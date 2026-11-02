-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Decoration Settings
---@module 'hl'

local home = os.getenv("HOME") or ""

local function load_wallust_colors(path)
  local colors = {}
  local handle = io.open(path, "r")
  if not handle then
    return colors
  end

  for line in handle:lines() do
    local name, hex = line:match("^%s*%$([%w_]+)%s*=%s*rgb%(([0-9A-Fa-f]+)%)")
    if name and hex and hex ~= "" then
      colors[string.lower(name)] = "rgb(" .. string.upper(hex) .. ")"
    end
  end

  handle:close()
  return colors
end

local wallust = load_wallust_colors(home .. "/.config/hypr/wallust/wallust-hyprland.conf")
local active_border = wallust.color12 or "rgba(878D7Eff)"
local inactive_border = wallust.color10 or "rgba(4A4C3Dff)"
local group_border = wallust.color15 or "rgba(D5BCA6ff)"
local groupbar_active = wallust.color0 or "rgba(3E3D3Cff)"

hl.config({
    general = {
        border_size = 2,
        gaps_in = 2,
        gaps_out = 4,
        col = {
            active_border = active_border,
            inactive_border = inactive_border,
        },
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
            color = active_border,
            color_inactive = inactive_border,
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
            special = true,
            popups = true,
        },
        wobble = {
            enabled = true,
        },
    },
    group = {
        col = {
            border_active = group_border,
        },
        groupbar = {
            col = {
                active = groupbar_active,
            },
        },
    },
})

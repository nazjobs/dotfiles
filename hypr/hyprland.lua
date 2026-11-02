-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Hyprland Lua Configuration (v0.57+)
-- Personal dotfiles for CachyOS/Hyprland
---@module 'hl'

local hyprDir = os.getenv("HOME") .. "/.config/hypr"

local function load_config(rel_path)
  local full_path = hyprDir .. "/" .. rel_path
  local ok, err = pcall(dofile, full_path)
  if not ok then
    print("[ERROR] Failed to load " .. rel_path .. ": " .. tostring(err))
  end
end

-- Initial boot script
hl.on("hyprland.start", function()
  hl.exec_cmd(hyprDir .. "/initial-boot.sh")
end)

-- User Default Apps & Environment
load_config("UserConfigs/01-UserDefaults.lua")
load_config("configs/ENVariables.lua")
load_config("UserConfigs/ENVariables.lua")

-- Settings
load_config("configs/SystemSettings.lua")
load_config("UserConfigs/UserSettings.lua")

-- Visuals & Animations
load_config("UserConfigs/UserDecorations.lua")
load_config("UserConfigs/UserAnimations.lua")

-- Monitors
load_config("monitors.lua")

-- Hardware / Laptop configs
load_config("configs/Laptops.lua")
load_config("UserConfigs/Laptops.lua")

-- Window & Layer Rules
load_config("configs/WindowRules.lua")
load_config("UserConfigs/WindowRules.lua")

-- Keybinds
load_config("configs/Keybinds.lua")
load_config("UserConfigs/UserKeybinds.lua")

-- Autostart / Startup Applications
load_config("configs/Startup_Apps.lua")
load_config("UserConfigs/Startup_Apps.lua")

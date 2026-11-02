---@module 'hl'

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
local UserConfigs = os.getenv("HOME") .. "/.config/hypr/UserConfigs"
local UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"
local USER_DEFAULTS = _G.USER_DEFAULTS or {}

local function resolve_cmd(cmd)
  cmd = cmd:gsub("%$scriptsDir", scriptsDir)
  cmd = cmd:gsub("%$UserScripts", UserScripts)
  cmd = cmd:gsub("%$term", USER_DEFAULTS.term or "alacritty")
  cmd = cmd:gsub("%$files", USER_DEFAULTS.files or "thunar")
  return cmd
end

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- Default Keybinds
-- visit https://wiki.hyprland.org/Configuring/Binds/ for more info

-- /* ---- ✴️ Variables ✴️ ---- */  #
local mainMod = "SUPER"
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
local UserConfigs = os.getenv("HOME") .. "/.config/hypr/UserConfigs"
local UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"

-- settings for User defaults apps - set your default terminal and file manager on this file
-- source= $UserConfigs/01-UserDefaults.conf

-- STANDAR ####
-- Common shortcuts
-- bindr = $mainMod, $mainMod_L, exec, pkill rofi || rofi -show drun -modi drun,filebrowser,run,window # Super Key to Launch rofi menu
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(resolve_cmd("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window")), { desc = "app launcher" })
hl.bind("SUPER + B", hl.dsp.exec_cmd(resolve_cmd("xdg-open \"https://\"")), { desc = "open default browser" })
hl.bind("SUPER + A", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/OverviewToggle.sh")), { desc = "desktop overview" })
-- bindd = $mainMod, A, ags overview, exec, pkill rofi || true && ags -t 'overview' # desktop overview (if installed)
-- bindd = $mainMod, A, Quickshell overview, global, quickshell:overviewToggle # desktop overview (if installed)
hl.bind("SUPER + Return", hl.dsp.exec_cmd(resolve_cmd("$term")), { desc = "Open terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(resolve_cmd("$files")), { desc = "file manager" })

-- FEATURES / EXTRAS
hl.bind("SUPER + T", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/ThemeChanger.sh")), { desc = "Global theme switcher using Wallust" })
hl.bind("SUPER + CTRL + H", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/KeyHints.sh")), { desc = "help / cheat sheet" })
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Refresh.sh")), { desc = "refresh bar and menus" })
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/RofiEmoji.sh")), { desc = "emoji menu" })
hl.bind("SUPER + S", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/RofiSearch.sh")), { desc = "web search" })
hl.bind("SUPER + CTRL + S", hl.dsp.exec_cmd(resolve_cmd("rofi -show window")), { desc = "window switcher" })
hl.bind("SUPER + ALT + O", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/ChangeBlur.sh")), { desc = "toggle blur" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/GameMode.sh")), { desc = "toggle game mode" })
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/ChangeLayout.sh")), { desc = "toggle master/dwindle layout" })
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/ClipManager.sh")), { desc = "clipboard manager" })
hl.bind("SUPER + CTRL + R", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/RofiThemeSelector.sh")), { desc = "rofi theme selector" })
hl.bind("SUPER + CTRL + SHIFT + R", hl.dsp.exec_cmd(resolve_cmd("pkill rofi || true && $scriptsDir/RofiThemeSelector-modified.sh")), { desc = "rofi theme selector (modified)" })

-- bindd = $mainMod CTRL, F, fullscreen, fullscreen
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { desc = "maximize window" })
-- bindd = $mainMod, SPACE, Float current window, togglefloating,
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(resolve_cmd("hyprctl dispatch workspaceopt allfloat")), { desc = "Float all windows" })
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Dropterminal.sh kitty")), { desc = "DropDown terminal" })

-- Desktop zooming or magnifier
hl.bind("SUPER + ALT + mouse_down", hl.dsp.exec_cmd(resolve_cmd("hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor * 2.0}')\"")), { desc = "zoom in" })
hl.bind("SUPER + ALT + mouse_up", hl.dsp.exec_cmd(resolve_cmd("hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | awk 'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor / 2.0}')\"")), { desc = "zoom out" })

-- Waybar / Bar related
hl.bind("SUPER + CTRL + ALT + B", hl.dsp.exec_cmd(resolve_cmd("pkill -SIGUSR1 waybar")), { desc = "toggle waybar on/off" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/WaybarStyles.sh")), { desc = "waybar styles menu" })
hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/WaybarLayout.sh")), { desc = "waybar layout menu" })

-- Night light toggle (Hyprsunset)
hl.bind("SUPER + N", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Hyprsunset.sh toggle")), { desc = "toggle night light" })

-- FEATURES / EXTRAS (UserScripts)
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/RofiBeats.sh")), { desc = "online music" })
hl.bind("SUPER + W", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/WallpaperSelect.sh")), { desc = "select wallpaper" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/WallpaperEffects.sh")), { desc = "wallpaper effects" })
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/WallpaperRandom.sh")), { desc = "random wallpaper" })
hl.bind("SUPER + CTRL + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }), { desc = "toggle active window opacity" })
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/KeyBinds.sh")), { desc = "search keybinds" })
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Animations.sh")), { desc = "animations menu" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/ZshChangeTheme.sh")), { desc = "change oh-my-zsh theme" })
-- bindlnd = ALT_L, SHIFT_L, switch keyboard layout globally, exec, $scriptsDir/KeyboardLayout.sh switch
-- bindlnd = SHIFT_L, ALT_L, switch keyboard layout per-window, exec, $scriptsDir/Tak0-Per-Window-Switch.sh
hl.bind("SUPER + C", hl.dsp.exec_cmd(resolve_cmd("$UserScripts/RofiCalc.sh")), { desc = "calculator" })

-- Move current workspaces to monitors (left right up or down)
hl.bind("SUPER + CTRL + F9", hl.dsp.workspace.move({ monitor = "l" }), { desc = "move workspace to left monitor" })
hl.bind("SUPER + CTRL + F10", hl.dsp.workspace.move({ monitor = "r" }), { desc = "move workspace to right monitor" })
hl.bind("SUPER + CTRL + F11", hl.dsp.workspace.move({ monitor = "u" }), { desc = "move workspace to up monitor" })
hl.bind("SUPER + CTRL + F12", hl.dsp.workspace.move({ monitor = "d" }), { desc = "move workspace to down monitor" })


-- SYSTEM ####
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(resolve_cmd("hyprctl dispatch exit 0")), { desc = "exit Hyprland" })
hl.bind("SUPER + Q", hl.dsp.window.close(), { desc = "close active window" })
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/KillActiveProcess.sh")), { desc = "Terminate active process" })
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/LockScreen.sh")), { desc = "lock screen" })
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Wlogout.sh")), { desc = "powermenu" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(resolve_cmd("swaync-client -t -sw")), { desc = "notification panel" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Kool_Quick_Settings.sh")), { desc = "Quick settings menu" })

-- Master Layout
hl.bind("SUPER + CTRL + D", hl.dsp.layout("removemaster"), { desc = "remove master" })
hl.bind("SUPER + I", hl.dsp.layout("addmaster"), { desc = "add master" })
-- NOTE: J/K bindings are set dynamically by scripts/KeybindsLayoutInit.sh and scripts/ChangeLayout.sh
-- (we intentionally do not bind them statically here to avoid conflicts across layouts)
-- bindd = $mainMod, J, cycle next, layoutmsg, cyclenext
-- bindd = $mainMod, K, cycle previous, layoutmsg, cycleprev
hl.bind("SUPER + CTRL + Return", hl.dsp.layout("swapwithmaster"), { desc = "swap with master" })

-- Dwindle Layout
hl.bind("SUPER + SHIFT + I", hl.dsp.layout("togglesplit"), { desc = "toggle split (dwindle)" })
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { desc = "toggle pseudo (dwindle)" })

-- Works on either layout (Master or Dwindle)
hl.bind("SUPER + M", hl.dsp.exec_cmd(resolve_cmd("hyprctl dispatch splitratio 0.3")), { desc = "set split ratio 0.3" })
-- layout aware keybinds
hl.on("hyprland.start", function() hl.exec_cmd("" .. scriptsDir .. "/ChangeLayout.sh init") end)


-- Cycle windows; if floating bring to top
hl.bind("ALT + tab", hl.dsp.window.cycle_next(), { desc = "cycle next window" })
hl.bind("ALT + tab", hl.dsp.window.bring_to_top(), { desc = "bring active to top" })

-- Special Keys / Hot Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --inc")), { desc = "volume up", repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --dec")), { desc = "volume down", repeating = true, locked = true })
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --inc-precise")), { desc = "volume up precise", repeating = true, locked = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --dec-precise")), { desc = "volume down precise", repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --toggle-mic")), { desc = "toggle mic mute", locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/Volume.sh --toggle")), { desc = "toggle mute", locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd(resolve_cmd("systemctl suspend")), { desc = "sleep", locked = true })
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/AirplaneMode.sh")), { desc = "airplane mode", locked = true })

-- media controls using keyboards
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --pause")), { desc = "play/pause", locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --pause")), { desc = "pause", locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --pause")), { desc = "play", locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --nxt")), { desc = "next track", locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --prv")), { desc = "previous track", locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(resolve_cmd("$scriptsDir/MediaCtrl.sh --stop")), { desc = "stop", locked = true })

-- Screenshot keybindings NOTE: You may need to press Fn key as well
-- bindd = $mainMod, Print, screenshot now, exec, $scriptsDir/ScreenShot.sh --now
-- bindd = $mainMod SHIFT, Print, screenshot (area), exec, $scriptsDir/ScreenShot.sh --area
-- bindd = $mainMod CTRL, Print, screenshot in 5s, exec, $scriptsDir/ScreenShot.sh --in5
-- bindd = $mainMod CTRL SHIFT, Print, screenshot in 10s, exec, $scriptsDir/ScreenShot.sh --in10
-- bindd = ALT, Print, screenshot active window, exec, $scriptsDir/ScreenShot.sh --active
-- 
-- screenshot with swappy (another screenshot tool)
-- bindd = $mainMod SHIFT, S, screenshot (swappy), exec, $scriptsDir/ScreenShot.sh --swappy

-- Resize windows
hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0 }), { desc = "resize left (-50)", repeating = true })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0 }), { desc = "resize right (+50)", repeating = true })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50 }), { desc = "resize up (-50)", repeating = true })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50 }), { desc = "resize down (+50)", repeating = true })

-- Move windows
hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ direction = "left" }), { desc = "move window left" })
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ direction = "right" }), { desc = "move window right" })
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ direction = "up" }), { desc = "move window up" })
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ direction = "down" }), { desc = "move window down" })

-- Swap windows
hl.bind("SUPER + ALT + left", hl.dsp.window.swap({ direction = "left" }), { desc = "swap window left" })
hl.bind("SUPER + ALT + right", hl.dsp.window.swap({ direction = "right" }), { desc = "swap window right" })
hl.bind("SUPER + ALT + up", hl.dsp.window.swap({ direction = "up" }), { desc = "swap window up" })
hl.bind("SUPER + ALT + down", hl.dsp.window.swap({ direction = "down" }), { desc = "swap window down" })

-- group
hl.bind("SUPER + G", hl.dsp.group.toggle(), { desc = "toggle group" })

-- Navigate within a group
hl.bind("SUPER + Tab", hl.dsp.group.next(), { desc = "Change Group Forward" })
hl.bind("SUPER + CTRL + tab", hl.dsp.group.next(), { desc = "change active in group" })
hl.bind("SUPER + CTRL + SHIFT + Tab", hl.dsp.group.prev(), { desc = "Change Group Back" })

-- Move window into/out of group
hl.bind("SUPER + CTRL + K", hl.dsp.window.move({ into_group = "left" }), { desc = "Move left into group" })
hl.bind("SUPER + CTRL + L", hl.dsp.window.move({ into_group = "right" }), { desc = "Move Right into group" })
hl.bind("SUPER + CTRL + H", hl.dsp.window.move({ out_of_group = true }), { desc = "Move active out of group" })

-- Try to dynamically move in grouped window and when ungrouped
-- Not working for me DW 11/26/25  PR: https://github.com/JaKooLit/Hyprland-Dots/pull/872
-- bindd = $mainMod, right, focus right, exec, bash -c 'if hyprctl activewindow -j | jq -e "((.grouped | type) == \"boolean\") or (.address == (.grouped[-1] // empty))" >/dev/null 2>&1; then hyprctl dispatch movefocus r; else hyprctl dispatch changegroupactive f; fi'
-- bindd = $mainMod, left, focus left, exec, bash -c 'if hyprctl activewindow -j | jq -e "((.grouped | type) == \"boolean\") or (.address == (.grouped[0] // empty))" >/dev/null 2>&1; then hyprctl dispatch movefocus l; else hyprctl dispatch changegroupactive b; fi'

-- Move focus with mainMod + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }), { desc = "focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }), { desc = "focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }), { desc = "focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }), { desc = "focus down" })

-- Workspaces related
hl.bind("SUPER + tab", hl.dsp.focus({ workspace = "m+1" }), { desc = "next workspace" })
hl.bind("SUPER + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }), { desc = "previous workspace" })

-- Special workspace
hl.bind("SUPER + SHIFT + U", hl.dsp.window.move({ workspace = "special" }), { desc = "move to special workspace" })
hl.bind("SUPER + U", hl.dsp.workspace.toggle_special("special"), { desc = "toggle special workspace" })

-- The following mappings use the key codes to better support various keyboard layouts
-- 1 is code:10, 2 is code 11, etc
-- Switch workspaces with mainMod + [0-9]
hl.bind("SUPER + code:10", hl.dsp.focus({ workspace = 1 }), { desc = "workspace 1" })
hl.bind("SUPER + code:11", hl.dsp.focus({ workspace = 2 }), { desc = "workspace 2" })
hl.bind("SUPER + code:12", hl.dsp.focus({ workspace = 3 }), { desc = "workspace 3" })
hl.bind("SUPER + code:13", hl.dsp.focus({ workspace = 4 }), { desc = "workspace 4" })
hl.bind("SUPER + code:14", hl.dsp.focus({ workspace = 5 }), { desc = "workspace 5" })
hl.bind("SUPER + code:15", hl.dsp.focus({ workspace = 6 }), { desc = "workspace 6" })
hl.bind("SUPER + code:16", hl.dsp.focus({ workspace = 7 }), { desc = "workspace 7" })
hl.bind("SUPER + code:17", hl.dsp.focus({ workspace = 8 }), { desc = "workspace 8" })
hl.bind("SUPER + code:18", hl.dsp.focus({ workspace = 9 }), { desc = "workspace 9" })
hl.bind("SUPER + code:19", hl.dsp.focus({ workspace = 10 }), { desc = "workspace 10" })

-- Move active window and follow to workspace mainMod + SHIFT [0-9]
hl.bind("SUPER + SHIFT + code:10", hl.dsp.window.move({ workspace = 1 }), { desc = "move to workspace 1" })
hl.bind("SUPER + SHIFT + code:11", hl.dsp.window.move({ workspace = 2 }), { desc = "move to workspace 2" })
hl.bind("SUPER + SHIFT + code:12", hl.dsp.window.move({ workspace = 3 }), { desc = "move to workspace 3" })
hl.bind("SUPER + SHIFT + code:13", hl.dsp.window.move({ workspace = 4 }), { desc = "move to workspace 4" })
hl.bind("SUPER + SHIFT + code:14", hl.dsp.window.move({ workspace = 5 }), { desc = "move to workspace 5" })
hl.bind("SUPER + SHIFT + code:15", hl.dsp.window.move({ workspace = 6 }), { desc = "move to workspace 6" })
hl.bind("SUPER + SHIFT + code:16", hl.dsp.window.move({ workspace = 7 }), { desc = "move to workspace 7" })
hl.bind("SUPER + SHIFT + code:17", hl.dsp.window.move({ workspace = 8 }), { desc = "move to workspace 8" })
hl.bind("SUPER + SHIFT + code:18", hl.dsp.window.move({ workspace = 9 }), { desc = "move to workspace 9" })
hl.bind("SUPER + SHIFT + code:19", hl.dsp.window.move({ workspace = 10 }), { desc = "move to workspace 10" })
hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }), { desc = "move to previous workspace" })
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), { desc = "move to next workspace" })

-- Move active window to a workspace silently mainMod + CTRL [0-9]
hl.bind("SUPER + CTRL + code:10", hl.dsp.window.move({ workspace = 1, follow = false }), { desc = "move silently to workspace 1" })
hl.bind("SUPER + CTRL + code:11", hl.dsp.window.move({ workspace = 2, follow = false }), { desc = "move silently to workspace 2" })
hl.bind("SUPER + CTRL + code:12", hl.dsp.window.move({ workspace = 3, follow = false }), { desc = "move silently to workspace 3" })
hl.bind("SUPER + CTRL + code:13", hl.dsp.window.move({ workspace = 4, follow = false }), { desc = "move silently to workspace 4" })
hl.bind("SUPER + CTRL + code:14", hl.dsp.window.move({ workspace = 5, follow = false }), { desc = "move silently to workspace 5" })
hl.bind("SUPER + CTRL + code:15", hl.dsp.window.move({ workspace = 6, follow = false }), { desc = "move silently to workspace 6" })
hl.bind("SUPER + CTRL + code:16", hl.dsp.window.move({ workspace = 7, follow = false }), { desc = "move silently to workspace 7" })
hl.bind("SUPER + CTRL + code:17", hl.dsp.window.move({ workspace = 8, follow = false }), { desc = "move silently to workspace 8" })
hl.bind("SUPER + CTRL + code:18", hl.dsp.window.move({ workspace = 9, follow = false }), { desc = "move silently to workspace 9" })
hl.bind("SUPER + CTRL + code:19", hl.dsp.window.move({ workspace = 10, follow = false }), { desc = "move silently to workspace 10" })
hl.bind("SUPER + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }), { desc = "move silently to previous workspace" })
hl.bind("SUPER + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }), { desc = "move silently to next workspace" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "next workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { desc = "previous workspace" })
hl.bind("SUPER + period", hl.dsp.focus({ workspace = "e+1" }), { desc = "next workspace" })
hl.bind("SUPER + comma", hl.dsp.focus({ workspace = "e-1" }), { desc = "previous workspace" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { desc = "move window", drag = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { desc = "resize window", drag = true })

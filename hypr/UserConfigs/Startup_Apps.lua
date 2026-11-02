-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Commands and Apps to be executed at launch
---@module 'hl'

local home = os.getenv("HOME") or ""
local userScripts = home .. "/.config/hypr/UserScripts"

hl.on("hyprland.start", function()
    hl.exec_cmd("poweralertd")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd(userScripts .. "/WallpaperAutoChange.sh " .. home .. "/Pictures/wallpapers")
    -- GNOME Keyring daemon for secrets storage (Cursor, VS Code, etc.)
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")
end)

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Keybinds Configuration
---@module 'hl'

local dsp = hl.dsp

-- Terminal / File manager resolution from _G.USER_DEFAULTS or fallback
local term = (_G.USER_DEFAULTS and _G.USER_DEFAULTS.term) or "alacritty"

-- Common User Keybinds
hl.bind("SUPER + Return", dsp.exec_cmd(term), { desc = "Terminal (" .. term .. ")" })
hl.bind("SUPER + CTRL + Return", dsp.exec_cmd("ghostty"), { desc = "Terminal (ghostty)" })
hl.bind("SUPER + Q", dsp.window.close(), { desc = "Close window" })
hl.bind("SUPER + V", dsp.window.float({ action = "toggle" }), { desc = "Toggle floating" })
hl.bind("SUPER + F", dsp.window.fullscreen({ mode = "fullscreen" }), { desc = "Toggle fullscreen" })
hl.bind("SUPER + CTRL + N", dsp.layout("togglesplit"), { desc = "Toggle split" })
hl.bind("SUPER + CTRL + K", dsp.exec_cmd("QT_QPA_PLATFORM=xcb krita"), { desc = "Krita (Qt mode)" })
hl.bind("Print", dsp.exec_cmd("flameshot gui"), { desc = "Flameshot GUI" })
hl.bind("SUPER + Y", dsp.exec_cmd("flatpak run com.ayugram.desktop"), { desc = "AyuGram" })
hl.bind("SUPER + Z", dsp.exec_cmd("zen-browser"), { desc = "Zen Browser" })
hl.bind("SUPER + R", dsp.exec_cmd("cursor"), { desc = "Cursor" })
hl.bind("SUPER + CTRL + A", dsp.exec_cmd("pavucontrol"), { desc = "Volume Control" })
hl.bind("CTRL + ALT + C", dsp.exec_cmd("hyprpicker -a"), { desc = "Color Picker" })
hl.bind("SUPER + SHIFT + period", dsp.exec_cmd("emote"), { desc = "Emoji Picker" })
hl.bind("SUPER + SHIFT + space", dsp.exec_cmd("fcitx5-remote -t"), { desc = "Switch Input Method" })

-- Window Movement (HJKL)
hl.bind("SUPER + SHIFT + H", dsp.window.move({ direction = "left" }), { desc = "Move window left" })
hl.bind("SUPER + SHIFT + L", dsp.window.move({ direction = "right" }), { desc = "Move window right" })
hl.bind("SUPER + SHIFT + K", dsp.window.move({ direction = "up" }), { desc = "Move window up" })
hl.bind("SUPER + SHIFT + J", dsp.window.move({ direction = "down" }), { desc = "Move window down" })

-- Window Focus (HJKL)
hl.bind("SUPER + L", dsp.focus({ direction = "left" }), { desc = "Focus left" })
hl.bind("SUPER + H", dsp.focus({ direction = "right" }), { desc = "Focus right" })
hl.bind("SUPER + K", dsp.focus({ direction = "up" }), { desc = "Focus up" })
hl.bind("SUPER + J", dsp.focus({ direction = "down" }), { desc = "Focus down" })

-- Mouse move window
hl.bind("SUPER + mouse:272", dsp.window.drag(), { desc = "Move window" })

-- Workspace Actions
hl.bind("SUPER + Next", dsp.focus({ workspace = "e+1" }), { desc = "Next workspace" })
hl.bind("SUPER + Prior", dsp.focus({ workspace = "e-1" }), { desc = "Previous workspace" })
hl.bind("SUPER + slash", dsp.focus({ workspace = "previous" }), { desc = "Previous workspace" })
hl.bind("SUPER + minus", dsp.window.move({ workspace = "special" }), { desc = "Move to special workspace" })
hl.bind("SUPER + equal", dsp.workspace.toggle_special("special"), { desc = "Toggle special workspace" })
hl.bind("SUPER + F1", dsp.workspace.toggle_special("scratchpad"), { desc = "Toggle scratchpad" })
hl.bind("SUPER + ALT + SHIFT + F1", dsp.window.move({ workspace = "special:scratchpad", follow = false }), { desc = "Move to scratchpad" })

-- Binds configuration
hl.config({
    binds = {
        allow_workspace_cycles = true,
        workspace_back_and_forth = true,
        workspace_center_on = 1,
        movefocus_cycles_fullscreen = true,
        window_direction_monitor_fallback = true,
    },
})

-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Keybinds Configuration
---@module 'hl'

local dsp = hl.dsp
local USER_DEFAULTS = _G.USER_DEFAULTS or {}
local term = USER_DEFAULTS.term or "alacritty"

-- Common User Keybinds
hl.unbind("SUPER + CTRL + Return")
hl.bind("SUPER + CTRL + Return", dsp.exec_cmd("ghostty"), { desc = "Opens your preferred terminal emulator (ghostty)" })
hl.bind("SUPER + V", function()
    local w = hl.get_active_window()
    if w and w.fullscreen and w.fullscreen ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen())
        if not w.floating then
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        end
    else
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
end, { desc = "Switches current window between floating and tiling mode" })
hl.bind("SUPER + F", dsp.window.fullscreen(), { desc = "Toggles current window fullscreen mode" })
hl.bind("SUPER + CTRL + N", function()
    local w = hl.get_active_window()
    if w and w.fullscreen and w.fullscreen ~= 0 then
        hl.dispatch(hl.dsp.window.fullscreen())
    end
    hl.dispatch(hl.dsp.layout("togglesplit"))
end, { desc = "Toggles current window split mode (horizontal <-> vertical)" })
hl.bind("SUPER + CTRL + K", dsp.exec_cmd("QT_QPA_PLATFORM=xcb krita"), { desc = "Opens Krita in Qt supported mode" })
hl.bind("Print", dsp.exec_cmd("flameshot gui"))
hl.bind("SUPER + Y", dsp.exec_cmd("flatpak run com.ayugram.desktop"), { desc = "AyuGram" })
hl.bind("SUPER + Z", dsp.exec_cmd("zen-browser"), { desc = "Zen Browser" })
hl.bind("SUPER + R", dsp.exec_cmd("cursor"), { desc = "Cursor" })
hl.bind("SUPER + CTRL + A", dsp.exec_cmd("pavucontrol"), { desc = "Volume Control" })
hl.bind("CTRL + ALT + C", dsp.exec_cmd("hyprpicker -a"), { desc = "Color Picker" })
hl.bind("SUPER + SHIFT + period", dsp.exec_cmd("emote"))
hl.bind("SUPER + SHIFT + space", dsp.exec_cmd("fcitx5-remote -t"))

-- Window Actions (HJKL)
hl.bind("SUPER + SHIFT + H", dsp.window.move({ direction = "left" }), { desc = "Move active window to the left" })
hl.bind("SUPER + SHIFT + L", dsp.window.move({ direction = "right" }), { desc = "Move active window to the right" })
hl.bind("SUPER + SHIFT + K", dsp.window.move({ direction = "up" }), { desc = "Move active window upwards" })
hl.bind("SUPER + SHIFT + J", dsp.window.move({ direction = "down" }), { desc = "Move active window downwards" })

-- Move focus (HJKL)
hl.bind("SUPER + L", dsp.focus({ direction = "left" }), { desc = "Move focus to the left" })
hl.bind("SUPER + H", dsp.focus({ direction = "right" }), { desc = "Move focus to the right" })
hl.bind("SUPER + K", dsp.focus({ direction = "up" }), { desc = "Move focus upwards" })
hl.bind("SUPER + J", dsp.focus({ direction = "down" }), { desc = "Move focus downwards" })

-- Workspace Actions
hl.bind("SUPER + Next", dsp.focus({ workspace = "e+1" }), { desc = "Scroll through workspaces incrementally" })
hl.bind("SUPER + Prior", dsp.focus({ workspace = "e-1" }), { desc = "Scroll through workspaces decrementally" })
hl.bind("SUPER + slash", dsp.focus({ workspace = "previous" }), { desc = "Switch to the previous workspace" })
hl.bind("SUPER + minus", dsp.window.move({ workspace = "special" }), { desc = "Move active window to Special workspace" })
hl.bind("SUPER + equal", dsp.workspace.toggle_special("special"), { desc = "Toggles the Special workspace" })
hl.bind("SUPER + F1", dsp.workspace.toggle_special("scratchpad"), { desc = "Call special workspace scratchpad" })
hl.bind("SUPER + ALT + SHIFT + F1", dsp.window.move({ workspace = "special:scratchpad", follow = false }), { desc = "Move active window to special workspace scratchpad" })

-- Additional Settings
hl.config({
    binds = {
        allow_workspace_cycles = true,
        workspace_back_and_forth = true,
        workspace_center_on = 1,
        movefocus_cycles_fullscreen = true,
        window_direction_monitor_fallback = true,
        drag_threshold = 10,
    },
})

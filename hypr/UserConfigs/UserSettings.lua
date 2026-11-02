-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Settings
---@module 'hl'

-- 3-finger swipe up toggles fullscreen
hl.gesture({
    fingers = 3,
    direction = "up",
    action = "fullscreen",
})

-- 4-finger swipe left closes active window (with cancel-on-swipe-back)
hl.gesture({
    fingers = 4,
    direction = "left",
    action = "close",
})

-- 4-finger swipe right toggles float/tile (handles tiled, floating, and fullscreen windows)
hl.gesture({
    fingers = 4,
    direction = "right",
    action = function()
        local w = hl.get_active_window()
        if w then
            if w.fullscreen and w.fullscreen ~= 0 then
                hl.dispatch(hl.dsp.window.fullscreen())
                if not w.floating then
                    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
                end
            else
                hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
            end
        end
    end,
})

hl.config({
    cursor = {
        no_hardware_cursors = 0,
    },
    misc = {
        -- 1: Keeps fullscreen when switching windows / alt-tabbing
        on_focus_under_fullscreen = 1,
        -- 1: When a fullscreen window is closed, the next focused window STAYS fullscreen
        exit_window_retains_fullscreen = 1,
        animate_mouse_windowdragging = true,
    },
    input = {
        kb_layout = "us",
    },
    dwindle = {
        -- preserve_split MUST be true for togglesplit (horizontal <-> vertical) to work
        preserve_split = true,
        special_scale_factor = 0.8,
    },
})

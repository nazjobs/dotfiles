-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Settings
---@module 'hl'

-- 3-finger swipe up toggles fullscreen
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        hl.dispatch(hl.dsp.window.fullscreen())
    end,
})

-- 4-finger swipe left closes active window
hl.gesture({
    fingers = 4,
    direction = "left",
    action = function()
        hl.dispatch(hl.dsp.window.close())
    end,
})

-- 4-finger swipe right toggles float/tile
hl.gesture({
    fingers = 4,
    direction = "right",
    action = function()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end,
})

hl.config({
    misc = {
        -- 1: Keeps fullscreen when switching windows / alt-tabbing
        on_focus_under_fullscreen = 1,
        -- 1: When a fullscreen window is closed, the next focused window STAYS fullscreen
        exit_window_retains_fullscreen = 1,
    },
    input = {
        kb_layout = "us",
    },
    dwindle = {
        -- Disabling preserve_split ensures that when an app is moved into a workspace
        -- or closed, windows cleanly divide the screen space equally (50/50) instead of
        -- getting stuck in old, squished or uneven resize proportions.
        preserve_split = false,
    },
})

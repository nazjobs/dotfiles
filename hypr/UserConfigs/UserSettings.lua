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

-- 4-finger swipe right toggles float/tile
hl.gesture({
    fingers = 4,
    direction = "right",
    action = "float",
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
        -- Disabling preserve_split ensures that when an app is moved into a workspace
        -- or closed, windows cleanly divide the screen space equally (50/50) instead of
        -- getting stuck in old, squished or uneven resize proportions.
        preserve_split = false,
    },
})

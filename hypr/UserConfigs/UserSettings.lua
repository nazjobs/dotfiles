-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Settings
---@module 'hl'

-- Gestures
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "left", action = "close" })
hl.gesture({ fingers = 4, direction = "right", action = "float" })

hl.config({
    misc = {
        on_focus_under_fullscreen = 1,
        exit_window_retains_fullscreen = 1,
    },
    input = {
        kb_layout = "us",
    },
    dwindle = {
        -- Disabling preserve_split ensures that when an app is moved into a workspace
        -- or closed, windows cleanly divide the screen space equally (50/50)
        preserve_split = false,
    },
})

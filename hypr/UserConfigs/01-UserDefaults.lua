-- /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
-- User Default Applications & Settings
---@module 'hl'

hl.env("EDITOR", "nvim")

-- Store defaults globally for reference across Lua config modules
_G.USER_DEFAULTS = _G.USER_DEFAULTS or {}
_G.USER_DEFAULTS.term = "alacritty"
_G.USER_DEFAULTS.files = "thunar"
_G.USER_DEFAULTS.edit = os.getenv("EDITOR") or "nvim"
_G.USER_DEFAULTS.search_engine = "https://www.google.com/search?q={}"

# AGENTS.md

Personal dotfiles for a CachyOS/Hyprland Linux desktop.

## Structure

- `hypr/` — Hyprland compositor config (JaKooLit Hyprland-Dots v2.3.20). `hyprland.conf` sources `configs/*.conf` (vendor defaults) then `UserConfigs/*` (your overrides). `scripts/` and `UserScripts/` hold the shell/pyth returned helpers. Edit a user file in `UserConfigs/`, not the `configs/` defaults — those get overwritten by dot update.sh. Runtime state (`.initial_startup_done`, `wallust/wallust-hyprland.conf`, `wallpaper_effects/.wallpaper_*`) is gitignored, so it stays dirty-free while active.
- `nvim/` — LazyVim-based Neovim config. Init is `require("config.lazy")`. Custom plugins in `lua/plugins/`.
- `mpv/` — MPV player with uosc UI and autosub (requires `subliminal` CLI). Bindings: `b` = download subs, `n` = manual.
- `viu/` — [Viu](https://github.com/viu-media/Viu) terminal anime browser. `config.ini` is auto-generated; `config.toml` is the manual config. `auth.json` contains AniList token. Both `.sessions/` and `registry.json` are gitignored.
- `fish/` — Fish shell config. Mirrors `~/.config/fish/`. API keys live in `secrets.fish` (gitignored) sourced from `config.fish`. `fish_variables` (auto-generated) is also gitignored.

## Code style

- `stylua` for Lua formatting (nvim only): `stylua --config-path nvim/stylua.toml nvim/` (2-space indent, 120 col width).

## Git conventions

- Origin: `git@github.com:nazjobs/dotfiles.git`
- Commit messages use conventional commits: `area(scope): message` (e.g. `nvim(plugins): add avante`, `hypr: add window rule for TF2`).

## Known rough edges

- `nvim/lua/plugins/avante.lua` has 4 duplicate `custom_tools` definitions — only the last one is effective. Clean it up if editing avante config.
- `viu/auth.json` contains a live AniList token — avoid committing changes.
- No CI, no tests, no formatters other than stylua.

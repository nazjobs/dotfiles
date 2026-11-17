# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Codex

[codex.nvim](https://github.com/nwiizo/codex.nvim) embeds the Codex CLI in a right-hand split.
Requires Neovim 0.12+ and an authenticated [Codex CLI](https://developers.openai.com/codex/cli/) on `PATH`.
Run `codex login` once if needed. The plugin uses your existing CLI configuration and credentials.
It is disabled inside VS Code, where the existing editor AI mappings apply.

The leader key is Space.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ac` | Normal | Toggle Codex without stopping the session |
| `<leader>af` | Normal | Focus Codex, or hide it when already focused |
| `<leader>ar` | Normal | Pick a previous session to resume |
| `<leader>aC` | Normal | Continue the latest session in the current project |
| `<leader>ab` | Normal | Add the current file to the composer without submitting |
| `<leader>aa` | Normal / Visual | Draft a request with the current file or exact selection |
| `<leader>aE` | Visual | Draft an edit request for the exact selection |
| `<leader>as` | Visual / Explorer | Send the selection, or add selected explorer files |
| `<leader>aS` | Visual | Add the selection to the composer without submitting |
| `<leader>ad` | Normal | View tracked Git changes in a read-only diff |
| `<leader>aq` | Normal | Stop the Codex process |

In a request draft, use `Ctrl-s` to send. In the Codex terminal, use `Alt-h/j/k/l` to move between
windows, or `Ctrl-\` followed by `Ctrl-n` to enter Neovim Normal mode. `Esc` stays available to Codex.

The session starts in the active file's Git project root. Stop the current session with `:CodexStop`
before starting a different project or resuming another conversation. Use `:checkhealth codex` to
verify the integration. Codex manages edit approvals; `:CodexDiff` displays staged and unstaged
tracked changes, including your own edits, and excludes untracked files and unsaved buffers.

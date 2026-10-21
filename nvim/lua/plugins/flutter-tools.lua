return {
  "nvim-flutter/flutter-tools.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  config = true,
}

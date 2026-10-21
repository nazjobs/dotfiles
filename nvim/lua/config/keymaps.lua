-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is for your own custom keymaps
-- See `:help vim.keymap.set()`
local Util = require("lazyvim.util")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Open Markdown preview
    vim.keymap.set("n", "<leader>!p", "<cmd>Glow<CR>", { desc = "Markdown Preview" })
  end,
})

-- -- AI/CodeCompanion keymaps
-- vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanion<CR>", { desc = "CodeCompanion Toggle" })
-- vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" })
-- vim.keymap.set("n", "<leader>aC", "<cmd>CodeCompanionChatToggle<CR>", { desc = "CodeCompanion Chat Toggle" })

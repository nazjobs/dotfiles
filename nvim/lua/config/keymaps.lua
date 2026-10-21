-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is for your own custom keymaps
-- See `:help vim.keymap.set()`
local Util = require("lazyvim.util")

if not vim.g.vscode then
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
else
  local vscode = require("vscode")

  -- Cursor AI keymaps
  vim.keymap.set({ "n", "v" }, "<leader>aa", function()
    vscode.action("workbench.action.chat.open")
  end, { desc = "Cursor AI Chat / Agent" })

  vim.keymap.set({ "n", "v" }, "<leader>ac", function()
    vscode.action("workbench.action.chat.open")
  end, { desc = "Cursor AI Chat" })

  vim.keymap.set({ "n", "v" }, "<leader>ai", function()
    vscode.action("aipopup.action.modal.generate")
  end, { desc = "Cursor Inline Generate / Edit" })

  vim.keymap.set({ "n", "v" }, "<leader>ap", function()
    vscode.action("composer.startComposerPrompt")
  end, { desc = "Cursor Composer Prompt" })

  -- VSCode UI conveniences
  vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.action.toggleSidebarVisibility")
  end, { desc = "Toggle Primary Sidebar" })

  vim.keymap.set("n", "<leader>gg", function()
    vscode.action("workbench.view.scm")
  end, { desc = "Open Source Control" })
end

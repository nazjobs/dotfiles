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

-- Avante provider quick-switch
local avante_providers = {
  "ollama_deepseek",
  "ollama_qwen",
  "free_qwen_coder",
  "free_deepseek",
  "free_nemotron",
  "paid_deepseek_v32",
  "paid_deepseek_r1",
  "paid_minimax",
  "gemini_flash25",
  "gemini_flash_lite",
  "gemini_15_flash8b",
}

vim.keymap.set("n", "<leader>aP", function()
  vim.ui.select(avante_providers, {
    prompt = "Select Avante Provider:",
  }, function(choice)
    if choice then
      require("avante.config").override({ provider = choice })
      vim.notify("Avante provider: " .. choice, vim.log.levels.INFO)
    end
  end)
end, { desc = "Avante: select named provider" })

-- -- AI/CodeCompanion keymaps
-- vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanion<CR>", { desc = "CodeCompanion Toggle" })
-- vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" })
-- vim.keymap.set("n", "<leader>aC", "<cmd>CodeCompanionChatToggle<CR>", { desc = "CodeCompanion Chat Toggle" })

-- return {
--   -- Markdown previewer
--   {
--     "ellisonleao/glow.nvim",
--     config = function()
--       require("glow").setup({})
--     end,
--     cmd = "Glow",
--   },
-- }
--

return {
  -- Markdown previewer
  {
    "ellisonleao/glow.nvim",
    cond = not vim.g.vscode,
    config = function()
      require("glow").setup({})
    end,
    cmd = "Glow",
  },
}

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make BUILD_FROM_SOURCE=true",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "ravitemer/mcphub.nvim",
  },
  opts = {
    provider = "ollama_deepseek", -- default: local, free, always on

    providers = {

      -- ── OLLAMA (local) ──────────────────────────────────────────────
      ollama_deepseek = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://127.0.0.1:11434/v1",
        model = "deepseek-coder:6.7b-instruct-q4_K_M",
        disable_tools = true,
      },
      ollama_qwen = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://127.0.0.1:11434/v1",
        model = "qwen2.5-coder:7b",
        disable_tools = true,
      },

      -- ── OPENROUTER (cloud free, no daily cap) ────────────────────────
      or_deepseek = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-chat-v3-0324:free",
      },
      or_deepseek_r1 = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-r1:free", -- good for hard problems
      },
      or_gemini_pro = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "google/gemini-2.5-pro-exp-03-25:free",
      },
      or_llama = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "meta-llama/llama-4-maverick:free",
      },

      -- ── GEMINI DIRECT (rotate when rate limited) ─────────────────────
      gemini_flash25 = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-2.5-flash", -- 5 RPM, 20 RPD
      },
      gemini_flash_lite = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-2.5-flash-lite-preview-06-17", -- 15 RPM, 500 RPD
      },
      gemini_15_flash = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-1.5-flash", -- 15 RPM, 1500 RPD
      },
      gemini_15_flash8b = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-1.5-flash-8b", -- 15 RPM, 1500 RPD (best free quota)
      },
    },

    system_prompt = function()
      local ok, hub_mod = pcall(require, "mcphub")
      if not ok then
        return ""
      end
      local hub = hub_mod.get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
      local ok, ext = pcall(require, "mcphub.extensions.avante")
      if not ok then
        return {}
      end
      return ext.get_tools and ext.get_tools() or {}
    end,
  },
}

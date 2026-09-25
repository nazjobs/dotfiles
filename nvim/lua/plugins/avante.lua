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
    provider = "ollama_deepseek",

    providers = {

      -- ── OLLAMA (local, always free) ──────────────────────────────────
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

      -- ── FREE (auto-router picks whatever free model is currently live) ─
      free_auto = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "openrouter/free",
        max_tokens = 8192,
      },

      -- ── PAID (cheap, ~$0.002-0.005 per coding request) ────────────────
      paid_deepseek_v32 = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-v3.2", -- $0.23/M in, $0.34/M out
        max_tokens = 8192,
      },
      paid_deepseek_r1 = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-r1", -- $0.55/M in, $2.19/M out
        max_tokens = 8192,
      },
      paid_minimax = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "minimax/minimax-m3", -- $0.30/M in, $1.20/M out
        max_tokens = 8192,
      },
      paid_qwen_coder = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "qwen/qwen3-coder", -- ~$0.30/M in
        max_tokens = 8192,
      },

      -- ── GEMINI DIRECT (rotate when rate limited) ───────────────────────
      gemini_flash25 = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-2.5-flash",
      },
      gemini_flash_lite = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-2.5-flash-lite-preview-06-17",
      },
      gemini_15_flash = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-1.5-flash",
      },
      gemini_15_flash8b = {
        __inherited_from = "gemini",
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-1.5-flash-8b",
      },
    },

    -- NOTE: there is exactly ONE system_prompt and ONE custom_tools key here.
    -- Duplicate keys in a Lua table are legal syntax but only the LAST one
    -- takes effect silently — that was the bug that caused mcphub tools to
    -- keep injecting into ollama/local models regardless of the toggle.
    system_prompt = function()
      local ok_cfg, avante_config = pcall(require, "avante.config")
      local provider = ok_cfg and avante_config.provider or ""

      -- Small local models: override with minimal prompt to stop tool hallucination
      if vim.startswith(provider, "ollama_") then
        return "You are a helpful coding assistant. Reply with plain text and code blocks only. Never output JSON, tool calls, or function calls."
      end

      -- Cloud models: inject mcphub/context7 only if toggled on
      if vim.g.avante_mcphub_enabled == false then
        return ""
      end
      local ok, hub_mod = pcall(require, "mcphub")
      if not ok then
        return ""
      end
      local hub = hub_mod.get_hub_instance()
      if not hub then
        return ""
      end
      local prompt = hub:get_active_servers_prompt()
      return (prompt and #prompt > 0) and prompt or ""
    end,

    custom_tools = function()
      -- Never give tools to local models, they can't handle them reliably
      local ok_cfg, avante_config = pcall(require, "avante.config")
      local provider = ok_cfg and avante_config.provider or ""
      if vim.startswith(provider, "ollama_") then
        return {}
      end

      if vim.g.avante_mcphub_enabled == false then
        return {}
      end
      local ok, ext = pcall(require, "mcphub.extensions.avante")
      if not ok then
        return {}
      end
      return ext.get_tools and ext.get_tools() or {}
    end,
  },
}

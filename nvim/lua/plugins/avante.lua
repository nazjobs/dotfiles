local _mcphub_enabled = true -- toggle this at runtime

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

      -- ── FREE TIER (no credits needed, rate limited) ──────────────────
      -- Best free coding model right now
      free_qwen_coder = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "qwen/qwen3-coder:free",
        max_tokens = 8192,
      },
      -- Free deepseek v3 (older but still solid)
      free_deepseek = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-chat-v3-0324:free",
        max_tokens = 8192,
      },
      -- Free 120B nvidia coding model
      free_nemotron = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "nvidia/llama-3.3-nemotron-super-49b-v1:free",
        max_tokens = 8192,
      },

      -- ── PAID (cheap, ~$0.002-0.005 per coding request) ──────────────
      -- Best value for coding: cheap output tokens
      paid_deepseek_v32 = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-v3.2", -- $0.23/M in, $0.34/M out
        max_tokens = 8192,
      },
      -- Reasoning for hard problems
      paid_deepseek_r1 = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-r1", -- $0.55/M in, $2.19/M out
        max_tokens = 8192,
      },
      -- MiniMax M3: multimodal, good for complex code, competitive price
      paid_minimax = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "minimax/minimax-m3", -- $0.30/M in, $1.20/M out
        max_tokens = 8192,
      },
      -- Qwen3 Coder paid: best coding benchmark right now
      paid_qwen_coder = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "qwen/qwen3-coder", -- ~$0.30/M in
        max_tokens = 8192,
      },

      -- ── GEMINI DIRECT (rotate when rate limited) ─────────────────────
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

    system_prompt = function()
      local ok_cfg, avante_config = pcall(require, "avante.config")
      local provider = ok_cfg and avante_config.provider or ""

      -- Small local models: override with minimal prompt to stop tool hallucination
      if vim.startswith(provider, "ollama_") then
        return "You are a helpful coding assistant. Reply with plain text and code blocks only. Never output JSON, tool calls, or function calls."
      end

      -- Cloud models: inject mcphub if toggled on
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
      -- Never give tools to local models, they can't handle it
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

    custom_tools = function()
      if vim.g.avante_mcphub_enabled == false then
        return {}
      end
      local ok, ext = pcall(require, "mcphub.extensions.avante")
      if not ok then
        return {}
      end
      return ext.get_tools and ext.get_tools() or {}
    end,

    custom_tools = function()
      if not _mcphub_enabled then
        return {}
      end -- <-- add this
      local ok, ext = pcall(require, "mcphub.extensions.avante")
      if not ok then
        return {}
      end
      return ext.get_tools and ext.get_tools() or {}
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

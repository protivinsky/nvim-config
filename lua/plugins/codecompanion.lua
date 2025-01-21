local keys = require("user.keys")

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  keys = {
    {
      keys.code.code_companion.key,
      "<cmd>CodeCompanionChat<cr>",
      desc = keys.code.code_companion.desc,
      mode = { "n", "v" },
    },
  },
  opts = {
    display = {
      chat = {
        window = { width = 80, },
        show_header_separator = true,
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
      },
      action_palette = { provider = "telescope" }
    },
    strategies = {
      chat = {
        roles = {
          llm = "   CodeCompanion", -- The markdown header content for the LLM's responses
          user = "   Me", -- The markdown header for your questions
        },
        slash_commands = {
          ["buffer"] = { opts = { provider = "telescope" } },
          ["file"] = { opts = { provider = "telescope" } },
          ["symbols"] = { opts = { provider = "telescope" } },
        },
      },
    },
    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend(
          "openai",
          {
            env = {
              api_key = "OPENAI_API_KEY",
            }
          }
        )
      end,
      anthropic = function()
        return require("codecompanion.adapters").extend(
          "anthropic",
          {
            env = {
              api_key = "ANTHROPIC_API_KEY",
            }
          }
        )
      end
    }
  },
}

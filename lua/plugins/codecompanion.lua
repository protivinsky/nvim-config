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
        -- unsure why, but this breakes attaching files
        show_header_separator = true,
        -- show_settings = true
      },
      action_palette = { provider = "telescope" }
    },
    opts = {
      log_level = "DEBUG",
    },
    strategies = {
      chat = {
        adapter = "anthropic",
        roles = {
          -- ---The header name for the LLM's messages
          llm = function(adapter)
            return "  CodeCompanion (" .. adapter.formatted_name .. ")"
          end,
          ---The header name for your messages
          user = "  Me",
        },
        -- roles = {
        --   llm = "  CodeCompanion", -- The markdown header content for the LLM's responses
        --   user = "  Me", -- The markdown header for your questions
        -- },
        slash_commands = {
          ["buffer"] = { opts = { provider = "telescope" } },
          ["file"] = { opts = { provider = "telescope" } },
          ["symbols"] = { opts = { provider = "telescope" } },
          ["pdf"] = {
            -- callback = "strategies.chat.slash_commands.pdf",
            callback = vim.fn.stdpath("config") .. "/lua/customcodecompanion/pdf.lua",
            description = "Insert a pdf from library",
            opts = {
              contains_code = false,
              max_lines = 2000,
              provider = "telescope", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["cmd"] = {
            -- callback = "strategies.chat.slash_commands.shell",
            callback = vim.fn.stdpath("config") .. "/lua/customcodecompanion/cmd.lua",
            description = "Run a shell command and include the output",
            opts = {
              contains_code = false,
            },
          },
        },
        variables = {
          ["general"] = {
            callback = "customcodecompanion.general",
            description = "Answer general questions instead of programming focus",
          },
          ["anki"] = {
            callback = "customcodecompanion.anki",
            description = "Anki cards",
          },
          ["pirate"] = {
            callback = "customcodecompanion.pirate",
            description = "Shakespearean pirate",
          },
        },
        tools = {
          ["mcp"] = {
            -- calling it in a function would prevent mcphub from being loaded before it's needed
            callback = function() return require("mcphub.extensions.codecompanion") end,
            description = "Call tools and resources from the MCP Servers",
            opts = {
                -- requires_approval = true,
            },
          },
        },
      },
    },
    adapters = {
      copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
              schema = { model = { default = 'gpt-4o-2024-11-20' } },
          })
      end,
      jina = function()
        return require("codecompanion.adapters").extend(
          "jina",
          { env = { api_key = "JINA_API_KEY", } }
        )
      end
    }
  },
}

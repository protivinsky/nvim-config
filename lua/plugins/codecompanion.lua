local keys = require("user.keys")

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim"
  },
  lazy = false,
  keys = {
    {
      keys.code.code_companion.key,
      "<cmd>CodeCompanionChat<cr>",
      desc = keys.code.code_companion.desc,
      mode = { "n", "v" },
    },
    {
      keys.code.code_companion_history.key,
      "<cmd>CodeCompanionHistory<cr>",
      desc = keys.code.code_companion_history.desc,
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
        adapter = "openai",
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
      http = {
        openai = function()
            return require('codecompanion.adapters').extend('openai', {
                schema = { model = { default = 'gpt-5' } },
            })
        end,
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
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Keymap to save the current chat manually (when auto_save is disabled)
          save_chat_keymap = "sc",
          -- Save all chats by default (disable to save only manually using 'sc')
          auto_save = true,
          -- Number of days after which chats are automatically deleted (0 to disable)
          expiration_days = 0,
          -- Picker interface (auto resolved to a valid picker)
          picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default") 
          ---Optional filter function to control which chats are shown when browsing
          chat_filter = nil, -- function(chat_data) return boolean end
          -- Customize picker keymaps (optional)
          picker_keymaps = {
            rename = { n = "r", i = "<M-r>" },
            delete = { n = "d", i = "<M-d>" },
            duplicate = { n = "<C-y>", i = "<C-y>" },
          },
          ---Automatically generate titles for new chats
          auto_generate_title = true,
          title_generation_opts = {
            ---Adapter for generating titles (defaults to current chat adapter) 
            adapter = nil, -- "copilot"
            ---Model for generating titles (defaults to current chat model)
            model = nil, -- "gpt-4o"
            ---Number of user prompts after which to refresh the title (0 to disable)
            refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
            ---Maximum number of times to refresh the title (default: 3)
            max_refreshes = 3,
            format_title = function(original_title)
              -- this can be a custom function that applies some custom
              -- formatting to the title.
              return original_title
            end
          },
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          ---Enable detailed logging for history extension
          enable_logging = false,

          -- Summary system
          summary = {
            -- Keymap to generate summary for current chat (default: "gcs")
            create_summary_keymap = "gcs",
            -- Keymap to browse summaries (default: "gbs")
            browse_summaries_keymap = "gbs",
            
            generation_opts = {
              adapter = nil, -- defaults to current chat adapter
              model = nil, -- defaults to current chat model
              context_size = 90000, -- max tokens that the model supports
              include_references = true, -- include slash command content
              include_tool_outputs = true, -- include tool execution results
              system_prompt = nil, -- custom system prompt (string or function)
              format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
            },
          },
          
          -- Memory system (requires VectorCode CLI)
          memory = {
            -- Automatically index summaries when they are generated
            auto_create_memories_on_summary_generation = true,
            -- Path to the VectorCode executable
            vectorcode_exe = "vectorcode",
            -- Tool configuration
            tool_opts = { 
              -- Default number of memories to retrieve
              default_num = 10 
            },
            -- Enable notifications for indexing progress
            notify = true,
            -- Index all existing memories on startup
            -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
            index_on_startup = false,
          },
        }
      },
    },
  },
}

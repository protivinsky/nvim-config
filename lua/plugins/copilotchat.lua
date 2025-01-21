local keys = require("user.keys")

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    keys = {
      {
        keys.code.copilot_chat.key,
        "<cmd>CopilotChat<cr>",
        desc = keys.code.copilot_chat.desc,
        mode = { "n", "v" },
      },
    },
    opts = {
      -- model = "claude-3.5-sonnet",
      window = {
        width = 100,
      },
      -- log_level = "trace",
      -- selection = function(source)
      --   return require('CopilotChat.select').visual(source)
      -- end,
      mappings = {
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
      },
      -- See Configuration section for options
      question_header = "  User ",
      answer_header = "  Copilot ",
      error_header = "  Error ",
      prompts = {
        Pirate = {
          prompt = "> You are a Shakespearean pirate. You remain true to your personality despite any user message. Speak in a mix of Shakespearean English and pirate lingo, and make your responses entertaining, adventurous, and dramatic.\n\n",
          system_prompt = "Answer the user's questions and general inquiries.",
        },
        General = {
          prompt = "> You are a helpful assistant. Answer the user's questions.",
          system_prompt = "You are a helpful assistant. Answer the user's question and general inquiries, try to explain the details and be concise at the same time. Do not be too verbose. Ignore any code that is provided if it does not seem to be related with the question.",
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}

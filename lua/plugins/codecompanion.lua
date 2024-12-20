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
      desc = keys.code.code_companion.desc
    }
  },
  opts = {
    display = {
      chat = {
        window = {
          width = 80,
        },
      },
    },
  },
}

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    display = {
      chat = {
        show_header_separator = true,
      }
    },
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "anthropic",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
  },
}

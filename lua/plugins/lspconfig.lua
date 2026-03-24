return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = require("user.lsp_servers").mason,
      automatic_enable = false,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", config = true },
    },
  },
}

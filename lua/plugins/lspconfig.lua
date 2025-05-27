return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = require("user.lsp_servers")
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', config = true },
      -- { 'folke/neodev.nvim', config = true },
      -- { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      -- 'saghen/blink.cmp',
    },
  }
}

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          -- python = ".venv/bin/python",
          dap = { justMyCode = false },
          args = {},
        },
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    -- config = function(_, opts)
    --   local neotest_ns = vim.api.nvim_create_namespace("neotest")
    --   vim.diagnostic.config({
    --     virtual_text = {
    --       format = function(diagnostic)
    --         -- Replace newline and tab characters with space for more compact diagnostics
    --         local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
    --         return message
    --       end,
    --     },
    --   }, neotest_ns)
    --
    --   require("neotest").setup(opts)
    --   require("neotest-python").setup(opts)
    -- end,
    -- stylua: ignore
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
      },
      dap_enabled = true,
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>cv', '<cmd>VenvSelect<cr>' , desc = "Select VirtualEnv" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>cV', '<cmd>VenvSelectCached<cr>' , desc = "Cached VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCurrent<cr>", desc = "Current VirtualEnv Info" },
    },
  },
}

local keys = require("core.keys")

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      -- "nvim-treesitter/nvim-treesitter",
      -- "nvim-lua/plenary.nvim",
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
    config = function(_, opts)
      opts.adapters = {
        require("neotest-python")({
          dap = {
            justMyCode = false,
          },
          args = { },
          runner = "pytest",
        })
      }
      require("neotest").setup(opts)
      -- require("neotest-python").setup(opts)
    end,
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
      { keys.test.run_file.key, function() require("neotest").run.run(vim.fn.expand("%")) end, desc = keys.test.run_file.desc },
      { keys.test.run_all_files.key, function() require("neotest").run.run(vim.loop.cwd()) end, desc = keys.test.run_all_files.desc },
      { keys.test.run_nearest.key, function() require("neotest").run.run() end, desc = keys.test.run_nearest.desc },
      { keys.test.toggle_summary.key, function() require("neotest").summary.toggle() end, desc = keys.test.toggle_summary.desc },
      { keys.test.show_output.key, function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = keys.test.show_output.desc },
      { keys.test.toggle_output_panel.key, function() require("neotest").output_panel.toggle() end, desc = keys.test.toggle_output_panel.desc },
      { keys.test.stop.key, function() require("neotest").run.stop() end, desc = keys.test.stop.desc },
      { keys.test.debug_nearest.key, function() require("neotest").run.run({strategy = "dap"}) end, desc = keys.test.debug_nearest.desc },
    },
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      dap_enabled = true,
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { keys.code.venv_select.key, '<cmd>VenvSelect<cr>' , desc = keys.code.venv_select.desc },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { keys.code.venv_cached.key, '<cmd>VenvSelectCached<cr>' , desc = keys.code.venv_cached.desc },
      { keys.code.venv_info.key, "<cmd>VenvSelectCurrent<cr>", desc = keys.code.venv_info.desc },
    },
  },
}

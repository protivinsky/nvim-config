local keys = require("user.keys")

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "vim-test/vim-test",
    -- "nvim-neotest/neotest-vim-test",
    "nvim-neotest/neotest-python",
    "rosstang/neotest-catch2",
  },
  opts = {
    status = { virtual_text = true },
    output = { open_on_run = true },
  },
  config = function(_, opts)
    opts.adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
        runner = "pytest",
      }),
      require("neotest-catch2"),
      -- require("neotest-cpp-custom"),
      -- require("neotest-vim-test")({
      --   ignore_file_types = { "python", "vim", "lua" },
      -- }),
    }
    -- vim.g['test#strategy'] = 'neovim'
    -- -- Setting a custom test runner
    -- vim.g['test#custom_runners'] = { cpp = { 'my_custom_runner' } }
    -- -- Define the custom runner
    -- vim.g['test#cpp#my_custom_runner#executable'] = 'cmake --build build && test/unit_tests'
    -- -- Optional: Map commands to run with your test binary
    -- vim.g['test#cpp#runner'] = 'my_custom_runner'  -- Set this as the default runner for C++
    require("neotest").setup(opts)
  end,
  keys = {
    {
      keys.test.run_file.key,
      function() require("neotest").run.run(vim.fn.expand("%")) end,
      desc = keys.test.run_file.desc
    },
    {
      keys.test.run_all_files.key,
      function() require("neotest").run.run(vim.loop.cwd()) end,
      desc = keys.test.run_all_files.desc
    },
    {
      keys.test.run_nearest.key,
      function() require("neotest").run.run() end,
      desc = keys.test.run_nearest.desc
    },
    {
      keys.test.toggle_summary.key,
      function() require("neotest").summary.toggle() end,
      desc = keys.test.toggle_summary.desc
    },
    {
      keys.test.show_output.key,
      function() require("neotest").output.open({ enter = true, auto_close = true }) end,
      desc = keys.test.show_output.desc
    },
    {
      keys.test.toggle_output_panel.key,
      function() require("neotest").output_panel.toggle() end,
      desc = keys.test.toggle_output_panel.desc
    },
    {
      keys.test.stop.key,
      function() require("neotest").run.stop() end,
      desc = keys.test.stop.desc
    },
    {
      keys.test.debug_nearest.key,
      function() require("neotest").run.run({ strategy = "dap" }) end,
      desc = keys.test.debug_nearest.desc
    },
    {
      keys.test.attach_nearest.key,
      function() require("neotest").run.attach() end,
      desc = keys.test.attach_nearest.desc
    },
  },
}

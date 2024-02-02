local keys = require("user.keys")

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-python",
    "nvim-treesitter/nvim-treesitter",
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
      })
    }
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

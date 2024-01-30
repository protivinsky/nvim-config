local keys = require('user.keys')

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      -- opts = {
      --   -- Makes a best effort to setup the various debuggers with
      --   -- reasonable debug configurations
      --   automatic_installation = true,
      --   -- You'll need to check that you have the required things installed
      --   -- online, please don't ask me how to install them :)
      --   ensure_installed = {
      --     -- Update this to ensure that you have the debuggers for the langs you want
      --     "debugpy",
      --   },
      -- },
    },
    {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { keys.debug.test_method.key, function() require('dap-python').test_method() end, desc = keys.debug.test_method.desc, ft = "python" },
        { keys.debug.test_class.key, function() require('dap-python').test_class() end, desc = keys.debug.test_class.desc, ft = "python" },
      },
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require("mason").setup()
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { "debugpy" },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', keys.debug.start.key, dap.continue, { desc = keys.debug.start.desc })
    vim.keymap.set('n', keys.debug.step_into.key, dap.step_into, { desc = keys.debug.step_into.desc })
    vim.keymap.set('n', keys.debug.step_over.key, dap.step_over, { desc = keys.debug.step_over.desc })
    vim.keymap.set('n', keys.debug.step_out.key, dap.step_out, { desc = keys.debug.step_out.desc })
    vim.keymap.set('n', keys.debug.toggle_breakpoint.key, dap.toggle_breakpoint, { desc = keys.debug.toggle_breakpoint.desc })
    vim.keymap.set('n', keys.debug.set_breakpoint.key, function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = keys.debug.set_breakpoint.desc })

    dapui.setup {}
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', keys.debug.toggle_ui.key, dapui.toggle, { desc = keys.debug.toggle_ui.desc })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup()
    local path = require("mason-registry").get_package("debugpy"):get_install_path()
    require("dap-python").setup(path .. "/venv/bin/python")
  end,
}

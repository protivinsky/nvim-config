local keys = require('core.keys')

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
    {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { keys.debug.test_method.key, function() require('dap-python').test_method() end, desc = keys.debug.test_method.desc, ft = "python" },
        { keys.debug.test_class.key, function() require('dap-python').test_class() end, desc = keys.debug.test_class.desc, ft = "python" },
      },
      config = function()
        -- local path = require("mason-registry").get_package("debugpy"):get_install_path()
        -- require("dap-python").setup(path .. "/venv/bin/python")
        require("dap-python").setup("python")
      end,
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
      },
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
  end,
}

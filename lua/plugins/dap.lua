local keys = require('user.keys')

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { keys.debug.toggle_ui.key, function() require("dapui").toggle({ }) end, desc = keys.debug.toggle_ui.desc },
        { keys.debug.eval.key, function() require("dapui").eval() end, desc = keys.debug.eval.desc, mode = {"n", "v"} },
      },
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        require("dap.ext.vscode").load_launchjs()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,
        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          "debugpy",
        },
      },
    },
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { keys.debug.test_method.key, function() require('dap-python').test_method() end, desc = keys.debug.test_method.desc, ft = "python" },
        { keys.debug.test_class.key, function() require('dap-python').test_class() end, desc = keys.debug.test_class.desc, ft = "python" },
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },
  keys = {
    { keys.debug.toggle_breakpoint.key, function() require("dap").toggle_breakpoint() end, desc = keys.debug.toggle_breakpoint.desc },
    {
      keys.debug.set_breakpoint.key,
      function() require("dap").set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
      desc = keys.debug.set_breakpoint.desc
    },
    { keys.debug.start.key, function() require("dap").continue() end, desc = keys.debug.start.desc },
    { keys.debug.run_to_cursor.key, function() require("dap").run_to_cursor() end, desc = keys.debug.run_to_cursor.desc },
    {
      keys.debug.run_with_args.key,
      function() require("dap").continue({ before = get_args }) end,
      desc = keys.debug.run_with_args.desc
    },
    { keys.debug.goto_.key, function() require("dap").goto_() end, desc = keys.debug.goto_.desc },
    { keys.debug.step_into.key, function() require("dap").step_into() end, desc = keys.debug.step_into.desc },
    { keys.debug.step_out.key, function() require("dap").step_out() end, desc = keys.debug.step_out.desc },
    { keys.debug.step_over.key, function() require("dap").step_over() end, desc = keys.debug.step_over.desc },
    { keys.debug.up.key, function() require("dap").up() end, desc = keys.debug.up.desc },
    { keys.debug.down.key, function() require("dap").down() end, desc = keys.debug.down.desc },
    { keys.debug.run_last.key, function() require("dap").run_last() end, desc = keys.debug.run_last.desc },
    { keys.debug.pause.key, function() require("dap").pause() end, desc = keys.debug.pause.desc },
    { keys.debug.session.key, function() require("dap").session() end, desc = keys.debug.session.desc },
    { keys.debug.terminate.key, function() require("dap").terminate() end, desc = keys.debug.terminate.desc },
    { keys.debug.widgets.key, function() require("dap.ui.widgets").hover() end, desc = keys.debug.widgets.desc },
    { keys.debug.toggle_repl.key, function() require("dap").repl.toggle() end, desc = keys.debug.toggle_repl.desc },
  },

  config = function()
    -- local dap = require 'dap'
    -- local dapui = require 'dapui'
    --
    -- require("mason").setup()
    -- require('mason-nvim-dap').setup {
    --   automatic_installation = true,
    --   handlers = {},
    --   ensure_installed = { "debugpy" },
    -- }
    --
    -- -- Basic debugging keymaps, feel free to change to your liking!
    -- vim.keymap.set('n', keys.debug.start.key, dap.continue, { desc = keys.debug.start.desc })
    -- vim.keymap.set('n', keys.debug.step_into.key, dap.step_into, { desc = keys.debug.step_into.desc })
    -- vim.keymap.set('n', keys.debug.step_over.key, dap.step_over, { desc = keys.debug.step_over.desc })
    -- vim.keymap.set('n', keys.debug.step_out.key, dap.step_out, { desc = keys.debug.step_out.desc })
    -- vim.keymap.set('n', keys.debug.toggle_breakpoint.key, dap.toggle_breakpoint, { desc = keys.debug.toggle_breakpoint.desc })
    -- vim.keymap.set('n', keys.debug.set_breakpoint.key, function()
    --   dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    -- end, { desc = keys.debug.set_breakpoint.desc })
    --
    -- -- dapui.setup {}
    -- -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    -- -- vim.keymap.set('n', keys.debug.toggle_ui.key, dapui.toggle, { desc = keys.debug.toggle_ui.desc })

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(require("user.util").icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

    -- -- Install golang specific config
    -- -- require('dap-go').setup()
    -- local path = require("mason-registry").get_package("debugpy"):get_install_path()
    -- require("dap-python").setup(path .. "/venv/bin/python")
  end,
}

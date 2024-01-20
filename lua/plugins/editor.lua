local keys = require("core.keys")

return {
  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      {
        keys.quit.restore_session.key,
        function() require("persistence").load() end,
        desc = keys.quit.restore_session.desc
      },
      {
        keys.quit.restore_last_session.key,
        function() require("persistence").load({ last = true }) end,
        desc = keys.quit.restore_last_session.desc
      },
      {
        keys.quit.not_store.key,
        function() require("persistence").stop() end,
        desc = keys.quit.not_store.desc
      },
    },
  },

  -- window picker, handy for file explorer
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        hint = 'floating-big-letter',
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', "quickfix" },
          },
        },
      })
    end,
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      {
        keys.code.replace_spectre.key,
        function() require("spectre").open() end,
        desc = keys.code.replace_spectre.desc
      },
    },
  },

}

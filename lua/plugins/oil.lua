local keys = require("user.keys")

return {
  'stevearc/oil.nvim',
  opts = {},
  lazy = false,
  keys = {
    { keys.oil.open.key, "<CMD>Oil<CR>", desc = keys.oil.open.desc },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

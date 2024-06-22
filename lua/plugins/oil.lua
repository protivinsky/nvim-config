local keys = require("user.keys")

return {
  'stevearc/oil.nvim',
  opts = {},
  keys = {
    { keys.oil.open.key, mode= "n", "<CMD>Oil<CR>", desc = keys.oil.open.desc },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

return {
  'stevearc/oil.nvim',
  opts = {},
  keys = {
    { "-", mode= "n", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

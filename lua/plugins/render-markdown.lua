return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    bullet = { right_pad = 1 },
    anti_conceal = { enabled = false },
    latex = { enabled = false },
  },
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}

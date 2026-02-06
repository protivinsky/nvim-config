return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    bullet = { right_pad = 1 },
    anti_conceal = { enabled = true },
    latex = { enabled = false },
    file_types = { 'markdown', 'copilot-chat', 'codecompanion', 'Avante' },
  },
  ft = { "markdown", "Avante" },
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}

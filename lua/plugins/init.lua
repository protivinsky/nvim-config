return {
  "folke/neodev.nvim",           -- completion etc for nvim lua API
  "folke/which-key.nvim",        -- popup with keympas
  "tpope/vim-sleuth",            -- automatic buffer indentation
  "echasnovski/mini.bufremove",  -- keep window layout after deleting a buffer
  
  -- some other plugins require icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

}

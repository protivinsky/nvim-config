return {
  "folke/neodev.nvim",            -- completion etc for nvim lua API
  "folke/which-key.nvim",         -- popup with keympas
  "tpope/vim-sleuth",             -- automatic buffer indentation
  "echasnovski/mini.bufremove",   -- keep window layout after deleting a buffer
  "nvim-lua/plenary.nvim",        -- handy lua functions other plugins use
  "RRethy/vim-illuminate",

  -- some other plugins require icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Add indentation guides even on blank lines, see `:help ibl`
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}  },

  -- OTHER PLUGINS
  -- ui.lua:
  --  "aserowy/tmux.nvim"
  --  "navarasu/onedark.nvim"
  --  "nvim-lualine/lualine.nvim"
  --  "akinsho/bufferline.nvim"
  -- editor.lua:
  --  "folke/persistence.nvim"
  --  "s1n7ax/nvim-window-picker"
  --  "nvim-neo-tree/neo-tree.nvim"
  -- term.lua:
  --  "akinsho/toggleterm.nvim"
  -- treesitter.lua:
  --  "nvim-treesitter/nvim-treesitter"
  --  "nvim-treesitter/nvim-treesitter-context"

}

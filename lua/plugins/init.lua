local keys = require("user.keys")

return {
  "tpope/vim-sleuth",             -- automatic buffer indentation
  "echasnovski/mini.bufremove",   -- keep window layout after deleting a buffer
  "nvim-lua/plenary.nvim",        -- handy lua functions other plugins use
  "RRethy/vim-illuminate",
  "sindrets/diffview.nvim",
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  "bfredl/nvim-luadev",

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = { style = "warmer" },
    config = function(_, opts)
      require("onedark").setup(opts)
      vim.cmd.colorscheme "onedark"
    end,
  },

  -- completion etc for nvim lua API
  { "folke/lazydev.nvim", ft = "lua", config = true },
  -- some other plugins require icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      local devicons = require("nvim-web-devicons")
      devicons.setup()
      devicons.set_icon_by_filetype({
        toggleterm = "terminal"
      })
    end,
  },
  {
      "rachartier/tiny-devicons-auto-colors.nvim",
      dependencies = {
          "nvim-tree/nvim-web-devicons"
      },
      event = "VeryLazy",
      config = function()
      local theme_colors = require("onedark.colors")
      require('tiny-devicons-auto-colors').setup({
        colors = theme_colors,
      })
      end
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.set("openscad", { "//%s", "/*%s*/" })
    end
  },

  -- Add indentation guides even on blank lines, see `:help ibl`
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}  },

  {
    'stevearc/overseer.nvim',
    keys = {
      { keys.task.run.key, "<cmd>OverseerRun<cr>", desc = keys.task.run.desc }
    },
    opts = {
      strategy = { "toggleterm", direction = "horizontal" },
    },
  },

  {
    "aserowy/tmux.nvim",
    version = false,
    lazy = false,
    config = function()
      require("tmux").setup()
    end,
  },
}

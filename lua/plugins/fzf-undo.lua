-- FZF-lua undo tree visualization (replacement for telescope-undo)
-- NOTE: fzf-lua doesn't have built-in undo, so we keep telescope-undo
-- or use this custom implementation with undo tree
return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  keys = {
    {
      "<leader>su",
      "<cmd>Telescope undo<cr>",
      desc = "undo history",
    },
  },
  opts = {
    extensions = {
      undo = {
        mappings = {
          i = {
            ["<cr>"] = function(bufnr)
              return require("telescope-undo.actions").restore(bufnr)
            end
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("undo")
  end,
}

-- Alternative: If you want to use mbbill/undotree instead
-- return {
--   "mbbill/undotree",
--   keys = {
--     { "<leader>su", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
--   },
--   config = function()
--     vim.g.undotree_WindowLayout = 2
--     vim.g.undotree_ShortIndicators = 1
--     vim.g.undotree_SetFocusWhenToggle = 1
--   end,
-- }

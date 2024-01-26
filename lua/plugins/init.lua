local keys = require("user.keys")

return {
  "folke/neodev.nvim",            -- completion etc for nvim lua API
  "tpope/vim-sleuth",             -- automatic buffer indentation
  "echasnovski/mini.bufremove",   -- keep window layout after deleting a buffer
  "nvim-lua/plenary.nvim",        -- handy lua functions other plugins use
  "RRethy/vim-illuminate",
  "sindrets/diffview.nvim",

  -- some other plugins require icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Add indentation guides even on blank lines, see `:help ibl`
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",

    keys = {
      {
        keys.buffer.delete.key,
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = keys.buffer.delete.desc,
      },
      -- stylua: ignore
      {
        keys.buffer.force_delete.key,
        function() require("mini.bufremove").delete(0, true) end,
        desc = keys.buffer.force_delete.desc,
      },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { keys.trouble.doc_diag.key, "<cmd>TroubleToggle document_diagnostics<cr>", desc = keys.trouble.doc_diag.desc },
      { keys.trouble.ws_diag.key, "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = keys.trouble.ws_diag.desc },
      { keys.trouble.loclist.key, "<cmd>TroubleToggle loclist<cr>", desc = keys.trouble.loclist.desc },
      { keys.trouble.quickfix.key, "<cmd>TroubleToggle quickfix<cr>", desc = keys.trouble.quickfix.desc },
      {
        keys.trouble.prev.key,
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = keys.trouble.prev.desc,
      },
      {
        keys.trouble.next.key,
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = keys.trouble.next.desc,
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "VeryLazy",
    config = true,
    -- stylua: ignore
    keys = {
      { keys.loc.next_todo.key, function() require("todo-comments").jump_next() end, desc = keys.loc.next_todo.desc },
      { keys.loc.prev_todo.key, function() require("todo-comments").jump_prev() end, desc = keys.loc.prev_todo.desc },
      { keys.trouble.todo.key, "<cmd>TodoTrouble<cr>", desc = keys.trouble.todo.desc },
      { keys.trouble.todo_fix_fixme.key, "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = keys.trouble.todo_fix_fixme.desc },
      { keys.search.todo.key, "<cmd>TodoTelescope<cr>", desc = keys.search.todo.desc },
      { keys.search.todo_fix_fixme.key, "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = keys.search.todo_fix_fixme.desc },
    },
  },
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

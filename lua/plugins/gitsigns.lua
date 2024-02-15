local keys = require('user.keys')

return {
  -- Git related plugins
  -- 'tpope/vim-fugitive',
  -- 'tpope/vim-rhubarb',
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- signs = {
      --   add = { hl = "GitSignsAdd", text = " ", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      --   change = { hl = "GitSignsChange", text = " ", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      --   delete = { hl = "GitSignsDelete", text = " ", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      --   topdelete = { hl = "GitSignsDelete", text = "󱅁 ", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      --   changedelete = { hl = "GitSignsChange", text = "󰍷 ", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      -- },
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      -- -- See `:help gitsigns.txt`
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, keys.loc.next_hunk.key, function()
          if vim.wo.diff then
            return keys.loc.next_hunk.key
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = keys.loc.next_hunk.desc })

        map({ 'n', 'v' }, keys.loc.prev_hunk.key, function()
          if vim.wo.diff then
            return keys.loc.prev_hunk.key
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = keys.loc.prev_hunk.desc })

        -- Actions
        -- visual mode
        map('v', keys.git.stage_hunk.key, function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = keys.git.stage_hunk.desc })
        map('v', keys.git.reset_hunk.key, function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = keys.git.reset_hunk.desc })
        -- normal mode
        map('n', keys.git.stage_hunk.key, gs.stage_hunk, { desc = keys.git.stage_hunk.desc })
        map('n', keys.git.reset_hunk.key, gs.reset_hunk, { desc = keys.git.reset_hunk.desc })
        map('n', keys.git.stage_buffer.key, gs.stage_buffer, { desc = keys.git.stage_buffer.desc })
        map('n', keys.git.undo_stage_hunk.key, gs.undo_stage_hunk, { desc = keys.git.undo_stage_hunk.desc })
        map('n', keys.git.reset_buffer.key, gs.reset_buffer, { desc = keys.git.reset_buffer.desc })
        map('n', keys.git.preview_hunk.key, gs.preview_hunk, { desc = keys.git.preview_hunk.desc })
        map('n', keys.git.blame_line.key, function()
          gs.blame_line { full = false }
        end, { desc = keys.git.blame_line.desc })
        map('n', keys.git.diff_against_index.key, gs.diffthis, { desc = keys.git.diff_against_index.desc })
        map('n', keys.git.diff_against_last_commit.key, function()
          gs.diffthis '~'
        end, { desc = keys.git.diff_against_last_commit.desc })

        -- Toggles
        map('n', keys.git.toggle_blame_line.key, gs.toggle_current_line_blame, { desc = keys.git.toggle_blame_line.desc })
        map('n', keys.git.toggle_deleted.key, gs.toggle_deleted, { desc = keys.git.toggle_deleted.desc })

        -- Text object
        map({ 'o', 'x' }, keys.git.select_hunk.key, ':<C-U>Gitsigns select_hunk<CR>', { desc = keys.git.select_hunk.desc })
      end,
    },
  },
}

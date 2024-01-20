-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
-- vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
-- vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })


local keys = require("core.keys")
local builtin = require("telescope.builtin")

vim.keymap.set("n", keys.find.buffers.key, function() builtin.buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true}) end, { desc = keys.find.buffers.desc })
vim.keymap.set("n", keys.search.buffer.key, builtin.current_buffer_fuzzy_find, { desc = keys.search.buffer.key })
vim.keymap.set('n', keys.find.oldfiles.key, builtin.oldfiles, { desc = keys.find.oldfiles.desc })
vim.keymap.set("n", keys.search.command_history.key, builtin.command_history, { desc = keys.search.command_history.desc })
vim.keymap.set("n", keys.find.files.key, builtin.find_files, { desc = keys.find.files.desc })

-- find
vim.keymap.set("n", keys.find.files.key2, builtin.find_files, { desc = keys.find.files.desc })
vim.keymap.set("n", keys.find.config.key, function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = keys.find.config.desc })
vim.keymap.set("n", keys.find.buffers.key2, function() builtin.buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true}) end, { desc = keys.find.buffers.desc })
vim.keymap.set('n', keys.find.oldfiles.key2, builtin.oldfiles, { desc = keys.find.oldfiles.desc })
vim.keymap.set("n", keys.find.git_files.key, builtin.git_files, { desc = keys.find.git_files.desc })
vim.keymap.set("n", keys.find.jumplist.key, builtin.jumplist, { desc = keys.find.jumplist.desc })

-- git
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "commits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "status" })

      -- search
vim.keymap.set("n", keys.search.registers.key, builtin.registers, { desc = keys.search.registers.desc })
vim.keymap.set("n", keys.search.autocommands.key, builtin.autocommands, { desc = keys.search.autocommands.desc })
vim.keymap.set("n", keys.search.buffer.key2, builtin.current_buffer_fuzzy_find, { desc = keys.search.buffer.desc })
vim.keymap.set("n", keys.search.command_history.key2, builtin.command_history, { desc = keys.search.command_history.desc })
vim.keymap.set("n", keys.search.commands.key, builtin.commands, { desc = keys.search.commands.desc })
vim.keymap.set("n", keys.search.doc_diag.key, function() builtin.diagnostics({ bufnr = 0 }) end, { desc = keys.search.doc_diag.desc })
vim.keymap.set("n", keys.search.ws_diag.key, builtin.diagnostics, { desc = keys.search.ws_diag.desc })
vim.keymap.set("n", keys.search.live_grep.key, builtin.live_grep, { desc = keys.search.live_grep.desc })
vim.keymap.set("n", keys.search.help.key, builtin.help_tags, { desc = keys.search.help.desc })
vim.keymap.set("n", keys.search.highlights.key, builtin.highlights, { desc = keys.search.highlights.desc })
vim.keymap.set("n", keys.search.keymaps.key, builtin.keymaps, { desc = keys.search.keymaps.desc })
vim.keymap.set("n", keys.search.man_pages.key, builtin.man_pages, { desc = keys.search.man_pages.desc })
vim.keymap.set("n", keys.search.marks.key, builtin.marks, { desc = keys.search.marks.desc })
vim.keymap.set("n", keys.search.options.key, builtin.vim_options, { desc = keys.search.options.desc })
vim.keymap.set("n", keys.search.resume.key, builtin.resume, { desc = keys.search.resume.desc })

vim.keymap.set("n", keys.search.word_root.key, function() builtin.grep_string({ word_match = "-w" }) end, { desc = keys.search.word_root.desc })
vim.keymap.set("n", keys.search.word_cwd.key, function() builtin.grep_string({ cwd = false, word_match = "-w" }) end, { desc = keys.search.word_cwd.desc })
vim.keymap.set("v", keys.search.word_root.key, function() builtin.grep_string({ word_match = "-w" }) end, { desc = keys.search.word_root.desc })
vim.keymap.set("v", keys.search.word_cwd.key, function() builtin.grep_string({ cwd = false, word_match = "-w" }) end, { desc = keys.search.word_cwd.desc })
vim.keymap.set("n", keys.search.colorscheme.key, function() builtin.colorscheme({ enable_preview = true }) end, { desc = keys.search.colorscheme.desc })

vim.keymap.set("n", keys.lsp.doc_symbols.key, builtin.lsp_document_symbols, { desc = keys.lsp.doc_symbols.desc })
vim.keymap.set("n", keys.lsp.ws_symbols.key, builtin.lsp_dynamic_workspace_symbols, { desc = keys.lsp.ws_symbols.desc })

-- vim.keymap.set(
--   "n",
--   "<leader>ss",
--   function()
--     builtin.lsp_document_symbols({
--       symbols = require("lazyvim.config").get_kind_filter(),
--     })
--   end,
--   { desc = "Goto symbol (document)" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>sS",
--   function()
--     builtin.lsp_dynamic_workspace_symbols({
--       symbols = require("lazyvim.config").get_kind_filter(),
--     })
--   end,
--   { desc = "Goto symbol (document)" }
-- )

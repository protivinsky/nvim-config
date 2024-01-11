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


local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>,", function() builtin.buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true}) end, { desc = "Switch buffer" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Recently opened files' })
-- vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Find files" })

-- find
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fc", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find config file" })
vim.keymap.set("n", "<leader>fb", function() builtin.buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true}) end, { desc = "Switch buffer" })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recently opened files' })
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git files" })

-- git
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "commits" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "status" })

      -- search
vim.keymap.set("n", '<leader>s"', builtin.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Auto commands" })
vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", builtin.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() builtin.diagnostics({ bufnr = 0 }) end, { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>sD", builtin.diagnostics, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sG", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>so", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help pages" })
vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Search highlight groups" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Key maps" })
vim.keymap.set("n", "<leader>sM", builtin.man_pages, { desc = "Man pages" })
vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Jump to mark" })
vim.keymap.set("n", "<leader>sO", builtin.vim_options, { desc = "Options" })
vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Resume" })

vim.keymap.set("n", "<leader>sw", function() builtin.grep_string({ word_match = "-w" }) end, { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", function() builtin.grep_string({ cwd = false, word_match = "-w" }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function() builtin.grep_string({ word_match = "-w" }) end, { desc = "Word (root dir)" })
vim.keymap.set("v", "<leader>sW", function() builtin.grep_string({ cwd = false, word_match = "-w" }) end, { desc = "Word (cwd)" })
vim.keymap.set("n", "<leader>uC", function() builtin.colorscheme({ enable_preview = true }) end, { desc = "Colorscheme with preview" })

vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Goto symbol (document)" })
vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Goto symbol (workspace)" })

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

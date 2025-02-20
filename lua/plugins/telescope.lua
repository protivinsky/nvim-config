local keys = require("user.keys")

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

-- Allow for window selection with window picker plugin
-- https://github.com/nvim-telescope/telescope-file-browser.nvim/issues/306
local transform_mod = require('telescope.actions.mt').transform_mod
local actions = require('telescope.actions')

local window_picker  = transform_mod({
  select = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local picker = action_state.get_current_picker(prompt_bufnr)
    picker.original_win_id = require('window-picker').pick_window()
  end,
})


return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    -- branch = '0.1.x',
    cmd = "Telescope",
    version  = false,
    dependencies = {
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-telescope/telescope-bibtex.nvim" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-w>'] = window_picker.select + actions.select_default,
          },
        },
      },
      extensions = {
        bibtex = {
          global_files = { "~/library.bib" },
          search_keys = { "author", "date", "title", "keywords" },
        },
      },
    },
    keys = {
      { keys.find.buffers.key, function() require("telescope.builtin").buffers({ sort_mru = true, sort_lastused = true, select_current = true }) end, desc = keys.find.buffers.desc },
      { keys.search.buffer.key, "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = keys.search.buffer.key },
      { keys.find.oldfiles.key, "<cmd>Telescope oldfiles<cr>", desc = keys.find.oldfiles.desc },
      { keys.search.command_history.key, "<cmd>Telescope command_history<cr>", desc = keys.search.command_history.desc },
      { keys.find.files.key, "<cmd>Telescope find_files<cr>", desc = keys.find.files.desc },

      -- find
      { keys.find.files.key2, "<cmd>Telescope find_files<cr>", desc = keys.find.files.desc },
      { keys.find.files_no_ignore.key, "<cmd>Telescope find_files no_ignore=true<cr>", desc = keys.find.files_no_ignore.desc },
      { keys.find.config.key, function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = keys.find.config.desc },
      { keys.find.buffers.key2, function() require("telescope.builtin").buffers({ sort_mru = true, sort_lastused = true, ignore_current_buffer = true}) end, desc = keys.find.buffers.desc },
      { keys.find.oldfiles.key2, "<cmd>Telescope oldfiles<cr>", desc = keys.find.oldfiles.desc },
      { keys.find.git_files.key, "<cmd>Telescope git_files<cr>", desc = keys.find.git_files.desc },
      { keys.find.treesitter.key, "<cmd>Telescope treesitter<cr>", desc = keys.find.treesitter.desc },
      { keys.find.builtin.key, "<cmd>Telescope builtin<cr>", desc = keys.find.builtin.desc },
      { keys.find.reloader.key, "<cmd>Telescope reloader<cr>", desc = keys.find.reloader.desc },
      { keys.find.planets.key, "<cmd>Telescope planets<cr>", desc = keys.find.planets.desc },

      -- git
      { keys.git.branches.key, "<cmd>Telescope git_branches<cr>", desc = keys.git.branches.desc },
      { keys.git.commits.key, "<cmd>Telescope git_commits<cr>", desc = keys.git.commits.desc },
      { keys.git.status.key, "<cmd>Telescope git_status<cr>", desc = keys.git.status.desc },
      { keys.git.stash.key, "<cmd>Telescope git_stash<cr>", desc = keys.git.stash.desc },

      -- search
      { keys.search.registers.key, "<cmd>Telescope registers<cr>", desc = keys.search.registers.desc },
      {
        keys.search.live_grep_args.key,
        function() require("telescope").extensions.live_grep_args.live_grep_args() end,
        desc = keys.search.live_grep_args.desc
      },
      { keys.search.autocommands.key, "<cmd>Telescope autocommands<cr>", desc = keys.search.autocommands.desc },
      { keys.search.bibtex.key, "<cmd>Telescope bibtex<cr>", desc = keys.search.bibtex.desc },
      { keys.search.command_history.key2, "<cmd>Telescope command_history<cr>", desc = keys.search.command_history.desc },
      { keys.search.commands.key, "<cmd>Telescope commands<cr>", desc = keys.search.commands.desc },
      { keys.search.doc_diag.key, function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = keys.search.doc_diag.desc },
      { keys.search.ws_diag.key, "<cmd>Telescope diagnostics<cr>", desc = keys.search.ws_diag.desc },
      { keys.search.live_grep.key, "<cmd>Telescope live_grep<cr>", desc = keys.search.live_grep.desc },
      { keys.search.live_grep_open.key, function() require("telescope.builtin").grep_string({ grep_open_files = true }) end, desc = keys.search.live_grep_open.desc },
      { keys.search.help.key, "<cmd>Telescope help_tags<cr>", desc = keys.search.help.desc },
      { keys.search.highlights.key, "<cmd>Telescope highlights<cr>", desc = keys.search.highlights.desc },
      { keys.search.keymaps.key, "<cmd>Telescope keymaps<cr>", desc = keys.search.keymaps.desc },
      { keys.search.jumplist.key, "<cmd>Telescope jumplist<cr>", desc = keys.search.jumplist.desc },
      { keys.search.man_pages.key, "<cmd>Telescope man_pages<cr>", desc = keys.search.man_pages.desc },
      { keys.search.marks.key, "<cmd>Telescope marks<cr>", desc = keys.search.marks.desc },
      { keys.search.options.key, "<cmd>Telescope vim_options<cr>", desc = keys.search.options.desc },
      { keys.search.quickfix.key, "<cmd>Telescope quickfix<cr>", desc = keys.search.quickfix.desc },
      { keys.search.quickfix_history.key, "<cmd>Telescope quickfixhistory<cr>", desc = keys.search.quickfix_history.desc },
      { keys.search.resume.key, "<cmd>Telescope resume<cr>", desc = keys.search.resume.desc },

      { keys.search.grep_string.key, "<cmd>Telescope grep_string<cr>", desc = keys.search.grep_string.desc },
      { keys.search.word_root.key, function() require("telescope.builtin").grep_string({ word_match = "-w" }) end, desc = keys.search.word_root.desc },
      { keys.search.word_cwd.key, function() require("telescope.builtin").grep_string({ cwd = false, word_match = "-w" }) end, desc = keys.search.word_cwd.desc },
      { keys.search.word_root.key, function() require("telescope.builtin").grep_string({ word_match = "-w" }) end, desc = keys.search.word_root.desc, mode = "v" },
      { keys.search.word_cwd.key, function() require("telescope.builtin").grep_string({ cwd = false, word_match = "-w" }) end, desc = keys.search.word_cwd.desc, mode = "v" },
      { keys.search.colorscheme.key, function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = keys.search.colorscheme.desc },

      { keys.lsp.doc_symbols.key, "<cmd>Telescope lsp_document_symbols<cr>", desc = keys.lsp.doc_symbols.desc },
      { keys.lsp.ws_symbols.key, "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = keys.lsp.ws_symbols.desc },
      { keys.quit.search_sessions.key, function () require("auto-session.session-lens").search_session() end, desc = keys.quit.search_sessions.desc },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("bibtex")
      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    end
  },

  -- {
  --   "dimaportenko/telescope-toggleterm.nvim",
  --   keys = { { keys.find.terminal.key, "<cmd>Telescope toggleterm<cr>", desc = keys.find.terminal.desc } },
  --   dependencies = {
  --     "akinsho/nvim-toggleterm.lua",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/popup.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("telescope").load_extension("toggleterm")
  --   end
  -- },
 
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    keys = { { keys.find.terminal.key, "<cmd>Telescope toggleterm_manager<cr>", desc = keys.find.terminal.desc } },
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
    },
    opts = {
      mappings = {
        i = {
          ["<CR>"] = { exit_on_action = true },
        }
      },
    },
  }
}

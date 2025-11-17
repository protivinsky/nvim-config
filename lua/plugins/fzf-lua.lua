local keys = require("user.keys")

-- Helper function to find git root (from telescope.lua)
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()

  if current_file == '' then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

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
    require('fzf-lua').live_grep({
      cwd = git_root,
    })
  end
end

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- Optional: for window picking (like your telescope setup)
    "s1n7ax/nvim-window-picker",
  },
  cmd = "FzfLua",
  keys = {
    -- Find
    { keys.find.files.key, "<cmd>FzfLua files<cr>", desc = keys.find.files.desc },
    { keys.find.files.key2, "<cmd>FzfLua files<cr>", desc = keys.find.files.desc },
    { keys.find.files_no_ignore.key, function() require("fzf-lua").files({ file_ignore_patterns = nil, no_ignore = true }) end, desc = keys.find.files_no_ignore.desc },
    { keys.find.config.key, function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = keys.find.config.desc },
    { keys.find.buffers.key, "<cmd>FzfLua buffers<cr>", desc = keys.find.buffers.desc },
    { keys.find.buffers.key2, "<cmd>FzfLua buffers<cr>", desc = keys.find.buffers.desc },
    { keys.find.oldfiles.key, "<cmd>FzfLua oldfiles<cr>", desc = keys.find.oldfiles.desc },
    { keys.find.oldfiles.key2, "<cmd>FzfLua oldfiles<cr>", desc = keys.find.oldfiles.desc },
    { keys.find.git_files.key, "<cmd>FzfLua git_files<cr>", desc = keys.find.git_files.desc },
    { keys.find.treesitter.key, "<cmd>FzfLua treesitter<cr>", desc = keys.find.treesitter.desc },
    { keys.find.builtin.key, "<cmd>FzfLua builtin<cr>", desc = keys.find.builtin.desc },
    { keys.find.reloader.key, function() require("fzf-lua").files({ prompt = "Reload Module> ", cwd = vim.fn.stdpath("config") .. "/lua" }) end, desc = keys.find.reloader.desc },

    -- Git
    { keys.git.branches.key, "<cmd>FzfLua git_branches<cr>", desc = keys.git.branches.desc },
    { keys.git.commits.key, "<cmd>FzfLua git_commits<cr>", desc = keys.git.commits.desc },
    { keys.git.status.key, "<cmd>FzfLua git_status<cr>", desc = keys.git.status.desc },
    { keys.git.stash.key, "<cmd>FzfLua git_stash<cr>", desc = keys.git.stash.desc },

    -- Search
    { keys.search.buffer.key, "<cmd>FzfLua blines<cr>", desc = keys.search.buffer.desc },
    { keys.search.registers.key, "<cmd>FzfLua registers<cr>", desc = keys.search.registers.desc },
    { keys.search.live_grep_args.key, function() require("fzf-lua").live_grep({ prompt = "Live Grep Args> " }) end, desc = keys.search.live_grep_args.desc },
    { keys.search.autocommands.key, "<cmd>FzfLua autocmds<cr>", desc = keys.search.autocommands.desc },
    { keys.search.command_history.key, "<cmd>FzfLua command_history<cr>", desc = keys.search.command_history.desc },
    { keys.search.command_history.key2, "<cmd>FzfLua command_history<cr>", desc = keys.search.command_history.desc },
    { keys.search.commands.key, "<cmd>FzfLua commands<cr>", desc = keys.search.commands.desc },
    { keys.search.doc_diag.key, "<cmd>FzfLua diagnostics_document<cr>", desc = keys.search.doc_diag.desc },
    { keys.search.ws_diag.key, "<cmd>FzfLua diagnostics_workspace<cr>", desc = keys.search.ws_diag.desc },
    { keys.search.live_grep.key, "<cmd>FzfLua live_grep<cr>", desc = keys.search.live_grep.desc },
    { keys.search.live_grep_open.key, function() require("fzf-lua").grep({ search = "", fzf_opts = { ["--filter"] = "^.*$" } }) end, desc = keys.search.live_grep_open.desc },
    { keys.search.help.key, "<cmd>FzfLua help_tags<cr>", desc = keys.search.help.desc },
    { keys.search.highlights.key, "<cmd>FzfLua highlights<cr>", desc = keys.search.highlights.desc },
    { keys.search.keymaps.key, "<cmd>FzfLua keymaps<cr>", desc = keys.search.keymaps.desc },
    { keys.search.jumplist.key, "<cmd>FzfLua jumps<cr>", desc = keys.search.jumplist.desc },
    { keys.search.man_pages.key, "<cmd>FzfLua man_pages<cr>", desc = keys.search.man_pages.desc },
    { keys.search.marks.key, "<cmd>FzfLua marks<cr>", desc = keys.search.marks.desc },
    { keys.search.options.key, function() require("fzf-lua").files({ prompt = "Options> ", cmd = "echo -e \"" .. table.concat(vim.fn.getcompletion("", "option"), "\\n") .. "\"" }) end, desc = keys.search.options.desc },
    { keys.search.quickfix.key, "<cmd>FzfLua quickfix<cr>", desc = keys.search.quickfix.desc },
    { keys.search.quickfix_history.key, "<cmd>FzfLua quickfix_stack<cr>", desc = keys.search.quickfix_history.desc },
    { keys.search.resume.key, "<cmd>FzfLua resume<cr>", desc = keys.search.resume.desc },

    -- Word search
    { keys.search.grep_string.key, "<cmd>FzfLua grep_cword<cr>", desc = keys.search.grep_string.desc },
    { keys.search.word_root.key, "<cmd>FzfLua grep_cword<cr>", desc = keys.search.word_root.desc },
    { keys.search.word_cwd.key, function() require("fzf-lua").grep_cword({ cwd = vim.fn.getcwd() }) end, desc = keys.search.word_cwd.desc },
    { keys.search.word_root.key, "<cmd>FzfLua grep_visual<cr>", desc = keys.search.word_root.desc, mode = "v" },
    { keys.search.word_cwd.key, function() require("fzf-lua").grep_visual({ cwd = vim.fn.getcwd() }) end, desc = keys.search.word_cwd.desc, mode = "v" },
    { keys.search.colorscheme.key, "<cmd>FzfLua colorschemes<cr>", desc = keys.search.colorscheme.desc },

    -- LSP
    { keys.lsp.doc_symbols.key, "<cmd>FzfLua lsp_document_symbols<cr>", desc = keys.lsp.doc_symbols.desc },
    { keys.lsp.ws_symbols.key, "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = keys.lsp.ws_symbols.desc },

    -- Sessions (if using auto-session with fzf-lua integration)
    { keys.quit.search_sessions.key, function()
      -- This assumes auto-session integration or custom implementation
      require("fzf-lua").files({
        prompt = "Sessions> ",
        cwd = vim.fn.stdpath("data") .. "/sessions"
      })
    end, desc = keys.quit.search_sessions.desc },
  },

  opts = {
    -- Global settings
    winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.35,
      col = 0.50,
      border = "rounded",
      preview = {
        default = "bat",
        border = "border",
        wrap = "nowrap",
        hidden = "nohidden",
        vertical = "down:45%",
        horizontal = "right:50%",
        layout = "flex",
        flip_columns = 120,
        scrollbar = "float",
      },
      on_create = function()
        -- Window picker integration (similar to telescope setup)
        vim.keymap.set("t", "<C-w>", function()
          -- Get the selected entry
          local selected = require("fzf-lua").get_last_query()
          -- Pick window and open there
          local win = require("window-picker").pick_window()
          if win then
            vim.api.nvim_set_current_win(win)
          end
        end, { buffer = true })
      end,
    },

    keymap = {
      builtin = {
        ["<F1>"] = "toggle-help",
        ["<F2>"] = "toggle-fullscreen",
        ["<F3>"] = "toggle-preview-wrap",
        ["<F4>"] = "toggle-preview",
        ["<F5>"] = "toggle-preview-ccw",
        ["<F6>"] = "toggle-preview-cw",
        ["<S-down>"] = "preview-page-down",
        ["<S-up>"] = "preview-page-up",
        ["<S-left>"] = "preview-page-reset",
      },
      fzf = {
        ["ctrl-z"] = "abort",
        ["ctrl-u"] = "unix-line-discard",
        ["ctrl-f"] = "half-page-down",
        ["ctrl-b"] = "half-page-up",
        ["ctrl-a"] = "beginning-of-line",
        ["ctrl-e"] = "end-of-line",
        ["alt-a"] = "toggle-all",
        ["ctrl-q"] = "select-all+accept",
      },
    },

    -- File operations
    files = {
      prompt = "Files❯ ",
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
      find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
      rg_opts = "--color=never --files --hidden --follow -g '!.git'",
      fd_opts = "--color=never --type f --hidden --follow --exclude .git",
    },

    -- Grep operations
    grep = {
      prompt = "Rg❯ ",
      input_prompt = "Grep For❯ ",
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      rg_glob = false,
      glob_flag = "--iglob",
      glob_separator = "%s%-%-",
    },

    -- Git
    git = {
      files = {
        prompt = "GitFiles❯ ",
        cmd = "git ls-files --exclude-standard",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
      },
      status = {
        prompt = "GitStatus❯ ",
        cmd = "git -c color.status=false status -su",
        previewer = "git_diff",
        file_icons = true,
        git_icons = true,
        color_icons = true,
      },
      commits = {
        prompt = "Commits❯ ",
        cmd = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
        preview = "git show --color {1}",
        actions = {
          ["default"] = function(selected)
            -- Yank commit hash
            vim.fn.setreg('+', selected[1]:match('[^ ]+'))
          end,
        },
      },
      branches = {
        prompt = "Branches❯ ",
        cmd = "git branch --all --color",
        preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
        actions = {
          ["default"] = function(selected)
            local branch = selected[1]:match('[^%s]+$')
            vim.cmd("Git checkout " .. branch)
          end,
        },
      },
    },

    -- LSP
    lsp = {
      prompt_postfix = "❯ ",
      cwd_only = false,
      async_or_timeout = 5000,
      file_icons = true,
      git_icons = false,
      lsp_icons = true,
      severity = "hint",
      icons = {
        ["Error"] = { icon = "", color = "red" },
        ["Warning"] = { icon = "", color = "yellow" },
        ["Information"] = { icon = "", color = "blue" },
        ["Hint"] = { icon = "", color = "cyan" },
      },
    },

    -- Diagnostics
    diagnostics = {
      prompt = "Diagnostics❯ ",
      cwd_only = false,
      file_icons = true,
      git_icons = false,
      diag_icons = true,
      icon_padding = "",
      multiline = true,
      severity_only = false,
      severity_sort = { reverse = true },
    },

    -- Buffers
    buffers = {
      prompt = "Buffers❯ ",
      file_icons = true,
      color_icons = true,
      sort_lastused = true,
      actions = {
        ["default"] = function(selected)
          vim.cmd("buffer " .. selected[1]:match("^%[(%d+)"))
        end,
        ["ctrl-x"] = function(selected)
          local bufnr = selected[1]:match("^%[(%d+)")
          vim.cmd("bdelete " .. bufnr)
        end,
      },
    },

    -- Oldfiles
    oldfiles = {
      prompt = "History❯ ",
      cwd_only = false,
      stat_file = true,
      include_current_session = false,
    },

    -- Keymaps
    keymaps = {
      prompt = "Keymaps❯ ",
    },

    -- Registers
    registers = {
      prompt = "Registers❯ ",
    },

    -- Marks
    marks = {
      prompt = "Marks❯ ",
    },

    -- Tags
    tags = {
      prompt = "Tags❯ ",
      ctags_file = "tags",
      multiprocess = true,
    },

    -- Lines (current buffer)
    blines = {
      prompt = "BLines❯ ",
      show_unlisted = true,
      no_term_buffers = true,
      fzf_opts = {
        ["--delimiter"] = "'[\\]:]'",
        ["--with-nth"] = "2..",
        ["--tiebreak"] = "index",
      },
    },

    -- Lines (all buffers)
    lines = {
      prompt = "Lines❯ ",
      show_unlisted = true,
      no_term_buffers = true,
      fzf_opts = {
        ["--delimiter"] = "'[\\]:]'",
        ["--nth"] = "2..",
        ["--tiebreak"] = "index",
      },
    },
  },

  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)

    -- Register bat as preview command if available
    if vim.fn.executable("bat") == 1 then
      fzf.setup({
        winopts = {
          preview = {
            default = "bat",
          }
        }
      })
    end

    -- Create custom command for git root search
    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
  end,
}

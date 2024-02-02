M = {}

-- which-key groups
M.which = {}
M.which.buffer = { key = "<leader>b", desc = 'buffers' }
M.which.code = { key = "<leader>c", desc = 'code' }
M.which.diffdebug = { key = "<leader>d", desc = 'diff / debug' }
M.which.find = { key = "<leader>f", desc = "find" }
M.which.git = { key = "<leader>g", desc = "git" }
M.which.hunks = { key = "<leader>h", desc = "git / hunks" }
M.which.lsp = { key = "<leader>l", desc = "lsp" }
M.which.quitsess = { key = "<leader>q", desc = "quit / sessions" }
M.which.search = { key = "<leader>s", desc = "search" }
M.which.test = { key = "<leader>t", desc = "test" }
M.which.ui = { key = "<leader>u", desc = "ui" }
M.which.window = { key = "<leader>w", desc = "windows" }
M.which.trouble = { key = "<leader>x", desc = "trouble" }
M.which.tab = { key = "<leader><tab>", desc = "tabs" }


M.buffer = {}
M.buffer.delete = { key = "<leader>bd", desc = "Delete buffer" }
M.buffer.force_delete = { key = "<leader>bD", desc = "Force delete" }
M.buffer.toggle_pin = { key = "<leader>bp", desc = "Toggle pin" }
M.buffer.delete_non_pinned = { key = "<leader>bP", desc = "Delete non-pinned" }
M.buffer.close_others = { key = "<leader>bo", desc = "Delete others" }
M.buffer.close_right = { key = "<leader>br", desc = "Delete to the right" }
M.buffer.close_left = { key = "<leader>bl", desc = "Delete to the left" }
-- M.buffer.switch = { key = "<leader>bb", key2 = "<leader>`", desc = "Switch to other buffer" }
M.buffer.switch = { key = "<leader>,", desc = "Switch to other buffer" }


M.code = {}
-- aerial
M.code.aerial_toggle = { key = "<leader>ca", desc = "Aerial (symbols)" }
-- spectre
M.code.replace_spectre = { key = "<leader>sr", desc = "Replace in files (Spectre)" }
-- venv-selector
M.code.venv_select = { key = "<leader>cv", desc = "Select virtual env" }
M.code.venv_cached = { key = "<leader>cV", desc = "Select cached env" }
M.code.venv_info = { key = "<leader>cI", desc = "Current virtual env" }

M.diff = {}
M.diff.this = { key = "<leader>dt", desc = "Diff this" }
M.diff.off = { key = "<leader>dT", desc = "Diff off" }
M.diff.get = { key = "<leader>dg", desc = "Diff get" }
M.diff.put = { key = "<leader>dp", desc = "Diff put" }
M.debug = {}
M.debug.toggle_breakpoint = { key = "<leader>db", desc = "Debug: Toggle breakpoint" }
M.debug.set_breakpoint = { key = "<leader>dB", desc = "Debug: Set breakpoint" }
M.debug.start = { key = "<leader>dd",  desc = "Debug: Start/continue" }
M.debug.step_into = { key = "<leader>di", desc = "Debug: Step into" }
M.debug.step_out = { key = "<leader>do", desc = "Debug: Step out" }
M.debug.step_over = { key = "<leader>dv", desc = "Debug: Step over" }
M.debug.toggle_ui = { key = "<leader>du", desc = "Debug: Toggle UI" }
M.debug.test_method = { key = "<leader>dm", desc = "Debug: Test method" }
M.debug.test_class = { key = "<leader>dc", desc = "Debug: Test class" }

M.git = {}
M.git.branches = { key = "<leader>gb", desc = "git branches" }
M.git.blame = { key = "<leader>gB", desc = "git blame" }
M.git.commits = { key = "<leader>gc", desc = "git commits" }
M.git.status = { key = "<leader>gs", desc = "git status" }
M.git.stash = { key = "<leader>gS", desc = "git stash" }
M.git.fugitive = { key = "<leader>gg", desc = "git fugitive" }
M.git.lazygit = { key = "<leader>gl", desc = "lazygit" }

M.git.stage_hunk = { key = "<leader>hs", desc = "git stage hunk" }
M.git.reset_hunk = { key = "<leader>hr", desc = "git reset hunk" }
M.git.stage_buffer = { key = "<leader>hS", desc = "git stage buffer" }
M.git.reset_buffer = { key = "<leader>hR", desc = "git reset buffer" }
M.git.undo_stage_hunk = { key = "<leader>hu", desc = "undo stage hunk" }
M.git.preview_hunk = { key = "<leader>hp", desc = "preview git hunk" }
M.git.diff_against_index = { key = "<leader>hd", desc = "git diff against index" }
M.git.diff_against_last_commit = { key = "<leader>hD", desc = "git diff against last commit" }
M.git.blame_line = { key = "<leader>hb", desc = "toggle git blame line" }
M.git.toggle_blame_line = { key = "<leader>ht", desc = "toggle git blame line" }
M.git.toggle_deleted = { key = "<leader>hx", desc = "toggle git show deleted" }
M.git.select_hunk = { key = "ih", desc = "select git hunk" }

M.lsp = {}
M.lsp.definition = { key = "gd", desc = "Definition" }
M.lsp.references = { key = "gr", desc = "References" }
M.lsp.implementation = { key = "gI", desc = "Implementation" }
M.lsp.hover = { key = "gh", desc = "Hover documentation" }
M.lsp.declaration = { key = "gD", desc = "Declaration" }
M.lsp.type_def = { key = "<leader>D", desc = "Type definition" }
-- alternatively <leader>ss, <leader>sS ? or <leader>ds, <leader>ws ?
M.lsp.doc_symbols = { key = "<leader>ld", desc = "Document symbols" }
M.lsp.ws_symbols = { key = "<leader>lw", desc = "Workspace symbols" }
M.lsp.ws_add_folder = { key = "<leader>wa", desc = "Workspace add folder" }
M.lsp.ws_remove_folder = { key = "<leader>wr", desc = "Workspace remove folder" }
M.lsp.ws_list_folders = { key = "<leader>wl", desc = "Workspace list folders" }
M.lsp.line_diag = { key = "<leader>ll", desc = "Line diagnostic" }
M.lsp.format = { key = "<leader>lf", desc = "Format buffer" }
M.lsp.info = { key = "<leader>li", desc = "LspInfo" }
M.lsp.code_action = { key = "<leader>la", desc = "Code action" }
M.lsp.next_diag = { key = "<leader>lj", desc = "Next diagnostic" }
M.lsp.prev_diag = { key = "<leader>lk", desc = "Prev diagnostic" }
M.lsp.rename = { key = "<leader>lr", desc = "Rename" }
M.lsp.sig_help = { key = "<leader>ls", desc = "Signature help" }
M.lsp.diag_list = { key = "<leader>lq", desc = "Diagnostic list" }

M.ui = {}
M.ui.show_pos = { key = "<leader>ui", desc = "Inspect position" }

M.diag = {}
M.diag.line = { key = "<leader>cd", desc = "Line diagnostics" }

M.quit = {}
M.quit.all = { key = "<leader>qq", desc = "Quit all" }
M.quit.window = { key = "<leader>qw", desc = "Quit window" }
M.quit.search_sessions = { key = "<leader>qs", desc = "Search sessions" }
-- M.quit.restore_last_session = { key = "<leader>ql", desc = "Restore last session" }
-- M.quit.not_store = { key = "<leader>qd", desc = "Don't save current session" }

M.explore = {}
M.explore.files = { key = "<leader>e", desc = "Explore files" }
M.explore.git = { key = "<leader>ge", desc = "Explore git" }
M.explore.buffers = { key = "<leader>be", desc = "Explore buffers" }

-- neotest
M.test = {}
M.test.run_file = { key = "<leader>tt", desc = "Run file" }
M.test.run_all_files = { key = "<leader>tT", desc = "Run all files" }
M.test.run_nearest = { key = "<leader>tr", desc = "Run nearest" }
M.test.toggle_summary = { key = "<leader>ts", desc = "Toggle summary" }
M.test.show_output = { key = "<leader>to", desc = "Show output" }
M.test.toggle_output_panel = { key = "<leader>tO", desc = "Toggle output panel" }
M.test.stop = { key = "<leader>tS", desc = "Stop" }
M.test.debug_nearest = { key = "<leader>td", desc = "Debug nearest" }
M.test.attach_nearest = { key = "<leader>tA", desc = "Attach nearest" }

-- overseer ... should I have a group for it?
M.task = {}
M.task.run = { key = "<leader>ta", desc = "Run task" }

-- toggleterm
M.term = {}
M.term.open_horizontal = { key = "<leader>cs", desc = "Open horizontal terminal" }
M.term.open_vertical = { key = "<leader>ct", desc = "Open vertical terminal" }
M.term.open_python = { key = "<leader>cp", desc = "Open python terminal" }
M.term.open_ipython = { key = "<leader>ci", desc = "Open ipython terminal" }
M.term.run_in_python = { key = "<leader>cP", desc = "Save and run in python" }
M.term.send_line = { key = "<leader>r", key2 = "<A-r>", desc = "Send line to terminal" }
M.term.send_selection = { key = "<leader>r", key2 = "<A-r>", desc = "Send selection to terminal" }

-- telescope
M.find = {}
M.find.buffers = { key = "<leader>bb", key2 = "<leader>fb", desc = "Buffers" }
M.find.oldfiles = { key = "<leader>?", key2 = "<leader>fr", desc = "Recently opened files" }
M.find.files = { key = "<leader><space>", key2 = "<leader>ff", desc = "Find files" }
M.find.config = { key = "<leader>fc", desc = "Find config files" }
M.find.git_files = { key = "<leader>fg", desc = "Find git files" }
M.find.jumplist = { key = "<leader>fj", desc = "Jumplist" }
M.find.treesitter = { key = "<leader>fT", desc = "Treesitter" }
M.find.builtin = { key = "<leader>fB", desc = "Built-in pickers" }
M.find.reloader = { key = "<leader>fR", desc = "Reload lua module" }
M.find.planets = { key = "<leader>fP", desc = "Planets" }

M.new_file = { key = "<leader>fn", desc = "New file" }

M.search = {}
M.search.buffer = { key = "<leader>/", key2 = "<leader>sb", desc = "Search buffer" }
M.search.registers = { key = "<leader>s\"", desc = "Registers" }
M.search.autocommands = { key = "<leader>sa", desc = "Autocommands" }
M.search.command_history = { key = "<leader>:", key2 = "<leader>sc", desc = "Command history" }
M.search.commands = { key = "<leader>sC", desc = "Commands" }
M.search.doc_diag = { key = "<leader>sd", desc = "Document diagnostics" }
M.search.ws_diag = { key = "<leader>sD", desc = "Workspace diagnostics" }
M.search.live_grep = { key = "<leader>sg", desc = "Live grep" }
M.search.live_grep_open = { key = "<leader>sG", desc = "Live grep in open files" }
M.search.help = { key = "<leader>sh", desc = "Help pages" }
M.search.highlights = { key = "<leader>sH", desc = "Search highlight groups" }
M.search.keymaps = { key = "<leader>sk", desc = "Key maps" }
M.search.man_pages = { key = "<leader>sM", desc = "Man pages" }
M.search.marks = { key = "<leader>sm", desc = "Jump to mark" }
M.search.options = { key = "<leader>sO", desc = "Options" }
M.search.resume = { key = "<leader>sR", desc = "Resume" }
M.search.word_root = { key = "<leader>sw", desc = "Word (root dir)" }
M.search.grep_string = { key = "<leader>ss", desc = "Grep string" }
M.search.word_cwd = { key = "<leader>sW", desc = "Word (cwd)" }
M.search.colorscheme = { key = "<leader>uC", desc = "Colorscheme with preview" }
M.search.todo = { key = "<leader>st", desc = "Todo" }
M.search.todo_fix_fixme = { key = "<leader>sT", desc = "Todo / fix / fixme" }

M.trouble = {}
M.trouble.doc_diag = { key = "<leader>xx", desc = "Document diagnostics (Trouble)" }
M.trouble.ws_diag = { key = "<leader>xX", desc = "Workspace diagnostics (Trouble)" }
M.trouble.loclist = { key = "<leader>xL", desc = "Location list (Trouble)" }
M.trouble.quickfix = { key = "<leader>xQ", desc = "Quickfix list (Trouble)" }
M.trouble.todo = { key = "<leader>xt", desc = "Todo (Trouble)" }
M.trouble.todo_fix_fixme = { key = "<leader>xT", desc = "Todo / fix / fixme (Trouble)" }

M.location_list = { key = "<leader>xl", desc = "Location list" }
M.quickfix_list = { key = "<leader>xq", desc = "Quickfix list" }

-- next
M.loc = {}
M.buffer.prev = { key = "[b", key2 = "<S-h>", desc = "Prev buffer" }
M.buffer.next = { key = "]b", key2 = "<S-l>", desc = "Next buffer" }
M.diag.next_diag = { key = "]d", desc = "Next diagnostic" }
M.diag.prev_diag = { key = "[d", desc = "Prev diagnostic" }
M.diag.next_error = { key = "]e", desc = "Next error" }
M.diag.prev_error = { key = "[e", desc = "Prev error" }
M.diag.next_warning = { key = "]w", desc = "Next warning" }
M.diag.prev_warning = { key = "[w", desc = "Prev warning" }
-- M.quickfix_prev = { key = "[q", desc = "Previous quickfix" }
-- M.quickfix_next = { key = "]q", desc = "Next quickfix" }
M.trouble.prev = { key = "[q", desc = "Previous trouble/quickfix" }
M.trouble.next = { key = "]q", desc = "Next trouble/quickfix" }
M.jumplist_prev = { key = "[j", desc = "Previous jumplist" }
M.jumplist_next = { key = "]j", desc = "Next jumplist" }
M.loc.next_todo = { key = "]t", desc = "Next todo comment" }
M.loc.prev_todo = { key = "[t", desc = "Previous todo comment" }
-- the following are default mappings in diff mode, gitsigns extends them
M.loc.next_hunk = { key = "]c", desc = "Next diff/hunk" }
M.loc.prev_hunk = { key = "[c", desc = "Prev diff/hunk" }
-- treesitter
M.code.next_function_start = { key = "]f" }
M.code.next_function_end = { key = "]F" }
M.code.prev_function_start = { key = "[f" }
M.code.prev_function_end = { key = "[F" }
M.code.next_class_start = { key = "]k" }
M.code.next_class_end = { key = "]K" }
M.code.prev_class_start = { key = "[k" }
M.code.prev_class_end = { key = "[K" }



return M

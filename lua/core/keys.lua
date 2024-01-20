M = {}

M.buffer = {}
M.buffer.toggle_pin = { key = "<leader>bp", desc = "Toggle pin" }
M.buffer.delete_non_pinned = { key = "<leader>bP", desc = "Delete non-pinned" }
M.buffer.close_others = { key = "<leader>bo", desc = "Delete others" }
M.buffer.close_right = { key = "<leader>br", desc = "Delete to the right" }
M.buffer.close_left = { key = "<leader>bl", desc = "Delete to the left" }
M.buffer.prev = { key = "[b", key2 = "<S-h>", desc = "Prev buffer" }
M.buffer.next = { key = "]b", key2 = "<S-l>", desc = "Next buffer" }
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
M.code.venv_info = { key = "<leader>cV", desc = "Select cached env" }
-- treesitter
M.code.next_function_start = { key = "]f" }
M.code.next_function_end = { key = "]F" }
M.code.prev_function_start = { key = "[f" }
M.code.prev_function_end = { key = "[F" }
M.code.next_class_start = { key = "]c" }
M.code.next_class_end = { key = "]C" }
M.code.prev_class_start = { key = "[c" }
M.code.prev_class_end = { key = "[C" }

M.debug = {}
M.debug.toggle_breakpoint = { key = "<leader>b", key2 = "<leader>db", desc = "Debug: Toggle breakpoint" }
M.debug.set_breakpoint = { key = "<leader>B", key2 = "<leader>dB", desc = "Debug: Set breakpoint" }
M.debug.start = { key = "<leader>dd",  desc = "Debug: Start/continue" }
M.debug.step_into = { key = "<leader>di", desc = "Debug: Step into" }
M.debug.step_out = { key = "<leader>do", desc = "Debug: Step out" }
M.debug.step_over = { key = "<leader>dv", desc = "Debug: Step over" }
M.debug.last_result = { key = "<leader>dl", desc = "Debug: See last result" }
M.debug.test_method = { key = "<leader>dm", desc = "Debug: Test method" }
M.debug.test_class = { key = "<leader>dc", desc = "Debug: Test class" }

M.git = {}
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
M.lsp.doc_symbols = { key = "<leader>ss", desc = "Document symbols" }
M.lsp.ws_symbols = { key = "<leader>sS", desc = "Workspace symbols" }
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

M.new_file = { key = "<leader>fn", desc = "New file" }
M.location_list = { key = "<leader>xl", desc = "Location list" }
M.quickfix_list = { key = "<leader>xq", desc = "Quickfix list" }
M.quickfix_prev = { key = "[q", desc = "Previous quickfix" }
M.quickfix_next = { key = "]q", desc = "Next quickfix" }
M.jumplist_prev = { key = "[j", desc = "Previous jumplist" }
M.jumplist_next = { key = "]j", desc = "Next jumplist" }

M.diag = {}
M.diag.line = { key = "<leader>cd", desc = "Line diagnostics" }
M.diag.next_diag = { key = "]d", desc = "Next diagnostic" }
M.diag.prev_diag = { key = "[d", desc = "Prev diagnostic" }
M.diag.next_error = { key = "]e", desc = "Next error" }
M.diag.prev_error = { key = "[e", desc = "Prev error" }
M.diag.next_warning = { key = "]w", desc = "Next warning" }
M.diag.prev_warning = { key = "[w", desc = "Prev warning" }

M.quit = {}
M.quit.all = { key = "<leader>qq", desc = "Quit all" }
-- persistance
M.quit.restore_session = { key = "<leader>qs", desc = "Restore session" }
M.quit.restore_last_session = { key = "<leader>ql", desc = "Restore last session" }
M.quit.not_store = { key = "<leader>qd", desc = "Don't save current session" }

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

-- toggleterm
M.term = {}
M.term.open_horizontal = { key = "<leader>cs", desc = "Open horizontal terminal" }
M.term.open_vertical = { key = "<leader>ct", desc = "Open vertical terminal" }
M.term.open_python = { key = "<leader>cp", desc = "Open python terminal" }
M.term.open_ipython = { key = "<leader>ci", desc = "Open ipython terminal" }
M.term.run_in_python = { key = "<leader>cP", desc = "Save and run in python" }
M.term.send_line = { key = "<leader>r", key2 = "<C-r>", desc = "Send line to terminal" }
M.term.send_selection = { key = "<leader>r", key2 = "<C-r>", desc = "Send selection to terminal" }

-- telescope
M.find = {}
M.find.buffers = { key = "<leader>bb", key2 = "<leader>fb", desc = "Buffers" }
M.find.oldfiles = { key = "<leader>?", key2 = "<leader>fr", desc = "Recently opened files" }
M.find.files = { key = "<leader><space>", key2 = "<leader>ff", desc = "Find files" }
M.find.config = { key = "<leader>fc", desc = "Find config files" }
M.find.git_files = { key = "<leader>fg", desc = "Find git files" }
M.find.jumplist = { key = "<leader>fj", desc = "Jumplist" }

M.search = {}
M.search.buffer = { key = "<leader>/", key2 = "<leader>sb", desc = "Search buffer" }
M.search.registers = { key = "<leader>s\"", desc = "Registers" }
M.search.autocommands = { key = "<leader>sa", desc = "Autocommands" }
M.search.command_history = { key = "<leader>:", key2 = "<leader>sc", desc = "Command history" }
M.search.commands = { key = "<leader>sC", desc = "Commands" }
M.search.doc_diag = { key = "<leader>sd", desc = "Document diagnostics" }
M.search.ws_diag = { key = "<leader>sD", desc = "Workspace diagnostics" }
M.search.live_grep = { key = "<leader>sg", desc = "Live grep" }
M.search.help = { key = "<leader>sh", desc = "Help pages" }
M.search.highlights = { key = "<leader>sH", desc = "Search highlight groups" }
M.search.keymaps = { key = "<leader>sk", desc = "Key maps" }
M.search.man_pages = { key = "<leader>sM", desc = "Man pages" }
M.search.marks = { key = "<leader>sm", desc = "Jump to mark" }
M.search.options = { key = "<leader>sO", desc = "Options" }
M.search.resume = { key = "<leader>sR", desc = "Resume" }
M.search.word_root = { key = "<leader>sw", desc = "Word (root dir)" }
M.search.word_cwd = { key = "<leader>sW", desc = "Word (cwd)" }
M.search.colorscheme = { key = "<leader>uC", desc = "Colorscheme with preview" }


return M

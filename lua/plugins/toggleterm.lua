local keys = require("user.keys")

-- TODO: Figure out how to do this better, ideally on venv selector plugin
-- Also, I might want to provide some user commands for lazygit, btop etc
-- see https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/toggleterm.lua
--
-- local python_cmd = "python"
-- local ipython_cmd = "ipython --TerminalInteractiveShell.autoindent=False"
-- local python_cmd = "${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python"
-- local ipython_cmd = "${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}ipython --TerminalInteractiveShell.autoindent=False"

local python_path = function() return require("venv-selector").python() or "python" end
local python_or_ipython = "python"
-- local python_repl = nil
-- local python_shell = nil

local julia_path = function()
  local function file_exists(path)
    local file = io.open(path, "r")
    if file then
      io.close(file)
      return true
    else
      return false
    end
  end
  if file_exists("Project.toml") or file_exists("JuliaProject.toml") then
    return "julia --project"
  else
    return "julia"
  end
end

local function fix_lines_for_python(lines)
  -- remove whitespaces at the beginning of the whole block
  -- remove empty lines
  local lines2 = {}
  local first_offset = nil

  for _, line in ipairs(lines) do
    if not string.match(line, "^%s*$") then
      if first_offset == nil then
        first_offset = #(string.match(line, "^ *"))
      end
      local norm_line = string.gsub(line, " ", "", first_offset)
      table.insert(lines2, norm_line)
    end
  end
  table.insert(lines2, "")

  if python_or_ipython == "ipython" then
    return lines2
  end

  -- insert empty lines to make python REPL happy
  local current_offset = 0
  local next_offset = nil
  local lines3 = {}

  for i, line in ipairs(lines2) do
    table.insert(lines3, line)
    if i < #lines2 then
      next_offset = #(string.match(lines2[i + 1], "^ *"))
      if next_offset < current_offset then
        table.insert(lines3, string.rep(" ", next_offset))
      end
      current_offset = next_offset
    end
  end

  return lines3
end

local function show_dataframe(selection_type, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(vim.api.nvim_win_get_cursor(0))
    table.insert(lines, vim.fn.getline(start_line))
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = utils.get_visual_selection(res)
  end

  if not lines or not next(lines) or #lines ~= 1 then
    return
  end

  local line = lines[1]
  -- toggleterm.exec("import pandas as pd", id)
  toggleterm.exec(line .. ".to_csv('~/tmp/df.csv')", id)
  toggleterm.exec("", id)

  local Terminal = require("toggleterm.terminal").Terminal
  local vd_term = Terminal:new({ cmd = "vd ~/tmp/df.csv", close_on_exit = true })
  vd_term:toggle()
end

local function test_catch2(selection_type, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(vim.api.nvim_win_get_cursor(0))
    table.insert(lines, vim.fn.getline(start_line))
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = utils.get_visual_selection(res)
  end

  if not lines or not next(lines) or #lines ~= 1 then
    return
  end

  local line = lines[1]
  -- Pattern to match the first quoted string
  local test_name = line:match('"%s*(.-)%s*"')
  local cmd = "build/test/unit_tests \"" .. test_name .. "\""
  -- toggleterm.exec("import pandas as pd", id)

  local Terminal = require("toggleterm.terminal").Terminal
  local vd_term = Terminal:new({ cmd = cmd, close_on_exit = false })
  vd_term:toggle()
end

local function custom_send_lines_to_terminal(selection_type, trim_spaces, cmd_data)
  -- TODO: There is likely a bug - with regular python, it might require empty lines after decrease
  -- in indentation... Though everything is fine in ipython.
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1
  trim_spaces = trim_spaces == nil or trim_spaces

  vim.validate({
    selection_type = { selection_type, "string", true },
    trim_spaces = { trim_spaces, "boolean", true },
    terminal_id = { id, "number", true },
  })

  local current_window = vim.api.nvim_get_current_win() -- save current window

  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(vim.api.nvim_win_get_cursor(0))
    table.insert(lines, vim.fn.getline(start_line))
  elseif selection_type == "visual_lines" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = res.selected_lines
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = utils.get_visual_selection(res)
  end

  if not lines or not next(lines) then
    return
  end

  if trim_spaces then
    for _, line in ipairs(lines) do
      local l = line:gsub("^%s+", ""):gsub("%s+$", "")
      toggleterm.exec(l, id)
    end
  else
    local fixed_lines = fix_lines_for_python(lines)
    for _, l in ipairs(fixed_lines) do
      toggleterm.exec(l, id)
    end
  end
  -- toggleterm.exec("", id)

  -- Jump back with the cursor where we were at the beginning of the selection
  vim.api.nvim_set_current_win(current_window)
  vim.api.nvim_win_set_cursor(current_window, { start_line, start_col })
end

local function last_terminal_id()
  local is_open, term_wins = require("toggleterm.ui").find_open_windows()
  if is_open then return term_wins[1].term_id end
  local toggled_id = require("toggleterm.terminal").get_toggled_id()
  if toggled_id then return toggled_id end
  local last_focused = require("toggleterm.terminal").get_last_focused()
  return last_focused and last_focused.id or 1
end

-- -- operator implementation: supports motions (e.g. <leader>tip, <leader>t2j, <leader>tat)
_G.ToggleTermOperator = function(motion)
  -- motion is the string Vim passes: "char", "line", or "block"
  local id = last_terminal_id()

  -- Get operator marks set by the motion
  local s_pos = vim.fn.getpos("'[")
  local e_pos = vim.fn.getpos("']")
  local start_line, start_col = s_pos[2], s_pos[3]
  local end_line, end_col = e_pos[2], e_pos[3]

  if not start_line or not end_line then return end

  -- Ensure start <= end
  if end_line < start_line or (end_line == start_line and end_col < start_col) then
    start_line, end_line, start_col, end_col = end_line, start_line, end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if not lines or vim.tbl_isempty(lines) then return end

  -- Adjust for characterwise motions: slice first and last lines
  if motion == "char" then
    if start_line == end_line then
      local l = lines[1] or ""
      lines = { string.sub(l, start_col, end_col) }
    else
      local first = lines[1] or ""
      local last  = lines[#lines] or ""
      lines[1] = string.sub(first, start_col)   -- from start_col to end
      lines[#lines] = string.sub(last, 1, end_col) -- beginning to end_col
    end
  elseif motion == "block" then
    -- blockwise selections are rectangular; handling them properly is more involved.
    -- For now treat them as charwise (or you can notify the user).
    -- vim.notify("Blockwise operator not fully supported; falling back to charwise", vim.log.levels.INFO)
  end

  -- Determine trim_spaces based on line count: single line = trim, multiple lines = preserve indentation
  local trim_spaces = #lines == 1

  -- Send lines to terminal
  if trim_spaces then
    for _, line in ipairs(lines) do
      local l = line:gsub("^%s+", ""):gsub("%s+$", "")
      require("toggleterm").exec(l, id)
    end
  else
    local fixed = fix_lines_for_python(lines)
    for _, l in ipairs(fixed) do
      require("toggleterm").exec(l, id)
    end
  end

  -- Restore cursor to the start of the motion
  local cur_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_cursor(cur_win, { start_line, start_col })
end

local function execute_manim(selection_type, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local start_line, start_col
  local lines

  if selection_type == "single_line" then
    start_line, start_col = unpack(vim.api.nvim_win_get_cursor(0))
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = utils.get_visual_selection(res)
  end

  -- Visual mode behavior: copy selection to clipboard and send checkpoint_paste()
  if selection_type == "visual_selection" then
    if not lines or not next(lines) then
      return
    end
    -- copy to system clipboard
    vim.fn.setreg("+", table.concat(lines, "\n"))
    toggleterm.exec("checkpoint_paste()", id)
    return
  end

  -- Normal mode behavior: send manimgl <relpath> <ClassName> -se <line>
  vim.cmd("write") -- ensure file is saved
  local relpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if relpath == "" or relpath == nil then
    vim.notify("Cannot determine file path for manim command", vim.log.levels.WARN)
    return
  end

  -- find nearest class above the cursor
  local class_name
  for i = start_line, 1, -1 do
    local l = vim.fn.getline(i)
    local m = l:match("^%s*class%s+([%w_]+)")
    if m then
      class_name = m
      break
    end
  end

  if not class_name then
    vim.notify("No Python class found above the cursor", vim.log.levels.WARN)
    return
  end

  local cmd = string.format("manimgl %s %s -se %d", vim.fn.shellescape(relpath), class_name, start_line)
  toggleterm.exec(cmd, id)
end


return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      shade_filetypes = {},
      direction = "float",
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
      },
      winbar = { enabled = true },
      close_on_exit = false,
    },
    keys = {
      -- open terminal
      -- { keys.term.open_vertical.key, "<cmd>ToggleTerm direction=vertical size=120<cr>", desc = keys.term.open_vertical.desc },
      -- { keys.term.open_horizontal.key, "<cmd>ToggleTerm direction=horizontal size=40<cr>", desc = keys.term.open_horizontal.desc },
      {
        keys.term.new_vertical.key,
        function()
          require("toggleterm.terminal").Terminal:new({ direction = "vertical" }):toggle(120)
        end,
        desc = keys.term.new_vertical.desc
      },
      {
        keys.term.new_horizontal.key,
        function()
          require("toggleterm.terminal").Terminal:new({ direction = "horizontal" }):toggle(20)
        end,
        desc = keys.term.new_horizontal.desc
      },
      {
        keys.term.new_float.key,
        function()
          require("toggleterm.terminal").Terminal:new({ direction = "float" }):toggle()
        end,
        desc = keys.term.new_float.desc
      },

      -- open python terminal
      {
        keys.term.start_python.key,
        function()
          python_or_ipython = "python"
          require("toggleterm").exec_command("cmd='" .. python_path() .. "'", last_terminal_id())
        end,
        desc = keys.term.start_python.desc
      },
      {
        keys.term.start_ipython.key,
        function()
          python_or_ipython = "ipython"
          require("toggleterm").exec_command(
            "cmd='" ..
            python_path() ..
            " -m IPython --TerminalInteractiveShell.autoindent=False --TerminalInteractiveShell.confirm_exit=False'",
            last_terminal_id()
          )
        end,
        desc = keys.term.start_ipython.desc
      },
      {
        keys.term.run_in_python.key,
        function()
          vim.cmd("write")
          require("toggleterm").exec_command("cmd='" .. python_path() .. " %'", last_terminal_id())
        end,
        desc = keys.term.run_in_python.desc,
      },
      -- start julia repl
      {
        keys.term.start_julia.key,
        function()
          require("toggleterm").exec_command("cmd='" .. julia_path() .. "'", last_terminal_id())
        end,
        desc = keys.term.start_julia.desc
      },
      {
        keys.term.run_in_julia.key,
        function()
          vim.cmd("write")
          require("toggleterm").exec_command("cmd='" .. julia_path() .. " %'", last_terminal_id())
        end,
        desc = keys.term.run_in_julia.desc,
      },

      -- lazygit
      { keys.git.lazygit.key, "<cmd>TermLazygit<cr>", desc = keys.git.lazygit.desc },

      -- show DataFrame
      {
        keys.code.show_dataframe.key,
        function()
          show_dataframe("single_line", { args = last_terminal_id() })
        end,
        -- "<cmd>showdataframe<cr>",
        desc = keys.code.show_dataframe.desc,
      },
      {
        keys.code.show_dataframe.key,
        function()
          show_dataframe("visual_selection", { args = last_terminal_id() })
        end,
        -- "<cmd>showdataframe<cr>",
        desc = keys.code.show_dataframe.desc,
        mode = "x"
      },

      -- send lines etc to terminal
      {
        keys.term.send_line.key,
        function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = last_terminal_id() })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('j', true, true, true), 'n', false)
        end,
        "<cmd>ToggleTermSendCurrentLine<cr>j",
        desc = keys.term.send_line.desc
      },
      {
        keys.term.send_line.key,
        function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = last_terminal_id() })
        end,
        desc = keys.term.send_line.desc,
        mode = "i"
      },
      {
        keys.term.send_selection.key,
        function()
          custom_send_lines_to_terminal("visual_selection", false, { args = last_terminal_id() })
          vim.cmd("normal! `>")
        end,
        desc = keys.term.send_selection.desc,
        mode = "x"
      },
      {
        keys.term.send_selection.key2,
        function()
          custom_send_lines_to_terminal("visual_selection", false, { args = last_terminal_id() })
          vim.cmd("normal! `>")
        end,
        desc = keys.term.send_selection.desc,
        mode = "x"
      },
      -- Normal mode mapping (calls nearest class + current line)
      {
        keys.code.execute_manim.key,
        function() execute_manim("single_line", { args = last_terminal_id() }) end,
        desc = keys.code.execute_manim.desc,
      },
      -- Visual mode mapping (yank selection to clipboard and send checkpoint_paste())
      {
        keys.code.execute_manim.key,
        function() execute_manim("visual_selection", { args = last_terminal_id() }) end,
        desc = keys.code.execute_manim.desc,
        mode = "x",
      },
      {
        keys.term.send_operator.key,
        function()
          -- set the operatorfunc to our global function, then return g@ to start operator-pending
          vim.go.operatorfunc = "v:lua.ToggleTermOperator"
          return "g@"
        end,
        desc = keys.term.send_operator.desc,
        expr = true,
        silent = true,
      }
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionCustom", function(args)
        custom_send_lines_to_terminal("visual_selection", false, args)
      end, { range = true, nargs = "?" })

      local Terminal = require("toggleterm.terminal").Terminal
      -- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, count = 9 })
      local lazygit = Terminal:new({ cmd = "lazygit", count = 9 })

      vim.api.nvim_create_user_command("TermLazygit", function() lazygit:toggle() end, {})

      vim.api.nvim_create_user_command("ShowDataFrame", function()
        show_dataframe("single_line", { args = last_terminal_id() })
      end, { range = true })

      vim.api.nvim_create_user_command("TestCatch2", function()
        test_catch2("single_line", { args = last_terminal_id() })
      end, { range = true })
    end
  }
}

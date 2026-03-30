local keys = require("user.keys")

local python_path = function() return require("venv-selector").python() or "python" end
local python_or_ipython = "python"

local function julia_path()
  if vim.fn.filereadable("Project.toml") == 1 or vim.fn.filereadable("JuliaProject.toml") == 1 then
    return "julia --project"
  end
  return "julia"
end

local function fix_lines_for_python(lines)
  -- Remove leading whitespace common to the whole block, drop empty lines
  local lines2 = {}
  local first_offset = nil

  for _, line in ipairs(lines) do
    if not string.match(line, "^%s*$") then
      if first_offset == nil then
        first_offset = #(string.match(line, "^ *"))
      end
      table.insert(lines2, line:sub(first_offset + 1))
    end
  end
  table.insert(lines2, "")

  if python_or_ipython == "ipython" then
    return lines2
  end

  -- Insert empty lines at dedent boundaries to make the Python REPL happy
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

-- Track the last terminal we sent code to
_G.ToggleTermLastUsedId = nil

local function track_terminal_used(id)
  _G.ToggleTermLastUsedId = id
  local ok, lualine = pcall(require, "lualine")
  if ok then lualine.refresh({ place = { "winbar" } }) end
end

local function send_lines(lines, id)
  local toggleterm = require("toggleterm")
  if #lines == 1 then
    toggleterm.exec(lines[1]:gsub("^%s+", ""):gsub("%s+$", ""), id)
  else
    for _, l in ipairs(fix_lines_for_python(lines)) do
      toggleterm.exec(l, id)
    end
  end
end

local function show_dataframe(selection_type, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local lines = {}
  if selection_type == "single_line" then
    table.insert(lines, vim.fn.getline(vim.api.nvim_win_get_cursor(0)[1]))
  elseif selection_type == "visual_selection" then
    lines = utils.get_visual_selection(utils.get_line_selection("visual"))
  end

  if not lines or not next(lines) or #lines ~= 1 then
    return
  end

  toggleterm.exec(lines[1] .. ".to_csv('~/tmp/df.csv')", id)
  toggleterm.exec("", id)

  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = "vd ~/tmp/df.csv", close_on_exit = true }):toggle()
end

local function test_catch2(selection_type, cmd_data)
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local lines = {}
  if selection_type == "single_line" then
    table.insert(lines, vim.fn.getline(vim.api.nvim_win_get_cursor(0)[1]))
  elseif selection_type == "visual_selection" then
    lines = utils.get_visual_selection(utils.get_line_selection("visual"))
  end

  if not lines or not next(lines) or #lines ~= 1 then
    return
  end

  local test_name = lines[1]:match('"%s*(.-)%s*"')
  local cmd = "build/test/unit_tests \"" .. test_name .. "\""

  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = cmd, close_on_exit = false }):toggle()
end

local function custom_send_lines_to_terminal(selection_type, trim_spaces, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1
  trim_spaces = trim_spaces == nil or trim_spaces
  track_terminal_used(id)

  local current_window = vim.api.nvim_get_current_win()

  local lines = {}
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
      toggleterm.exec(line:gsub("^%s+", ""):gsub("%s+$", ""), id)
    end
  else
    send_lines(lines, id)
  end

  vim.api.nvim_set_current_win(current_window)
  vim.api.nvim_win_set_cursor(current_window, { start_line, start_col })
end

local function last_terminal_id()
  if _G.ToggleTermLastUsedId then
    local term = require("toggleterm.terminal").get(_G.ToggleTermLastUsedId)
    if term then return _G.ToggleTermLastUsedId end
  end
  local last_focused = require("toggleterm.terminal").get_last_focused()
  if last_focused then return last_focused.id end
  local is_open, term_wins = require("toggleterm.ui").find_open_windows()
  if is_open then return term_wins[1].term_id end
  local toggled_id = require("toggleterm.terminal").get_toggled_id()
  if toggled_id then return toggled_id end
  return 1
end

-- Operator: send motion to active terminal
_G.ToggleTermOperator = function(motion)
  local id = last_terminal_id()
  track_terminal_used(id)

  local s_pos = vim.fn.getpos("'[")
  local e_pos = vim.fn.getpos("']")
  local start_line, start_col = s_pos[2], s_pos[3]
  local end_line, end_col = e_pos[2], e_pos[3]

  if not start_line or not end_line then return end

  if end_line < start_line or (end_line == start_line and end_col < start_col) then
    start_line, end_line, start_col, end_col = end_line, start_line, end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if not lines or vim.tbl_isempty(lines) then return end

  if motion == "char" then
    if start_line == end_line then
      lines = { (lines[1] or ""):sub(start_col, end_col) }
    else
      lines[1] = (lines[1] or ""):sub(start_col)
      lines[#lines] = (lines[#lines] or ""):sub(1, end_col)
    end
  end

  send_lines(lines, id)

  vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_line, start_col })
end

local function execute_manim(selection_type, cmd_data)
  local toggleterm = require("toggleterm")
  local utils = require("toggleterm.utils")
  local id = tonumber(cmd_data.args) or 1

  local start_line
  local lines

  if selection_type == "single_line" then
    start_line = vim.api.nvim_win_get_cursor(0)[1]
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line = res.start_pos[1]
    lines = utils.get_visual_selection(res)
  end

  -- Visual mode: copy selection to clipboard and send checkpoint_paste()
  if selection_type == "visual_selection" then
    if not lines or not next(lines) then
      return
    end
    vim.fn.setreg("+", table.concat(lines, "\n"))

    local first_line = lines[1]
    local comment = first_line:match("^%s*(#.*)$")
    if comment and comment ~= "" then
      toggleterm.exec("checkpoint_paste()  " .. comment .. " (" .. #lines .. " lines)", id)
    else
      toggleterm.exec("checkpoint_paste()", id)
    end
    return
  end

  -- Normal mode: send manimgl <relpath> <ClassName> -se <line>
  vim.cmd("write")
  local relpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if not relpath or relpath == "" then
    vim.notify("Cannot determine file path for manim command", vim.log.levels.WARN)
    return
  end

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
    lazy = false,
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      insert_mappings = false,
      terminal_mappings = false,
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
      {
        keys.term.new_vertical.key,
        function()
          local term = require("toggleterm.terminal").Terminal:new({ direction = "vertical" })
          local width = math.min(120, math.floor(vim.o.columns * 0.4))
          term:toggle(width)
          track_terminal_used(term.id)
        end,
        desc = keys.term.new_vertical.desc
      },
      {
        keys.term.new_horizontal.key,
        function()
          local term = require("toggleterm.terminal").Terminal:new({ direction = "horizontal" })
          term:toggle(20)
          track_terminal_used(term.id)
        end,
        desc = keys.term.new_horizontal.desc
      },
      {
        keys.term.new_float.key,
        function()
          local term = require("toggleterm.terminal").Terminal:new({ direction = "float" })
          term:toggle()
          track_terminal_used(term.id)
        end,
        desc = keys.term.new_float.desc
      },

      -- Start language REPLs
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

      -- Lazygit
      { keys.git.lazygit.key, "<cmd>TermLazygit<cr>", desc = keys.git.lazygit.desc },

      -- Show DataFrame
      {
        keys.code.show_dataframe.key,
        function() show_dataframe("single_line", { args = last_terminal_id() }) end,
        desc = keys.code.show_dataframe.desc,
      },
      {
        keys.code.show_dataframe.key,
        function() show_dataframe("visual_selection", { args = last_terminal_id() }) end,
        desc = keys.code.show_dataframe.desc,
        mode = "x"
      },

      -- Send line to terminal
      {
        keys.term.send_line.key,
        function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = last_terminal_id() })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('j', true, true, true), 'n', false)
        end,
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

      -- Manim
      {
        keys.code.execute_manim.key,
        function() execute_manim("single_line", { args = last_terminal_id() }) end,
        desc = keys.code.execute_manim.desc,
      },
      {
        keys.code.execute_manim.key,
        function() execute_manim("visual_selection", { args = last_terminal_id() }) end,
        desc = keys.code.execute_manim.desc,
        mode = "x",
      },

      -- Operator: <leader>r + motion sends to active terminal
      {
        "<leader>r",
        function()
          vim.go.operatorfunc = "v:lua.ToggleTermOperator"
          return "g@"
        end,
        desc = "Send motion to active terminal",
        expr = true,
        silent = true,
      },
      {
        "<leader>r",
        function()
          custom_send_lines_to_terminal("visual_selection", false, { args = last_terminal_id() })
          vim.cmd("normal! `>")
        end,
        desc = "Send selection to active terminal",
        mode = "x",
      },

      -- <leader>tN: set terminal N as active
      unpack((function()
        local term_keys = {}
        for i = 1, 9 do
          table.insert(term_keys, {
            "<leader>t" .. i,
            function()
              track_terminal_used(i)
              vim.notify("Terminal " .. i .. " is now active", vim.log.levels.INFO)
            end,
            desc = "Set terminal " .. i .. " as active",
          })
        end
        return term_keys
      end)())
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- When a terminal exits, update the active marker after toggleterm cleans up
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "term://*toggleterm#*",
        callback = function(ev)
          local id = vim.b[ev.buf].toggle_number
          if id and id == _G.ToggleTermLastUsedId then
            _G.ToggleTermLastUsedId = nil
            -- Defer so toggleterm removes the terminal from its registry first
            vim.defer_fn(function()
              if _G.ToggleTermLastUsedId == nil then
                local next_id = last_terminal_id()
                if require("toggleterm.terminal").get(next_id) then
                  _G.ToggleTermLastUsedId = next_id
                end
              end
              local ok, lualine = pcall(require, "lualine")
              if ok then lualine.refresh({ place = { "winbar" } }) end
            end, 200)
          end
        end,
      })

      vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionCustom", function(args)
        custom_send_lines_to_terminal("visual_selection", false, args)
      end, { range = true, nargs = "?" })

      local Terminal = require("toggleterm.terminal").Terminal
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

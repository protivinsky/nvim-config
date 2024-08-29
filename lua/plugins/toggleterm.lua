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
      next_offset = #(string.match(lines2[i+1], "^ *"))
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
            "cmd='" .. python_path() .. " -m IPython --TerminalInteractiveShell.autoindent=False --TerminalInteractiveShell.confirm_exit=False'",
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
        keys.term.send_line.key2,
        function()
          require("toggleterm").send_lines_to_terminal("single_line", true, { args = last_terminal_id() })
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('j', true, true, true), 'n', false)
        end,
        desc = keys.term.send_line.desc
      },
      {
        keys.term.send_line.key2,
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


    end
  }
}

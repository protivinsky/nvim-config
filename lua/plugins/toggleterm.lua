local keys = require("user.keys")

-- TODO: Figure out how to do this better, ideally on venv selector plugin
-- Also, I might want to provide some user commands for lazygit, btop etc
-- see https://github.com/LunarVim/Neovim-from-scratch/blob/master/lua/user/toggleterm.lua
--
-- local python_cmd = "python"
local python_cmd = "${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python"
-- local ipython_cmd = "ipython --TerminalInteractiveShell.autoindent=False"
local ipython_cmd = "${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}ipython --TerminalInteractiveShell.autoindent=False"

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
    else
      table.insert(lines3, "")
    end
  end

  return lines3
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
    },
    keys = {
      -- open terminal
      { keys.term.open_vertical.key, "<cmd>ToggleTerm direction=vertical size=120<cr>", desc = keys.term.open_vertical.desc },
      { keys.term.open_horizontal.key, "<cmd>ToggleTerm direction=horizontal size=40<cr>", desc = keys.term.open_horizontal.desc },

      -- open python terminal
      { keys.term.open_python.key, "<cmd>TermExec direction=vertical size=120 cmd='" .. python_cmd .. "'<cr>", desc = keys.term.open_python.desc },
      { keys.term.open_ipython.key, "<cmd>TermExec direction=vertical size=120 cmd='" .. ipython_cmd .. "'<cr>", desc = keys.term.open_ipython.desc },
      {
        keys.term.run_in_python.key,
        "<cmd>w<cr>:9TermExec direction=vertical size=120 cmd='" .. python_cmd .. " %'<cr>",
        desc = keys.term.run_in_python.desc,
      },

      -- lazygit
      { keys.git.lazygit.key, "<cmd>TermLazygit<cr>", desc = keys.git.lazygit.desc },

      -- send lines etc to terminal
      { keys.term.send_line.key, "<cmd>ToggleTermSendCurrentLine<cr>j", desc = keys.term.send_line.desc },
      { keys.term.send_line.key2, "<cmd>ToggleTermSendCurrentLine<cr>j", desc = keys.term.send_line.desc },
      { keys.term.send_line.key2, "<cmd>ToggleTermSendCurrentLine<cr>", desc = keys.term.send_line.desc, mode = "i" },
      { keys.term.send_selection.key, ":ToggleTermSendVisualSelectionCustom<CR>'>", desc = keys.term.send_selection.desc, mode = "x" },
      { keys.term.send_selection.key2, ":ToggleTermSendVisualSelectionCustom<CR>'>", desc = keys.term.send_selection.desc, mode = "x" },
    },
    config = function(_, opts)

      require("toggleterm").setup(opts)

      vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionCustom", function(args)
        custom_send_lines_to_terminal("visual_selection", false, args)
      end, { range = true, nargs = "?" })

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

      vim.api.nvim_create_user_command("TermLazygit", function() lazygit:toggle() end, {})

    end
  }
}

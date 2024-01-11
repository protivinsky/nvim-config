-- TOGGLETERM
local toggleterm = require("toggleterm")

-- redefine function that sends lines to terminal

local lazy = require("toggleterm.lazy")
local utils = lazy.require("toggleterm.utils")

local function custom_send_lines_to_terminal(selection_type, trim_spaces, cmd_data)
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

  local startingSpaces = nil
  -- local newLines = {}
  for _, line in ipairs(lines) do
    local l = trim_spaces and line:gsub("^%s+", ""):gsub("%s+$", "") or line
    -- FIX FOR PYTHON INDENT TO WORK CORRECTLY
    if not string.match(l, "^%s*$") then
      if startingSpaces == nil then
        _, startingSpaces = string.find(l, "^ *")
      end
      local l_norm = string.gsub(l, " ", "", startingSpaces)
      -- table.insert(newLines, l_norm)
      toggleterm.exec(l_norm, id)
    end
    -- print(l)
  end
  -- toggleterm.exec("%cpaste\n" .. table.concat(newLines, "\n") .. "\n--\n")
  toggleterm.exec("", id)

  -- Jump back with the cursor where we were at the beginning of the selection
  vim.api.nvim_set_current_win(current_window)
  vim.api.nvim_win_set_cursor(current_window, { start_line, start_col })
end

vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionCustom", function(args)
  custom_send_lines_to_terminal("visual_selection", false, args)
end, { range = true, nargs = "?" })

-- require("which-key").register({
--   ["<leader>t"] = { name = "terminal", _ = "which_key_ignore" },
-- })

vim.keymap.set(
  "n",
  "<leader>cp",
  -- "<cmd>TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python'<cr>",
  "<cmd>TermExec direction=vertical size=120 cmd='python'<cr>",
  { desc = "Open Python terminal" }
)
vim.keymap.set(
  "n",
  "<leader>ci",
  -- "<cmd>TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}ipython --TerminalInteractiveShell.autoindent=False'<cr>",
  "<cmd>TermExec direction=vertical size=120 cmd='ipython --TerminalInteractiveShell.autoindent=False'<cr>",
  { desc = "Open IPython terminal" }
)
vim.keymap.set(
  "n",
  "<leader>ct",
  "<cmd>ToggleTerm direction=vertical size=120<cr>",
  { desc = "Open vertical terminal" }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>ToggleTerm direction=horizontal size=40<cr>",
  { desc = "Open horizontal terminal" }
)

vim.keymap.set(
  "n",
  "<leader>cP",
  -- "<cmd>w<cr>:9TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python %'<cr>",
  "<cmd>w<cr>:9TermExec direction=vertical size=120 cmd='python %'<cr>",
  { desc = "Save and run file in python" }
)
vim.keymap.set("n", "<leader>cc", "<cmd>ToggleTermSendCurrentLine<cr>j", { desc = "Send line to terminal" })
vim.keymap.set("x", "<leader>cc", ":ToggleTermSendVisualSelectionCustom<CR>'>", { desc = "Send selection to terminal" })
vim.keymap.set("n", "<leader>r", "<cmd>ToggleTermSendCurrentLine<cr>j", { desc = "Send line to terminal" })
vim.keymap.set("x", "<leader>r", ":ToggleTermSendVisualSelectionCustom<CR>'>", { desc = "Send selection to terminal" })
-- vim.keymap.set("n", "<leader>tq", "<cmd>TermSelect<cr>1<cr>i<C-d><C-d>", { desc = "Quit terminal" })


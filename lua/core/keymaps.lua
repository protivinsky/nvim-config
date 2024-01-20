-- taken from https://raw.githubusercontent.com/LazyVim/LazyVim/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set
local keys = require("core.keys")

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
map("n", keys.buffer.prev.key, "<cmd>bprevious<cr>", { desc = keys.buffer.prev.desc })
map("n", keys.buffer.next.key, "<cmd>bnext<cr>", { desc = keys.buffer.next.desc })
map("n", keys.buffer.prev.key2, "<cmd>bprevious<cr>", { desc = keys.buffer.prev.desc })
map("n", keys.buffer.next.key2, "<cmd>bnext<cr>", { desc = keys.buffer.next.desc })
map("n", keys.buffer.switch.key, "<cmd>e #<cr>", { desc = keys.buffer.switch.desc })
map("n", keys.buffer.delete.key, "<cmd>bp|bd #<cr>", { desc = keys.buffer.delete.desc })
-- map("n", keys.buffer.switch.key2, "<cmd>e #<cr>", { desc = keys.buffer.switch.desc })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Press jk to escape from insert mode
map("i", "jk", "<ESC>", { noremap = true, silent = true })
-- Menu navigation
map("c", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("c", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- stay in the center
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- fix pasting over visual selection
map("v", "p", '"_dP')

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
-- how about these?
map("n", "<leader>k", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
map("n", "<leader>o", "<C-o>", { desc = "Prev position" })
map("n", "<leader>i", "<C-i>", { desc = "Next position" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- new file
map("n", keys.new_file.key, "<cmd>enew<cr>", { desc = keys.new_file.desc })

map("n", keys.location_list.key, "<cmd>lopen<cr>", { desc = keys.location_list.desc })
map("n", keys.quickfix_list.key, "<cmd>copen<cr>", { desc = keys.quickfix_list.desc })

map("n", keys.quickfix_prev.key, vim.cmd.cprev, { desc = keys.quickfix_prev.desc })
map("n", keys.quickfix_next.key, vim.cmd.cnext, { desc = keys.quickfix_next.desc })

-- git
map("n", keys.git.fugitive.key, "<cmd>G<cr>", { desc = keys.git.fugitive.desc })
map("n", keys.git.blame.key, "<cmd>Git blame<cr>", { desc = keys.git.blame.desc })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", keys.diag.line.key, vim.diagnostic.open_float, { desc = keys.diag.line.desc })
map("n", keys.diag.next_diag.key, diagnostic_goto(true), { desc = keys.diag.next_diag.desc })
map("n", keys.diag.prev_diag.key, diagnostic_goto(false), { desc = keys.diag.prev_diag.desc })
map("n", keys.diag.next_error.key, diagnostic_goto(true, "ERROR"), { desc = keys.diag.next_error.desc })
map("n", keys.diag.prev_error.key, diagnostic_goto(false, "ERROR"), { desc = keys.diag.prev_error.desc })
map("n", keys.diag.next_warning.key, diagnostic_goto(true, "WARN"), { desc = keys.diag.next_warning.desc })
map("n", keys.diag.prev_warning.key, diagnostic_goto(false, "WARN"), { desc = keys.diag.prev_warning.desc })

-- quit
map("n", keys.quit.all.key, "<cmd>qa<cr>", { desc = keys.quit.all.desc })

-- restore session
-- map("n", "<leader>qr", require("persistence").load(), "Restore session")

-- highlights under cursor
map("n", keys.ui.show_pos.key, vim.show_pos, { desc = keys.ui.show_pos.desc })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

map("n", "<leader>we", "<cmd>tab split<cr>", { desc = "Maximize window" })
map("n", "<leader>wq", "<cmd>q<cr>", { desc = "Close window" })
map("n", "<leader>w=", "<C-W>=", { desc = "Equally high and wide" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- TMUX <-> VIM NAVIGATION
local tmux = require("tmux")
vim.keymap.set("n", "<C-k>", tmux.move_top, {})
vim.keymap.set("n", "<C-j>", tmux.move_bottom, {})
vim.keymap.set("n", "<C-h>", tmux.move_left, {})
vim.keymap.set("n", "<C-l>", tmux.move_right, {})


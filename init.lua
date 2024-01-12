vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require("core.lazy")
require("core.options")
require("core.keymaps")
require("core.autocmd")

require("setup.telescope")
require("setup.which-key")
require("setup.lsp.mason")
require("setup.lsp.handlers")
require("setup.term")
require("setup.cmp")


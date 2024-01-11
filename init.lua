vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require("core.lazy")
require("core.options")
require("core.keymaps")
require("core.autocmd")

require("setup.telescope")
require("setup.which-key")
require("setup.lsp")
require("setup.term")
require("setup.cmp")
require("setup.lang")


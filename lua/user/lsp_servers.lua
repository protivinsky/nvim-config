-- Servers installed and managed by Mason
local mason = {
  "lua_ls",
  "clangd",
  "pyright",
  -- "basedpyright",
  "bashls",
  "jsonls",
  "openscad_lsp",
}

-- All servers to enable (mason + manually managed)
local all = vim.list_extend(vim.deepcopy(mason), {
  "julials",
})

return {
  mason = mason,
  all = all,
}

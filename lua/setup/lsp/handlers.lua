local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  local signs = {

    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_keymaps(bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set(
      'n',
      keys,
      func,
      { buffer = bufnr, desc = desc, noremap = true, silent = true }
    )
  end

  telescope_builtin = require("telescope.builtin")

  nmap('gd', telescope_builtin.lsp_definitions, 'Definition')
  nmap('gr', telescope_builtin.lsp_references, 'References')
  nmap('gI', telescope_builtin.lsp_implementations, 'Implementation')
  nmap('<leader>D', telescope_builtin.lsp_type_definitions, 'Type definition')
  nmap('<leader>ds', telescope_builtin.lsp_document_symbols, 'Document symbols')
  nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature help')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, 'Declaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace add folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace remove folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, 'Workspace list folders')

  nmap("gl", vim.diagnostic.open_float, "Line diagnostic")
  nmap("<leader>ll", vim.diagnostic.open_float, "Line diagnostic")
  nmap("<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format buffer")
  nmap("<leader>li", "<cmd>LspInfo<cr>", "LspInfo")
  nmap("<leader>lI", "<cmd>LspInstallInfo<cr>", "LspInstallInfo")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code action")
  nmap("<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next diagnostic")
  nmap("<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Prev diagnostic")
  nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ls", vim.lsp.buf.signature_help, "Signature help")
  nmap("<leader>lq", vim.diagnostic.setloclist, "Diagnostic list")
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.documentFormattingProvider = false
  end

  lsp_keymaps(bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
end

return M

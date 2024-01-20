local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

local keys = require("core.keys")

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

  local telescope_builtin = require("telescope.builtin")

  nmap(keys.lsp.definition.key, telescope_builtin.lsp_definitions, keys.lsp.definition.desc)
  nmap(keys.lsp.references.key, function() telescope_builtin.lsp_references({ fname_width = 100 }) end, keys.lsp.references.desc)
  nmap(keys.lsp.implementation.key, telescope_builtin.lsp_implementations, keys.lsp.implementation.desc)
  nmap(keys.lsp.type_def.key, telescope_builtin.lsp_type_definitions, keys.lsp.type_def.desc)
  -- These are defined in telescope.lua
  -- nmap(keys.lsp.doc_symbols.key, telescope_builtin.lsp_document_symbols, keys.lsp.doc_symbols.desc)
  -- nmap(keys.lsp.ws_symbols.key, telescope_builtin.lsp_dynamic_workspace_symbols, keys.lsp.ws_symbols.key)

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, keys.lsp.hover.desc)
  nmap(keys.lsp.hover.key, vim.lsp.buf.hover, keys.lsp.hover.desc)

  -- Lesser used LSP functionality
  nmap(keys.lsp.declaration.key, vim.lsp.buf.declaration, keys.lsp.declaration.desc)
  nmap(keys.lsp.ws_add_folder.key, vim.lsp.buf.add_workspace_folder, keys.lsp.ws_add_folder.desc)
  nmap(keys.lsp.ws_remove_folder.key, vim.lsp.buf.remove_workspace_folder, keys.lsp.ws_remove_folder.desc)
  nmap(keys.lsp.ws_list_folders.key, function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, keys.lsp.ws_list_folders.desc)

  nmap("gl", vim.diagnostic.open_float, keys.lsp.line_diag.desc)
  nmap(keys.lsp.line_diag.key, vim.diagnostic.open_float, keys.lsp.line_diag.desc)
  nmap(keys.lsp.format.key, "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", keys.lsp.format.desc)
  nmap(keys.lsp.info.key, "<cmd>LspInfo<cr>", keys.lsp.info.desc)
  nmap(keys.lsp.code_action.key, vim.lsp.buf.code_action, keys.lsp.code_action.desc)
  nmap(keys.lsp.next_diag.key, "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.prev_diag.key, "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.rename.key, vim.lsp.buf.rename, keys.lsp.rename.desc)
  nmap(keys.lsp.sig_help.key, vim.lsp.buf.signature_help, keys.lsp.sig_help.desc)
  nmap(keys.lsp.diag_list.key, vim.diagnostic.setloclist, keys.lsp.diag_list.desc)
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

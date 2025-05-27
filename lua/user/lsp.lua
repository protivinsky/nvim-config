local keys = require("user.keys")

-- enable servers -- actually done by mason-lspconfig + install
-- local servers = require("user.lsp_servers")
-- for _, server in ipairs(servers) do
--   vim.lsp.enable(server)
-- end

-- diagnostics
local icons_diagnostics = require("user.util").icons.diagnostics
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons_diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons_diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = icons_diagnostics.Info,
      [vim.diagnostic.severity.HINT] = icons_diagnostics.Hint,
    },
  },
})

-- keymaps
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
  nmap(keys.lsp.format.key, "<cmd>lua vim.lsp.buf.format{ async = true, timeout_ms = 2000 }<cr>", keys.lsp.format.desc)
  nmap(keys.lsp.code_action.key, vim.lsp.buf.code_action, keys.lsp.code_action.desc)
  nmap(keys.lsp.next_diag.key, "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.prev_diag.key, "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.rename.key, vim.lsp.buf.rename, keys.lsp.rename.desc)
  nmap(keys.lsp.sig_help.key, vim.lsp.buf.signature_help, keys.lsp.sig_help.desc)
  nmap(keys.lsp.diag_list.key, vim.diagnostic.setloclist, keys.lsp.diag_list.desc)
  -- TODO: make this filetype dependent - set it up only for clangd LSP server
  nmap("<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)")
end


-- Create keybindings, commands, inlay hints and autocommands on LSP attach {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      -- vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end
    ---@diagnostic disable-next-line need-check-nil
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- -- nightly has inbuilt completions, this can replace all completion plugins
    -- if client:supports_method("textDocument/completion", bufnr) then
    --   -- Enable auto-completion
    --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    -- end

    --- Disable semantic tokens
    ---@diagnostic disable-next-line need-check-nil
    client.server_capabilities.semanticTokensProvider = nil

    lsp_keymaps(bufnr)

    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
      return
    end
    illuminate.on_attach(client)
  end,
})
-- }}}

local keys = require("user.keys")

local servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "bashls",
  "jsonls",
  "openscad_lsp",
}

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
  nmap(keys.lsp.code_action.key, vim.lsp.buf.code_action, keys.lsp.code_action.desc)
  nmap(keys.lsp.next_diag.key, "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.prev_diag.key, "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", keys.lsp.next_diag.desc)
  nmap(keys.lsp.rename.key, vim.lsp.buf.rename, keys.lsp.rename.desc)
  nmap(keys.lsp.sig_help.key, vim.lsp.buf.signature_help, keys.lsp.sig_help.desc)
  nmap(keys.lsp.diag_list.key, vim.diagnostic.setloclist, keys.lsp.diag_list.desc)
  -- TODO: make this filetype dependent - set it up only for clangd LSP server
  nmap("<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)")
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
end


return {
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', config = true },
      { 'folke/neodev.nvim', config = true },
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        virtual_text = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {
          settings = {
            python = { analysis = { typeCheckingMode = "basic" } }
          },
        },
        clangd = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
    config = function(_, opts)
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))

      -- diagnostics
      for name, icon in pairs(require("user.util").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- local servers = opts.servers
      cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = on_attach,
        }, opts.servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      require("mason-lspconfig").setup({ ensure_installed = servers, handlers = { setup } })
    end,
  },

  -- cmdline tools and lsp servers
  {

    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { },
      ui = {
        border = "none",
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    },
  },

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
}

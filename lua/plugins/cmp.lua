return {
  -- "github/copilot.vim",

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    version = false,
    event = "InsertEnter",
    dependencies = {
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',

      -- -- Snippet Engine & its associated nvim-cmp source
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',
      --
      -- -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        -- snippet = {
        --   expand = function(args)
        --     require("luasnip").lsp_expand(args.body)
        --   end,
        -- },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "luasnip" },
          { name = "path" },
          { name = "calc" },
          { name = "copilot" },
          { name = "buffer" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("core.util").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
    local cmp = require("cmp")
    cmp.setup(opts)
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })
    end,
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
      on_status_update = function() require("lualine").refresh() end,
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
        require("copilot_cmp").setup()
    end,
  },
}

-- config for cmp mapping from from-scratch by Chris@Machine

-- local check_backspace = function()
--   local col = vim.fn.col(".") - 1
--   return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
-- end
--
-- mapping = {
--   ["<c-k>"] = cmp.mapping.select_prev_item(),
--   ["<c-j>"] = cmp.mapping.select_next_item(),
--   ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
--   ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
--   ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--   ["<c-y>"] = cmp.config.disable, -- specify `cmp.config.disable` if you want to remove the default `<c-y>` mapping.
--   ["<c-e>"] = cmp.mapping({
--     i = cmp.mapping.abort(),
--     c = cmp.mapping.close(),
--   }),
--   -- accept currently selected item. if none selected, `select` first item.
--   -- set `select` to `false` to only confirm explicitly selected items.
--   ["<cr>"] = cmp.mapping.confirm({ select = false }),
--   -- i hate the default behavior of tab and cr
--   ["tab"] = nil,
--   ["<c-tab>"] = cmp.mapping(function(fallback)
--     if cmp.visible() then
--       cmp.select_next_item()
--     elseif require("copilot.suggestion").is_visible() then
--       require("copilot.suggestion").accept()
--     -- elseif luasnip.expandable() then
--     --   luasnip.expand()
--     -- elseif luasnip.expand_or_jumpable() then
--     --   luasnip.expand_or_jump()
--     elseif check_backspace() then
--       fallback()
--     else
--       fallback()
--     end
--   end, {
--     "i",
--     "s",
--   }),
--   ["<s-tab>"] = cmp.mapping(function(fallback)
--     if cmp.visible() then
--       cmp.select_prev_item()
--     -- elseif luasnip.jumpable(-1) then
--     --   luasnip.jump(-1)
--     else
--       fallback()
--     end
--   end, {
--     "i",
--     "s",
--   }),
-- },


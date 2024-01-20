local aerial_toggle = require("core.keys").code.aerial_toggle

return {
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = vim.deepcopy(require("core.util").icons.kinds)

      -- HACK: fix lua's weird choice for `Package` for control
      -- structures like if/else/for/etc.
      icons.lua = { Package = icons.Control }

      -- ---@type table<string, string[]>|false
      -- local filter_kind = false
      -- if Config.kind_filter then
      --   filter_kind = assert(vim.deepcopy(Config.kind_filter))
      --   filter_kind._ = filter_kind.default
      --   filter_kind.default = nil
      -- end
      --
      local opts = {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          resize_to_content = false,
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "yes",
            statuscolumn = " ",
          },
        },
        icons = icons,
        -- filter_kind = filter_kind,
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      }
      return opts
    end,
    keys = {
      { aerial_toggle.key, "<cmd>AerialToggle<cr>", desc = aerial_toggle.desc },
    },
  },
}


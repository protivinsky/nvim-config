return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
      filetypes = { markdown = { enabled = true } },
      on_status_update = function() require("lualine").refresh() end,
    },
    -- dependencies = { "zbirenbaum/copilot-cmp", config = true },
  },

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      { "saghen/blink.compat", lazy = true, verson = false },
      "giuxtaposition/blink-cmp-copilot",
    },

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'enter' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        -- use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "copilot",
          "codecompanion",
          "obsidian",
          "obsidian_new",
          "obsidian_tags"
        },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
          obsidian = { name = "obsidian", module = "blink.compat.source" },
          obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
          obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
        },
        -- default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- optionally disable cmdline completions
        -- cmdline = {},
      },
      completion = {
        list = { selection = { preselect = false } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },

      -- experimental signature help support
      signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
  },
}

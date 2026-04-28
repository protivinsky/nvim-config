local keys = require("user.keys")

local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "julia",
  "latex",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(ensure_installed)

      vim.treesitter.language.register("json", "jsonc")

      local ft_pattern = vim.list_extend({ "jsonc" }, ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft_pattern,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local sel = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local select_pairs = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
      }
      for lhs, capture in pairs(select_pairs) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          sel.select_textobject(capture, "textobjects")
        end)
      end

      local function map_move(lhs, fn, capture)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          fn(capture, "textobjects")
        end)
      end
      map_move(keys.code.next_function_start.key, move.goto_next_start, "@function.outer")
      map_move(keys.code.next_function_end.key, move.goto_next_end, "@function.outer")
      map_move(keys.code.prev_function_start.key, move.goto_previous_start, "@function.outer")
      map_move(keys.code.prev_function_end.key, move.goto_previous_end, "@function.outer")
      map_move(keys.code.next_class_start.key, move.goto_next_start, "@class.outer")
      map_move(keys.code.next_class_end.key, move.goto_next_end, "@class.outer")
      map_move(keys.code.prev_class_start.key, move.goto_previous_start, "@class.outer")
      map_move(keys.code.prev_class_end.key, move.goto_previous_end, "@class.outer")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },
}

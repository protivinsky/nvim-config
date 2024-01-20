local keys = require("core.keys")

local pretty_path = function()
  local path = vim.fn.expand "%:p"
  local cwd = vim.fn.getcwd()
  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  end
  local home = vim.fn.expand "$HOME"
  if path:find(home, 1, true) == 1 then
    path = "~" .. path:sub(#home + 1)
  end
  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, "[\\/]")
  if #parts > 3 then
    path = table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, sep)
  end
  return path
end

local lualine_b = {
  { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  { pretty_path },
}


return {
  {
    "aserowy/tmux.nvim",
    version = false,
    lazy = false,
    config = function()
      return require("tmux").setup()
    end,
  },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "onedark"
    end,
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = { "AndreM222/copilot-lualine" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
        disabled_filetypes = { winbar = { "neo-tree" }},
      },
      extensions = { "neo-tree", "lazy", "toggleterm" },
      sections = {
        lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      winbar = {
        -- lualine_a = { "mode" },
        lualine_b = lualine_b,
        -- lualine_y = { "location" },
      },
      inactive_winbar = {
        lualine_b = lualine_b,
        -- lualine_y = { "location" },
      },
    },
  },

  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { keys.buffer.toggle_pin.key, "<Cmd>BufferLineTogglePin<CR>", desc = keys.buffer.toggle_pin.desc },
      { keys.buffer.delete_non_pinned.key, "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = keys.buffer.delete_non_pinned.desc },
      { keys.buffer.close_others.key, "<Cmd>BufferLineCloseOthers<CR>", desc = keys.buffer.close_others.desc },
      { keys.buffer.close_right.key, "<Cmd>BufferLineCloseRight<CR>", desc = keys.buffer.close_right.desc },
      { keys.buffer.close_left.key, "<Cmd>BufferLineCloseLeft<CR>", desc = keys.buffer.close_left.desc },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { keys.buffer.prev.key, "<cmd>BufferLineCyclePrev<cr>", desc = keys.buffer.prev.desc },
      { keys.buffer.next.key, "<cmd>BufferLineCycleNext<cr>", desc = keys.buffer.next.desc },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("core.util").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}

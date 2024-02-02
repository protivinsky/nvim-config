local keys = require("user.keys")

return {
  -- This is what powers LazyVim's fancy-looking
  -- tabs, which include filetype icons and close buttons.
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
        local icons = require("user.util").icons.diagnostics
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
}

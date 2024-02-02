local keys = require("user.keys")

return {
  -- better diagnostics list and others
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  opts = { use_diagnostic_signs = true },
  keys = {
    { keys.trouble.doc_diag.key, "<cmd>TroubleToggle document_diagnostics<cr>", desc = keys.trouble.doc_diag.desc },
    { keys.trouble.ws_diag.key, "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = keys.trouble.ws_diag.desc },
    { keys.trouble.loclist.key, "<cmd>TroubleToggle loclist<cr>", desc = keys.trouble.loclist.desc },
    { keys.trouble.quickfix.key, "<cmd>TroubleToggle quickfix<cr>", desc = keys.trouble.quickfix.desc },
    {
      keys.trouble.prev.key,
      function()
        if require("trouble").is_open() then
          require("trouble").previous({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = keys.trouble.prev.desc,
    },
    {
      keys.trouble.next.key,
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = keys.trouble.next.desc,
    },
  },
}



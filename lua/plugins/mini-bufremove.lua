local keys = require("user.keys")

return {
  -- buffer remove
  "echasnovski/mini.bufremove",
  keys = {
    {
      keys.buffer.delete.key,
      function()
        local bd = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then -- No
            bd(0, true)
          end
        else
          bd(0)
        end
      end,
      desc = keys.buffer.delete.desc,
    },
    -- stylua: ignore
    {
      keys.buffer.force_delete.key,
      function() require("mini.bufremove").delete(0, true) end,
      desc = keys.buffer.force_delete.desc,
    },
  },
}


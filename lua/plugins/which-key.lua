return {
  {
    "folke/which-key.nvim",         -- popup with keympas
    event = "VeryLazy",
    opts = {
      notify = false,
    },
    config = function(_, opts)
      local core_keys = require("user.keys").which
      local to_register = {}
      for _, kd in pairs(core_keys) do
        to_register[kd.key] = { name = kd.desc, _ = "which_key_ignore" }
      end
      local wh = require("which-key")
      wh.setup(opts)
      -- print("registering all the stuff")
      wh.register(to_register)
      wh.register({["<leader>"] = { name = "VISUAL <leader>" }}, { mode = "v" })
    end
  }
}

local keys = require("user.keys")

return {
  {
    "NeogitOrg/neogit",
    opts = { status = { recent_commit_count = 20 } },
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      {
        "sindrets/diffview.nvim",
        keys = {
          { keys.git.diffview_open.key, "<cmd>DiffviewOpen<cr>", desc = keys.git.diffview_open.desc },
          { keys.git.diffview_close.key, "<cmd>DiffviewClose<cr>", desc = keys.git.diffview_close.desc },
        },
        config = true,
      },
      "nvim-telescope/telescope.nvim", -- optional
    },
  }
}

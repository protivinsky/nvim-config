local keys = require("user.keys")
return {

  "obsidian-nvim/obsidian.nvim",
  -- version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  keys = {
    { keys.obsidian.new.key, "<cmd>Obsidian new<cr>", desc = keys.obsidian.new.desc },
    { keys.obsidian.open_app.key, "<cmd>Obsidian open<cr>", desc = keys.obsidian.open_app.desc },
    { keys.obsidian.quick_switch.key, "<cmd>Obsidian  quick_switch<cr>", desc = keys.obsidian.quick_switch.desc },
    { keys.obsidian.follow.key, "<cmd>Obsidian follow_link<cr>", desc = keys.obsidian.follow.desc },
    { keys.obsidian.follow_vertical.key, "<cmd>Obsidian follow_link vsplit<cr>", desc = keys.obsidian.follow_vertical.desc },
    { keys.obsidian.follow_horizontal.key, "<cmd>Obsidian follow_link hsplit<cr>", desc = keys.obsidian.follow_horizontal.desc },
    { keys.obsidian.backlinks.key, "<cmd>Obsidian backlinks<cr>", desc = keys.obsidian.backlinks.desc },
    { keys.obsidian.tags.key, "<cmd>Obsidian tags<cr>", desc = keys.obsidian.tags.desc },
    { keys.obsidian.toc.key, "<cmd>Obsidian toc<cr>", desc = keys.obsidian.toc.desc },
    { keys.obsidian.daily.key, "<cmd>Obsidian today<cr>", desc = keys.obsidian.daily.desc },
    { keys.obsidian.search.key, "<cmd>Obsidian search<cr>", desc = keys.obsidian.search.desc },
    { keys.obsidian.links.key, "<cmd>Obsidian links<cr>", desc = keys.obsidian.links.desc },
    { keys.obsidian.paste_img.key, "<cmd>Obsidian paste_img<cr>", desc = keys.obsidian.paste_img.desc },
    { keys.obsidian.link_new.key, "<cmd>Obsidian link_new<cr>", desc = keys.obsidian.link_new.desc },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/notes/vault",
      },
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
    },
    -- ui = { enable = false },
    ui = {
      hl_groups = {
        ObsidianTodo         = { link = "Todo" },
        ObsidianDone         = { link = "DiagnosticOk" },
        ObsidianRightArrow   = { link = "DiagnosticInfo" },
        ObsidianTilde        = { link = "DiagnosticWarn" },
        ObsidianImportant    = { link = "DiagnosticError" },
        ObsidianBullet       = { link = "Delimiter" },
        ObsidianRefText      = { link = "Underlined" },
        ObsidianExtLinkIcon  = { link = "Special" },
        ObsidianTag          = { link = "Tag" },
        ObsidianBlockID      = { link = "Comment" },
        ObsidianHighlightText = { link = "Search" },
      },
    },
    -- Specify how to handle attachments.
    attachments = {
      folder = "assets",  -- This is the default
      img_name_func = function()
        return string.format("img_%s", os.date("%Y%m%d%H%M%S"))
      end,
      confirm_img_paste = false,
    },
  },
}

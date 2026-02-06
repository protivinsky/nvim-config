return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    -- Helper function to check if we're in an opencode terminal
    local function is_opencode_terminal()
      return vim.bo.buftype == "terminal" and vim.bo.filetype == "opencode_terminal"
    end

    -- Smart half-page scrolling: normal scroll in regular buffers, opencode scroll in opencode terminal
    vim.keymap.set({ "n", "x", "t" }, "<C-u>", function()
      if is_opencode_terminal() then
        require("opencode").command("session.half.page.up")
      else
        vim.cmd("normal! <C-u>")
      end
    end, { desc = "Half page up (opencode-aware)" })

    vim.keymap.set({ "n", "x", "t" }, "<C-d>", function()
      if is_opencode_terminal() then
        require("opencode").command("session.half.page.down")
      else
        vim.cmd("normal! <C-d>")
      end
    end, { desc = "Half page down (opencode-aware)" })

    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}

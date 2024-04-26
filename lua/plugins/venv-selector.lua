local keys = require("user.keys")

return {
  'linux-cultist/venv-selector.nvim',
  dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
  opts = {
    dap_enabled = true,
    name = { "venv", ".venv" },
  },
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    {
      keys.code.venv_select.key,
      '<cmd>VenvSelect<cr><cmd>LspRestart<cr>',
      desc = keys.code.venv_select.desc
    },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    {
      keys.code.venv_cached.key,
      '<cmd>VenvSelectCached<cr><cmd>LspRestart<cr>',
      desc = keys.code.venv_cached.desc
    },
    { keys.code.venv_info.key, "<cmd>VenvSelectCurrent<cr>", desc = keys.code.venv_info.desc },
  }
}

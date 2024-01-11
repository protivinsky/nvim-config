-- document existing key chains
require('which-key').register {
  ['<leader>b'] = { name = 'buffer', _ = 'which_key_ignore' },
  ['<leader>c'] = { name = 'code', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = 'debug', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = 'find/file', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = 'git/goto', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'git hunk', _ = 'which_key_ignore' },
  ['<leader>q'] = { name = 'quit/session', _ = 'which_key_ignore' },
  -- ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = 'search', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = 'test', _ = 'which_key_ignore' },
  ['<leader>u'] = { name = 'ui', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = 'windows', _ = 'which_key_ignore' },
  ['<leader>x'] = { name = 'diagnostics/quickfix', _ = 'which_key_ignore' },
  ['<leader><tab>'] = { name = 'tabs', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  -- ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

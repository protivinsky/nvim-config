return {
  "protivinsky/etude.nvim",
  cmd = "Etude",
  opts = {
    sources = {
      -- Available from the Project Gutenberg: https://www.gutenberg.org/ebooks/1250
      { path = vim.fn.stdpath("config") .. "/assets/anthem.txt", name = "Anthem (Ayn Rand)" },
    },
    highlights = {
      pending = "Delimiter",
    },
  },
}

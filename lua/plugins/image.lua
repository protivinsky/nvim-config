return {
  "3rd/image.nvim",
  -- switch to master after it contains https://github.com/3rd/image.nvim/pull/266e
  branch = "develop",
  version = false,
  -- Only load if we're in Kitty terminal
  enabled = function()
    return vim.env.KITTY_WINDOW_ID ~= nil
  end,
  event = "VeryLazy",
  dependencies = {
    { "luarocks.nvim" },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "markdown" },
          highlight = { enable = true },
        })
      end,
    },
  },
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = false,
        only_render_image_at_cursor = true,
        filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
        resolve_image_path = function(document_path, image_path, fallback)
            local working_dir = vim.fn.getcwd()
            if (working_dir:find("/home/thomas/notes/vault", 1, true)) then
                return working_dir .. "/" .. image_path
            end
            -- Fallback to the default behavior
            return fallback(document_path, image_path)
        end
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    kitty_method = "normal",
  },
}

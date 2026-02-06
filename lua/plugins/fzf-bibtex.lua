-- FZF-lua bibtex search (replacement for telescope-bibtex)
local keys = require("user.keys")

return {
  "ibhagwan/fzf-lua",
  optional = true,
  keys = {
    {
      keys.search.bibtex.key,
      function()
        local fzf = require("fzf-lua")

        -- Read and parse the bibtex file
        local bib_file = vim.fn.expand("~/library.bib")

        -- Use bibtex-ls or bibtool if available, otherwise parse manually
        if vim.fn.executable("bibtex-ls") == 1 then
          fzf.fzf_exec("bibtex-ls " .. bib_file, {
            prompt = "Bibtex❯ ",
            preview = "echo {} | bibtex-ls -format=markdown " .. bib_file,
            actions = {
              ["default"] = function(selected)
                -- Extract citation key and insert at cursor
                local cite_key = selected[1]:match("^(%S+)")
                if cite_key then
                  vim.api.nvim_put({ "@" .. cite_key }, "c", true, true)
                end
              end,
            },
          })
        else
          -- Fallback: simple grep-based search
          fzf.fzf_exec(
            "grep -E '@|author|title|year|keywords' " .. bib_file .. " | grep -v '^%'",
            {
              prompt = "Bibtex❯ ",
              fzf_opts = {
                ["--delimiter"] = "=",
                ["--with-nth"] = "1..",
                ["--preview-window"] = "down:50%:wrap",
              },
              preview = "grep -A 10 {} " .. bib_file,
              actions = {
                ["default"] = function(selected)
                  -- Try to extract citation key
                  local line = selected[1]
                  local cite_key = line:match("@%w+{([^,]+)")
                  if cite_key then
                    vim.api.nvim_put({ "@" .. cite_key }, "c", true, true)
                  end
                end,
              },
            }
          )
        end
      end,
      desc = keys.search.bibtex.desc,
    },
  },
}

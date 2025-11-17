local pretty_path = function()
  local path = vim.fn.expand "%:p"
  local cwd = vim.fn.getcwd()
  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  end
  local home = vim.fn.expand "$HOME"
  if path:find(home, 1, true) == 1 then
    path = "~" .. path:sub(#home + 1)
  end
  local sep = package.config:sub(1, 1)
  local parts = vim.split(path, "[\\/]")
  if #parts > 3 then
    path = table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, sep)
  end
  return path
end

local lualine_b = {
  { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
  { pretty_path },
}

return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  dependencies = { "AndreM222/copilot-lualine" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
        disabled_filetypes = {
          winbar = {
            "neo-tree",
            "Avante",
            "AvanteInput",
            "AvanteSelectedFiles",
            "dap-repl",
          },
        },
      },
      extensions = { "neo-tree", "lazy", "toggleterm" },
      sections = {
        lualine_x = {
          "copilot", "encoding", "fileformat", "filetype",
          {
            function()
              -- Check if MCPHub is loaded
              if not vim.g.loaded_mcphub then
                return "󰐻 -"
              end

              local count = vim.g.mcphub_servers_count or 0
              local status = vim.g.mcphub_status or "stopped"
              local executing = vim.g.mcphub_executing

              -- Show "-" when stopped
              if status == "stopped" then
                return "󰐻 -"
              end

              -- Show spinner when executing, starting, or restarting
              if executing or status == "starting" or status == "restarting" then
                local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                return "󰐻 " .. frames[frame]
              end

              return "󰐻 " .. count
            end,
            color = function()
              if not vim.g.loaded_mcphub then
                return { fg = "#6a5b5e" } -- Gray for not loaded
              end

              local status = vim.g.mcphub_status or "stopped"
              if status == "ready" or status == "restarted" then
                return { fg = "#9fb573" } -- Green for connected
              elseif status == "starting" or status == "restarting" then  
                return { fg = "#c49061" } -- Orange for connecting
              else
                return { fg = "#de6d68" } -- Red for error/stopped
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      winbar = {
        lualine_a = { "mode" },
        lualine_b = lualine_b,
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        }
      },
      inactive_winbar = {
        lualine_b = lualine_b,
        -- lualine_y = { "location" },
      },
    })
  end
}

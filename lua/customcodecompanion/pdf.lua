print("SLASH COMMAND PDF")

local path = require("plenary.path")

local config = require("codecompanion.config")
local log = require("codecompanion.utils.log")
local util = require("codecompanion.utils")

local fmt = string.format

CONSTANTS = {
  NAME = "PDF",
  PROMPT = "Select PDF(s) from library",
  -- Modify this path to your desired PDF folder location
  PDF_FOLDER = vim.fn.expand("~/books"), -- Change this to your preferred path
}

local providers = {
  ---The default provider
  ---@param SlashCommand CodeCompanion.SlashCommand
  ---@return nil
  default = function(SlashCommand)
    local default = require("codecompanion.providers.slash_commands.default")
    return default
      .new({
        output = function(selection)
          return SlashCommand:output(selection)
        end,
        SlashCommand = SlashCommand,
        title = CONSTANTS.PROMPT,
      })
      :find_files({
        cwd = CONSTANTS.PDF_FOLDER,
        file_pattern = "*.pdf",
      })
      :display()
  end,
  ---The Telescope provider
  ---@param SlashCommand CodeCompanion.SlashCommand
  ---@return nil
  telescope = function(SlashCommand)
    local telescope = require("codecompanion.providers.slash_commands.telescope")
    telescope = telescope.new({
      title = CONSTANTS.PROMPT,
      output = function(selection)
        return SlashCommand:output(selection)
      end,
    })

    telescope.provider.find_files({
      prompt_title = telescope.title,
      attach_mappings = telescope:display(),
      hidden = true,
      cwd = CONSTANTS.PDF_FOLDER,
      find_command = { "fd", "--type", "f", "--extension", "pdf" },
      search_dirs = { CONSTANTS.PDF_FOLDER },
      previewer = false,
    })
  end,

  ---The Mini.Pick provider
  ---@param SlashCommand CodeCompanion.SlashCommand
  ---@return nil
  mini_pick = function(SlashCommand)
    local mini_pick = require("codecompanion.providers.slash_commands.mini_pick")
    mini_pick = mini_pick.new({
      title = CONSTANTS.PROMPT,
      output = function(selected)
        return SlashCommand:output(selected)
      end,
    })

    mini_pick.provider.builtin.files(
      {
        cwd = CONSTANTS.PDF_FOLDER,
        filter = function(path)
          return vim.fn.fnamemodify(path, ":e"):lower() == "pdf"
        end
      },
      mini_pick:display(function(selected)
        return {
          path = selected,
        }
      end)
    )
  end,

  ---The fzf-lua provider
  ---@param SlashCommand CodeCompanion.SlashCommand
  ---@return nil
  fzf_lua = function(SlashCommand)
    local fzf = require("codecompanion.providers.slash_commands.fzf_lua")
    fzf = fzf.new({
      title = CONSTANTS.PROMPT,
      output = function(selected)
        return SlashCommand:output(selected)
      end,
    })

    fzf.provider.files(fzf:display(function(selected, opts)
      local file = fzf.provider.path.entry_to_file(selected, opts)
      return {
        relative_path = file.stripped,
        path = file.path,
      }
    end))
  end,
}

---@class CodeCompanion.SlashCommand.File: CodeCompanion.SlashCommand
local SlashCommand = {}

---@param args CodeCompanion.SlashCommandArgs
function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
    opts = args.opts,
  }, { __index = SlashCommand })

  return self
end

---Execute the slash command
---@param SlashCommands CodeCompanion.SlashCommands
---@return nil
function SlashCommand:execute(SlashCommands)
  if not config.can_send_code() and (self.config.opts and self.config.opts.contains_code) then
    return log:warn("Sending of code has been disabled")
  end
  return SlashCommands:set_provider(self, providers)
end

---Open and read the contents of the selected file
---@param selected table The selected item from the provider { relative_path = string, path = string }
function SlashCommand:read(selected)
  local ft = vim.filetype.match({ filename = selected.path })
  local relative_path = selected.relative_path or selected[1] or selected.path
  local id = "<pdf>" .. relative_path .. "</pdf>"

  -- Handle PDF files differently
  if vim.fn.fnamemodify(selected.path, ":e"):lower() == "pdf" then
    -- Use pdftotext to extract text content
    -- print(selected.path)
    local handle = io.popen(string.format("pdftotext -q '%s' -", selected.path))
    if not handle then
      return "", ft, id, relative_path
    end
    
    local content = handle:read("*a")
    handle:close()
    
    if not content or content == "" then
      return "", ft, id, relative_path
    end
    
    return content, ft, id, relative_path
  end

  -- Handle all other files normally
  local ok, content = pcall(function()
    return path.new(selected.path):read()
  end)

  if not ok then
    return ""
  end

  return content, ft, id, relative_path
end

---Output from the slash command in the chat buffer
---@param selected table The selected item from the provider { relative_path = string, path = string }
---@param opts? table
---@return nil
function SlashCommand:output(selected, opts)
  if not config.can_send_code() and (self.config.opts and self.config.opts.contains_code) then
    return log:warn("Sending of code has been disabled")
  end
  opts = opts or {}

  local content, ft, id, relative_path = self:read(selected)

  if content == "" then
    return log:warn("Could not read the file: %s", selected.path)
  end

  -- Workspaces allow the user to set their own custom description which should take priority
  local description
  if selected.description then
    description = fmt(
      [[%s

```%s
%s
```]],
      selected.description,
      ft,
      content
    )
  else
    description = fmt(
      [[%s %s:

```%s
%s
```]],
      opts.pin and "Here is the updated content from the file" or "Here is the content from the file",
      "located at `" .. relative_path .. "`",
      ft,
      content
    )
  end

  self.Chat:add_message({
    role = config.constants.USER_ROLE,
    content = description or "",
  }, { reference = id, visible = false })

  if opts.pin then
    return
  end

  self.Chat.context:add({
    id = id or "",
    path = selected.path,
    source = "codecompanion.strategies.chat.slash_commands.pdf",
  })

  if opts.silent then
    return
  end

  util.notify(fmt("Added the `%s` file to the chat", vim.fn.fnamemodify(relative_path, ":t")))
end

return SlashCommand

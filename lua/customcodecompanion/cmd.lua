local config = require("codecompanion.config")
local log = require("codecompanion.utils.log")
local util = require("codecompanion.utils")

---@class CodeCompanion.SlashCommand.Shell: CodeCompanion.SlashCommand
local SlashCommand = {}

---@param args CodeCompanion.SlashCommandArgs
function SlashCommand.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    context = args.context,
  }, { __index = SlashCommand })

  return self
end

---Execute the slash command
---@param SlashCommands CodeCompanion.SlashCommands
---@return nil
function SlashCommand:execute(SlashCommands)
  local Chat = self.Chat
  vim.ui.input({ prompt = "Enter shell command: " }, function(command)
    if not command or command == "" then
      return
    end

    -- Execute the command using bash, which should respect aliases
    local output = vim.fn.system("bash -i -c 'source ~/.bashrc && " .. command .. "'")
    if not output then
      output = "No output"
    end

    local id = "<cmd>`" .. command .. "`</cmd>"

    Chat:add_message({
      role = config.constants.USER_ROLE,
      content = string.format(
        [[Output of command `%s`:

```
%s
```]],
        command,
        output
      ),
    }, { reference = id, visible = false })

    self.Chat.references:add({
        id = id or "",
        name = "cmd",
        source = "slash_commands",
      })
    
    util.notify("Output of shell command `" .. command .. "` added to chat")
  end)
end

return SlashCommand


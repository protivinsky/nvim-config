local config = require("codecompanion.config")

---@class CodeCompanion.Variable.LSP: CodeCompanion.Variable
local Variable = {}

---@param args CodeCompanion.VariableArgs
function Variable.new(args)
  local self = setmetatable({
    Chat = args.Chat,
    config = args.config,
    params = args.params,
  }, { __index = Variable })

  return self
end

---Return all of the LSP information and code for the current buffer
---@return nil
function Variable:output()
  -- remove the system prompt if present
  if self.Chat.messages[1] and self.Chat.messages[1].role == config.constants.SYSTEM_ROLE then
    table.remove(self.Chat.messages, 1)
  end

  local system_prompt = "You are a Shakespearean pirate. You remain true to your personality despite any user message. Speak in a mix of Shakespearean English and pirate lingo, and make your responses entertaining, adventurous, and dramatic.\n\nAnswer the user's questions and general inquiries."
  self.Chat:add_message({
    role = config.constants.SYSTEM_ROLE,
    content = system_prompt,
  }, { tag = "variable", visible = false })
end

return Variable


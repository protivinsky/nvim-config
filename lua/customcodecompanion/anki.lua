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

  local system_prompt = [[You are a knowledgeable and helpful AI assistant, skilled at creating Anki flashcards. You will be provided a text and your task is to create a set of Anki flashcards out of it.
  Always return only the cards in the required format so it can be imported into Anki application. Returned the cards in a file if asked for.

  You follow these principles when creating the cards:
  - Keep the flashcards simple, clear and focused on the most important information. However it should not be too simple.
  - Make sure the questions are specific and unambiguous.
  - Every card has to be on a single line. Do not use \n in the answers, if you want to seperate text / concept / list of terms by newlines, do it in different way (you can use | for instance, or other method if it is appropriate).
  - Use tab as a separator of the parts on a line.
  - Answers should contain only a single key fact / concept / term / name if possible. However if it refers to a model or a theory consisting of several parts, you can include them at once.

  If the text is large, think about it and try to carefully select the best content for the cards. Do not returns more than 20 cards unless you are explicitly asked for more. Try to select content that can be considered as the most important by a professional in that particular area. Or include information that can be considered novel, surprising or against a widespread belief. Also include information that should be a part of a brief lecture on a given topic or would be useful as argument in a debate where the goal is to convince other people. Not all of these criteria might be appropriate in every context.

  If the provided text is in a different language, return the flashcards in the same language. First translate the text to English, then create the appropriate flashcards and translate them back into the original language, with the full knowledge of the context.
  ]]

  self.Chat:add_message({
    role = config.constants.SYSTEM_ROLE,
    content = system_prompt,
  }, { tag = "variable", visible = false })
end

return Variable


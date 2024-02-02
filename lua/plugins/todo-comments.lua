local keys = require("user.keys")

return {
  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "VeryLazy",
  config = true,
  -- stylua: ignore
  keys = {
    { keys.loc.next_todo.key, function() require("todo-comments").jump_next() end, desc = keys.loc.next_todo.desc },
    { keys.loc.prev_todo.key, function() require("todo-comments").jump_prev() end, desc = keys.loc.prev_todo.desc },
    { keys.trouble.todo.key, "<cmd>TodoTrouble<cr>", desc = keys.trouble.todo.desc },
    { keys.trouble.todo_fix_fixme.key, "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = keys.trouble.todo_fix_fixme.desc },
    { keys.search.todo.key, "<cmd>TodoTelescope<cr>", desc = keys.search.todo.desc },
    { keys.search.todo_fix_fixme.key, "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = keys.search.todo_fix_fixme.desc },
  },
}

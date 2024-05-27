return {
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    branch = "dev",
    cmd = { "Trouble" },
    config = true,
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
  },
}

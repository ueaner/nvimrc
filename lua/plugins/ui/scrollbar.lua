return {
  -- scrollbar
  {
    "lewis6991/satellite.nvim",
    event = "LazyFile",
    opts = {
      excluded_filetypes = require("config").excluded_filetypes,
      current_only = true,
    },
  },
}

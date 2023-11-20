return {
  -- scrollbar
  {
    "lewis6991/satellite.nvim",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
    event = "LazyFile",
    opts = {
      excluded_filetypes = require("config").excluded_filetypes,
      current_only = true,
    },
  },
}

return {
  -- scrollbar
  {
    "dstein64/nvim-scrollview",
    event = "BufReadPre",
    opts = {
      excluded_filetypes = require("config").excluded_filetypes,
      current_only = true,
      winblend = 75,
    },
  },
}

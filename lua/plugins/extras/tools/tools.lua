return {
  -- table mode for markdown
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = {
      "TableModeToggle", -- automatic table formatter
      "Tableize", -- formatting existing content into a table
      "TableSort", -- sort by selected column
    },
    init = function()
      vim.g.table_mode_disable_mappings = 1
      vim.g.table_mode_disable_tableize_mappings = 1
    end,
  },

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}

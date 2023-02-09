return {
  -- table mode
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
    keys = {
      { "<leader>ut", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
    },
  },
}

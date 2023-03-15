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
      -- stylua: ignore
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>ut", "<cmd>TableModeToggle<cr>", { desc = "Toggle Table Mode", buffer = event.buf })
      end)
    end,
  },

  -- markdown preview
  {
    "ellisonleao/glow.nvim",
    event = "VeryLazy",
    cmd = { "Glow" },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fv", "<cmd>Glow!<cr>", { desc = "Live Preview (Markdown)", buffer = event.buf })
      end)
    end,
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
      })
    end,
  },
}

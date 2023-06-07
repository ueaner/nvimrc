return {
  -- keymap `<leader>ca` for LSP Code Action
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension("refactoring")
    end,
    -- stylua: ignore
    keys = {
      { "<leader>cr", function() require("telescope").extensions.refactoring.refactors() end, mode = { "v" }, desc = "Refactor", },
      { "<leader>rP", function() require('refactoring').debug.printf({below = false}) end,  mode = {"n"}, desc = "Debug Print" },
      { "<leader>rp", function() require('refactoring').debug.print_var({normal = true}) end, mode = {"n"}, desc = "Debug Print Variable" },
      { "<leader>rp", function() require('refactoring').debug.print_var({}) end, mode = {"v"}, desc =  "Debug Print Variable" },
      { "<leader>rc", function() require('refactoring').debug.cleanup({}) end, mode = {"n"}, desc = "Debug Cleanup" },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.refactoring,
      })
    end,
  },
}

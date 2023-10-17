return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    config = function()
      require("refactoring").setup({})
      require("telescope").load_extension("refactoring")
    end,
    keys = {
      {
        "<leader>cR",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = { "n", "x" },
        desc = "Select Refactor",
      },
    },
  },
}

return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
      "nvim-lua/plenary.nvim",
      "neovim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    config = function()
      require("refactoring").setup({})
      U.on_load("telescope.nvim", function()
        require("telescope").load_extension("refactoring")
      end)
    end,
  },
}

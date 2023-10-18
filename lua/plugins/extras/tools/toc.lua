return {
  {
    "richardbizik/nvim-toc",
    event = "VeryLazy",
    cmd = "TOC",
    ft = "markdown",
    config = true,
    keys = {
      { "<leader>tc", "<cmd>TOC<cr>", ft = "markdown", desc = "TOC" },
    },
  },
}

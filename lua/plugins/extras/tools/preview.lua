return {
  -- browse and preview json files
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },

  -- previewing markdown in terminal
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    cmd = { "Glow" },
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
        border = "rounded",
      })
    end,
  },

  -- previewing markdown (image) in browser
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    cond = function()
      return vim.fn.executable("deno") == 1
    end,
    opts = {
      theme = "light",
      app = "browser",
    },
  },

  -- rendering markdown in neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
  },
}

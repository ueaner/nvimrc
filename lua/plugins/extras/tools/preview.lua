return {
  -- browse and preview json files
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },

  -- markdown preview in terminal
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

  -- markdown preview in browser
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
}

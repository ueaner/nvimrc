return {
  {
    "NvChad/nvterm",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      -- `<Esc><Esc>` enter normal mode, then switch windows
      { "<leader>tt", function() require("nvterm.terminal").toggle("horizontal") end, desc = "toggle term", mode = { "n", "t" } },
    },
    config = function()
      require("nvterm").setup()
    end,
  },
}

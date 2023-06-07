return {
  -- terminal
  {
    "NvChad/nvterm",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      -- `<Esc><Esc>` enter normal mode, then switch windows
      { "<leader>tt", function() require("nvterm.terminal").toggle("horizontal") end, desc = "toggle term", mode = { "n", "t" } },
    },
    config = function()
      require("nvterm").setup({
        terminals = {
          type_opts = {
            float = {
              border = "single",
              relative = "editor",
              row = 0.05,
              col = 0.05,
              width = 0.9,
              height = 0.82,
            },
          },
        },
      })
    end,
  },
}

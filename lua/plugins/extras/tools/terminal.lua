return {
  -- terminal
  {
    "NvChad/nvterm",
    event = "VeryLazy",
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

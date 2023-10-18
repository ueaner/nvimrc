return {
  -- translation
  {
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
    cmd = { "Translate" },
    config = function()
      require("translate").setup({
        preset = {
          command = {
            google = {
              args = { "-x", "socks5://127.0.0.1:1080" },
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>tz", "<cmd>Translate ZH<cr><esc>", desc = "Translate from English to Chinese", mode = { "x" } },
      { "<leader>te", "<cmd>Translate EN<cr><sec>", desc = "Translate from Chinese to English", mode = { "x" } },
    },
  },

  -- which key integration
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+translate", mode = { "x" } },
      },
    },
  },
}

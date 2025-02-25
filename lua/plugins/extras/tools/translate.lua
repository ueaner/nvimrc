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
              args = { "-x", "socks5h://127.0.0.1:1080" },
            },
          },
        },
      })
    end,
  },
}

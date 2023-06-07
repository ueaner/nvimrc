return {
  -- translation
  {
    "uga-rosa/translate.nvim",
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
    cmd = { "Translate" },
  },
}

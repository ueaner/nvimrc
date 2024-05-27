return {
  -- code runner
  {
    "michaelb/sniprun",
    enabled = false,
    event = "VeryLazy",
    build = "bash ./install.sh",
    opts = {
      display = { "Terminal" },
      live_display = { "VirtualTextOk", "TerminalOk" },
    },
    config = function(_, opts)
      require("sniprun").setup(opts)
    end,
  },
}

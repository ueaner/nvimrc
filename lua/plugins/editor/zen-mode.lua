return {
  -- folke/twilight.nvim: dims inactive portions of the code
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    event = "VeryLazy",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 0.85,
        height = 0.95,
      },
    },
  },
}

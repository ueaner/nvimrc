return {
  -- auto-resize windows
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    keys = { { "gz", "<cmd>WindowsMaximize<cr>", desc = "Zoom", mode = { "n", "t" } } },
    config = function()
      require("windows").setup({
        autowidth = {
          enable = false,
        },
      })
    end,
  },

  -- folke/twilight.nvim: dims inactive portions of the code
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 0.85, -- width of the Zen window
        height = 0.95, -- height of the Zen window
      },
    },
    keys = { { "gZ", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}

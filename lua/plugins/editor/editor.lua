-- Editor Features: which-key, fuzzy finder, file explorer, outline, jump, git signs, todo comments, auto-resize windows, etc.
return {
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- auto-resize windows
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    keys = { { "gz", "<cmd>WindowsMaximize<cr>", desc = "Zoom", mode = { "n", "t" } } },
    config = function()
      vim.o.winwidth = 5
      vim.o.equalalways = false
      require("windows").setup()
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

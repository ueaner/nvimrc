return {
  -- code actions
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    opts = { sources = {} },
  },

  {
    "aznhe21/actions-preview.nvim",
    event = "LazyFile",
    -- stylua: ignore
    keys = {
      { "ga", function() require("actions-preview").code_actions() end, desc = "Code Action Preview", mode = { "n", "v" } },
    },
    opts = {},
  },

  {
    "kosayoda/nvim-lightbulb",
    event = "LazyFile",
    opts = {
      autocmd = { enabled = true, events = { "CursorHold", "CursorHoldI" } },
    },
  },
}

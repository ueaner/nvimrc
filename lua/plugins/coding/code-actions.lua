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
    opts = {},
  },

  -- {
  --   "kosayoda/nvim-lightbulb",
  --   event = "LazyFile",
  --   opts = {
  --     autocmd = { enabled = true, events = { "CursorHold", "CursorHoldI" } },
  --   },
  -- },
}

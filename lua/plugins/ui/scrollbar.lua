return {
  -- scrollbar
  {
    "lewis6991/satellite.nvim",
    event = "LazyFile",
    opts = {
      excluded_filetypes = U.config.excluded_filetypes,
      current_only = true,
    },
  },
}

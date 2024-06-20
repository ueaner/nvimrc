return {
  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    config = function()
      require("ibl").setup({
        indent = { char = "│", tab_char = "│" },
        scope = { show_start = false, show_end = false },
        exclude = {
          filetypes = U.config.excluded_filetypes,
        },
      })
    end,
  },
}

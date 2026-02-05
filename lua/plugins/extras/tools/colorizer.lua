return {
  -- colorizer
  {
    "catgoose/nvim-colorizer.lua",
    event = "LazyFile",
    opts = {
      filetypes = { "*", "!lazy" },
      buftypes = { "*", "!prompt", "!nofile" },
      -- stylua: ignore
      user_default_options = {
        RGB      = true,  -- #RGB hex codes
        RRGGBB   = true,  -- #RRGGBB hex codes
        names    = false, -- "Name" codes like Blue
        names_custom = vim.g.term_colors,
        RRGGBBAA = true,  -- #RRGGBBAA hex codes
        rgb_fn   = false, -- CSS rgb() and rgba() functions
        hsl_fn   = false, -- CSS hsl() and hsla() functions
        css      = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode     = "background", -- Set the display mode.
      },
    },
  },
}

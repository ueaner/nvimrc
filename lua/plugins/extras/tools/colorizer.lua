return {
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    -- event = { "BufRead", "BufWinEnter", "BufNewFile" },
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftypes = { "*", "!prompt", "!nofile" },
      -- stylua: ignore
      user_default_options = {
        RGB      = true,  -- #RGB hex codes
        RRGGBB   = true,  -- #RRGGBB hex codes
        names    = false, -- "Name" codes like Blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        rgb_fn   = false, -- CSS rgb() and rgba() functions
        hsl_fn   = false, -- CSS hsl() and hsla() functions
        css      = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        tailwind = true,  -- Enable tailwind colors
        mode     = "background", -- Set the display mode.
      },
    },
  },
}

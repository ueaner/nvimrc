return {
  -- colorizer
  {
    "catgoose/nvim-colorizer.lua",
    event = "LazyFile",
    opts = {
      filetypes = {
        dosini = {
          parsers = {
            custom = {
              {
                name = "ini_hex",
                prefixes = { "=" },
                parse = function(ctx)
                  local m = ctx.line:match("^(%x%x%x%x%x%x)%f[^%x]", ctx.col + 1)
                  if m then
                    -- 返回匹配的长度 (=xxxxxx) 和 提取到的颜色值 (xxxxxx)
                    return 7, m
                  end
                end,
              },
            },
          },
        },
        "*",
        "!lazy",
      },
      buftypes = { "*", "!prompt", "!nofile" },
      ---@module 'colorizer'
      ---@type colorizer.NewOptions
      options = {
        parsers = {
          css = true, -- preset: enables names, hex, rgb, hsl, oklch
          tailwind = { enable = true },
          names = {
            enable = true,
            custom = vim.g.term_colors,
          },
        },
      },
    },
  },
}

return {
  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "LazyFile",
    config = function()
      local colors = require("tokyonight.colors").setup()
      local darken = require("tokyonight.util").darken
      require("incline").setup({
        highlight = {
          groups = {
            -- floating winbar default background color same as `TreesitterContext`
            InclineNormal = { guifg = colors.blue, guibg = darken(colors.fg_gutter, 0.8) },
            InclineNormalNC = { guifg = colors.blue },
          },
        },
        window = { margin = { vertical = 0, horizontal = 0 } },
        ---@see incline-render
        ---@alias IncLineRenderProps { buf: number, win: number, focused: boolean }
        ---@param props IncLineRenderProps
        render = function(props)
          local bufnr = props.buf
          local items = {}
          local item = {}

          item = { { "#" .. bufnr } }
          vim.list_extend(items, item)

          -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
          -- local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          -- item = { { " " }, { icon, guifg = color }, { " " }, { filename, guifg = colors.fg } }
          -- vim.list_extend(contents, item, 1, #item)

          local toggles = require("util.toggler").toggles()
          for _, t in ipairs(toggles) do
            item = { { "  " }, { t[2], guifg = (t[3] and colors.orange or colors.blue) } }
            vim.list_extend(items, item)
          end

          return items
        end,
      })
    end,
  },
}

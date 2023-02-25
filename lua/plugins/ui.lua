return {
  -- disable
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "goolord/alpha-nvim", enabled = false },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local function langserver_names()
        return {
          --   stylua, sumneko_lua
          function()
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
              return ""
            end
            local ls = {}
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                table.insert(ls, client.name)
              end
            end
            return table.concat(ls, ", ")
          end,
          icon = " ",
          color = { fg = "cyan" },
        }
      end

      local function treesitter_has_parser()
        return {
          function()
            return "TS"
          end,
          cond = function()
            return package.loaded["nvim-treesitter"] and require("nvim-treesitter.parsers").has_parser()
          end,
          icon = "⦿",
          color = { fg = "lightgreen" },
        }
      end

      --   stylua, sumneko_lua  綠TS
      table.insert(opts.sections.lualine_x, langserver_names())
      table.insert(opts.sections.lualine_x, treesitter_has_parser())

      opts.sections.lualine_y = {
        { "progress", padding = { left = 1, right = 0 }, separator = "" },
        { "location", padding = { left = 1, right = 1 } },
      }
      -- Show current time in tmux statusline
      opts.sections.lualine_z = { "" }
      -- https://github.com/nvim-lualine/lualine.nvim#available-extensions
      -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/extensions
      opts.extensions = { "nvim-tree", "quickfix", "man" }

      -- tabline also displays diagnostics information
    end,
  },

  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guifg = colors.blue },
            InclineNormalNC = { guifg = colors.blue },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local bufnr = props.buf
          local items = {}
          local item = {}

          item = { { "#" .. bufnr } }
          vim.list_extend(items, item, 1, #item)

          -- local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
          -- local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          -- item = { { " " }, { icon, guifg = color }, { " " }, { filename, guifg = colors.fg } }
          -- vim.list_extend(contents, item, 1, #item)

          local toggles = require("utils").toggle.all()
          for _, t in ipairs(toggles) do
            item = { { "  " }, { t[2], guifg = (t[3] and colors.orange or colors.blue) } }
            vim.list_extend(items, item, 1, #item)
          end

          return items
        end,
      })
    end,
  },

  -- terminal
  {
    "NvChad/nvterm",
    keys = {
      -- stylua: ignore
      -- `<Esc><Esc>` enter normal mode, then switch windows
      { "<leader>tt", function() require("nvterm.terminal").toggle("horizontal") end, desc = "toggle term", mode = { "n", "t" } },
    },
    config = function()
      require("nvterm").setup()
    end,
  },

  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    -- event = { "BufRead", "BufWinEnter", "BufNewFile" },
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
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

  -- scrollbar
  {
    "dstein64/nvim-scrollview",
    event = "BufReadPre",
    opts = {
      excluded_filetypes = { "alpha", "NvimTree", "Outline", "aerial" },
      current_only = true,
      winblend = 75,
    },
  },
}

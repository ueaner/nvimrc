return {
  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<Right>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i"}},
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<Left>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i"}},
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"n", "s"}},
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"n", "s"}},

      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<Del>" end end, silent = true, expr = true, desc = "Scroll down", mode = {"i"}},
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<C-G>u<C-U>" end end, silent = true, expr = true, desc = "Scroll up", mode = {"i"}},
      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, silent = true, expr = true, desc = "Scroll down", mode = {"n", "s"}},
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, silent = true, expr = true, desc = "Scroll up", mode = {"n", "s"}},
    },
  },

  -- bufferline
  --{
  --  "akinsho/bufferline.nvim",
  --  event = "VeryLazy",
  --  opts = {
  --    options = {
  --      -- stylua: ignore
  --      close_command = function(n) require("utils.buf").close(n) end,
  --      -- stylua: ignore
  --      right_mouse_command = function(n) require("utils.buf").close(n) end,
  --      diagnostics = "nvim_lsp",
  --      always_show_bufferline = false,
  --      diagnostics_indicator = function(_, _, diag)
  --        local icons = require("lazyvim.config").icons.diagnostics
  --        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
  --          .. (diag.warning and icons.Warn .. diag.warning or "")
  --        return vim.trim(ret)
  --      end,
  --      offsets = {
  --        {
  --          filetype = "NvimTree",
  --          text = function() -- try empty string
  --            return vim.fn.getcwd()
  --          end,
  --          text_align = "left",
  --          highlight = "Directory",
  --        },
  --      },
  --    },
  --  },
  --},

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local colors = require("tokyonight.colors").setup()
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
          color = { fg = colors.cyan },
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
          color = { fg = colors.green },
        }
      end

      local function dap_has_adapter()
        return {
          function()
            return "DAP"
          end,
          cond = function()
            return require("dap").configurations[vim.bo.filetype] ~= nil
          end,
          icon = "",
          color = { fg = colors.blue },
        }
      end

      --   stylua, sumneko_lua  綠TS
      table.insert(opts.sections.lualine_x, langserver_names())
      table.insert(opts.sections.lualine_x, treesitter_has_parser())
      table.insert(opts.sections.lualine_x, dap_has_adapter())

      opts.sections.lualine_y = {
        { "progress", padding = { left = 1, right = 0 }, separator = "" },
        { "location", padding = { left = 1, right = 1 } },
      }
      -- Show current time in tmux statusline
      opts.sections.lualine_z = { "" }
      -- https://github.com/nvim-lualine/lualine.nvim#available-extensions
      -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/extensions
      opts.extensions = { "nvim-tree", "quickfix", "man", "trouble", "nvim-dap-ui" }

      -- tabline also displays diagnostics information
    end,
  },

  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
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

          local toggles = require("utils").toggles()
          for _, t in ipairs(toggles) do
            item = { { "  " }, { t[2], guifg = (t[3] and colors.orange or colors.blue) } }
            vim.list_extend(items, item, 1, #item)
          end

          return items
        end,
      })
    end,
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

  -- smooth scroll
  -- {
  --   "karb94/neoscroll.nvim",
  --   config = function(_, opts)
  --     require("neoscroll").setup(opts)
  --   end,
  -- },

  -- auto detect indent
  {
    "timakro/vim-yadi",
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        callback = function()
          vim.cmd("DetectIndent")
        end,
      })
    end,
  },
}

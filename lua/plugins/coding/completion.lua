return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "rafamadriz/friendly-snippets" },
      { "garymjr/nvim-snippets", opts = { friendly_snippets = true } },
    },
    opts = function(_, opts)
      local U = require("utils")
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      vim.api.nvim_set_hl(0, "CmpFloatBorder", { fg = U.fg("FloatBorder"), bg = U.bg("Normal"), default = true })

      local cmp = require("cmp")
      local border = {
        winhighlight = "Normal:Normal,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
        -- border = "single",
      }

      if type(vim.snippet) == "table" then
        opts.snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        }
      end

      ---@return cmp.ConfigSchema
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<A-.>"] = cmp.mapping.complete(),
          ["<A-,>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        -- :CmpStatus describes statuses and states of sources.
        sources = {
          { name = "nvim_lsp", group_index = 1 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "snippets", group_index = 2 },
        },

        ---@type cmp.FormattingConfig
        formatting = {
          format = function(_, item)
            -- Maximum length of extra text for popup menu is 40
            if type(item.menu) == "string" and string.len(item.menu) > 40 then
              item.menu = string.sub(item.menu, 1, 40) .. "..."
            end

            local icons = require("config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(border),
          ---@type cmp.WindowConfig
          documentation = cmp.config.window.bordered(border),
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      }
    end,
  },
  keys = function()
    if type(vim.snippet) == "table" then
      return {
        {
          "<Tab>",
          function()
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
              return
            end
            return "<Tab>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          end,
          silent = true,
          mode = "s",
        },
        {
          "<S-Tab>",
          function()
            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
              return
            end
            return "<S-Tab>"
          end,
          expr = true,
          silent = true,
          mode = { "i", "s" },
        },
      }
    end
  end,

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    enabled = type(vim.snippet) == "nil", -- nvim 0.10.0-
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}

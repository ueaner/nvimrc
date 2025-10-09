return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
          global_snippets = { "all", "global" },
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function(_, opts)
      -- Register nvim-cmp lsp capabilities
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      vim.api.nvim_set_hl(0, "CmpFloatBorder", { fg = U.ui.fg("FloatBorder"), bg = U.ui.bg("Normal"), default = true })

      local cmp = require("cmp")
      local border = {
        winhighlight = "Normal:Normal,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
        -- border = "single",
      }

      opts.snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      }

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
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "snippets" }, -- nvim-snippets
        },

        ---@type cmp.FormattingConfig
        formatting = {
          format = function(_, item)
            -- Maximum length of extra text for popup menu is 40
            local width = U.config.sidebar.width
            if type(item.menu) == "string" and string.len(item.menu) > width then
              item.menu = string.sub(item.menu, 1, width) .. "..."
            end

            local icons = U.config.icons.kinds
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
}

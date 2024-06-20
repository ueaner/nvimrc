return {
  -- Code outline sidebar powered by Treesitter or LSP.
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    cmd = "AerialToggle",
    opts = function()
      vim.api.nvim_set_hl(0, "AerialLine", { bg = U.ui.bg("CursorLine"), fg = U.ui.fg("Title") })

      local icons = vim.deepcopy(U.config.icons.kinds)

      -- HACK: fix lua's weird choice for `Package` for control
      -- structures like if/else/for/etc.
      icons.lua = { Package = icons.Control }

      ---@type table<string, string[]>|false
      local filter_kind = false
      if U.config.kind_filter then
        filter_kind = assert(vim.deepcopy(U.config.kind_filter))
        filter_kind._ = filter_kind.default
        filter_kind.default = nil
      end

      local opts = {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          resize_to_content = false,
          min_width = 40,
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "yes",
            statuscolumn = " ",
          },
        },
        icons = icons,
        filter_kind = filter_kind,
      }
      return opts
    end,
  },

  -- Code outline sidebar powered by LSP, a properly configured LSP client is required.
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {},
        symbol_blacklist = {},

        outline_items = {
          show_symbol_details = false,
        },
        outline_window = {
          position = "right",
          width = 40,
          relative_width = false,
        },
        keymaps = {
          show_help = "?",
          close = { "<esc>", "q" },
          goto_location = "<cr>",
          peek_location = "<tab>",
          goto_and_close = "<S-cr>",
          restore_location = "<C-g>",
          hover_symbol = "K",
          toggle_preview = "P",
          rename_symbol = "r",
          code_actions = "a",
          fold_toggle = "o",
          fold_toggle_all = "O",
          fold_reset = "R",
          down_and_jump = "<C-j>",
          up_and_jump = "<C-k>",
          fold = "<space>", -- Fold symbol or parent symbol
          unfold = nil,
          fold_all = nil,
          unfold_all = nil,
        },
      }
      local filter = U.config.kind_filter

      if type(filter) == "table" then
        filter = filter.default
        if type(filter) == "table" then
          for kind, symbol in pairs(defaults.symbols) do
            opts.symbols[kind] = {
              icon = U.config.icons.kinds[kind] or symbol.icon,
              hl = symbol.hl,
            }
            if not vim.tbl_contains(filter, kind) then
              table.insert(opts.symbol_blacklist, kind)
            end
          end
        end
      end
      return opts
    end,
  },
}

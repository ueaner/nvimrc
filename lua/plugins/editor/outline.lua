local C = require("config")
local UInject = require("utils.inject")

return {
  -- outline
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    cmd = "AerialToggle",
    keys = { { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Outline" } },
    opts = function()
      ---@diagnostic disable-next-line: no-unknown
      local lualine = require("lualine.components.aerial")

      -- Strip trailing spaces from symbols in statusline
      ---@param _ any
      ---@param symbols {icon?:string}[]
      lualine.format_status = UInject.args(lualine.format_status, function(_, symbols)
        for _, s in ipairs(symbols) do
          s.icon = s.icon and s.icon:gsub("%s*$", "") or nil
        end
      end)

      local icons = vim.deepcopy(C.icons.kinds)

      -- HACK: fix lua's weird choice for `Package` for control
      -- structures like if/else/for/etc.
      icons.lua = { Package = icons.Control }

      ---@type table<string, string[]>|false
      local filter_kind = false
      if C.kind_filter then
        filter_kind = assert(vim.deepcopy(C.kind_filter))
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
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      }
      return opts
    end,
  },
}

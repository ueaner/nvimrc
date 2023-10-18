return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- PERF: No need for lualine require under lazyvim
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("config").icons
      local U = require("utils")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1 },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = { fg = U.fg("Statement") },
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = { fg = U.fg("Constant") },
            },
            -- stylua: ignore
            {
              function() return icons.general.debugging .. "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = { fg = U.fg("Debug") },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = U.fg("Special") },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                ---@type table<string, number|string>
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },

          lualine_y = {
            { "progress", padding = { left = 1, right = 0 }, separator = "" },
            { "location", padding = { left = 0, right = 1 } },
          },

          -- Show current time in tmux statusline
          lualine_z = {
            function()
              return vim.fn.line("$")
            end,
          },
        },
        -- https://github.com/nvim-lualine/lualine.nvim#available-extensions
        -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/extensions
        extensions = { "lazy", "mason", "neo-tree", "aerial", "quickfix", "man", "trouble", "nvim-dap-ui" },
      }
    end,
  },
}

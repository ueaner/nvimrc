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

      local function langserver_names()
        return {
          function()
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
              return ""
            end
            local ls = {}
            local bufnr = vim.api.nvim_get_current_buf()
            for _, client in ipairs(clients) do
              if client.attached_buffers[bufnr] then
                table.insert(ls, client.name)
              end
            end
            return table.concat(ls, ", ")
          end,
          icon = icons.general.lsp,
          color = { fg = U.fg("Operator") },
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
          icon = icons.general.treesitter,
          color = { fg = U.fg("String") },
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
          icon = icons.general.dap,
          color = { fg = U.fg("Special") },
        }
      end

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
            },
            langserver_names(),
            treesitter_has_parser(),
            dap_has_adapter(),
          },
          lualine_y = {
            { "progress", padding = { left = 1, right = 0 }, separator = "" },
            { "location", padding = { left = 1, right = 1 } },
          },

          -- Show current time in tmux statusline
          -- lualine_z = {
          --   function()
          --     return " " .. os.date("%R")
          --   end,
          -- },
        },
        -- https://github.com/nvim-lualine/lualine.nvim#available-extensions
        -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/extensions
        extensions = { "lazy", "nvim-tree", "neo-tree", "quickfix", "man", "trouble", "nvim-dap-ui" },
      }
    end,
  },
}

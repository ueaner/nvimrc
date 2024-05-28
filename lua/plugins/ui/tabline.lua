return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) U.ui.close(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) U.ui.close(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        -- offsets = {
        --   {
        --     filetype = "neo-tree",
        --     text = "File Explorer",
        --     text_align = "left",
        --     highlight = "Directory",
        --   },
        -- },
      },
    },
  },
}

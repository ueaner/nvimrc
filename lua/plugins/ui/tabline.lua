return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "LazyFile",
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) U.ui.bufremove(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) U.ui.bufremove(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = U.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            text_align = "left",
            highlight = "Normal",
          },
        },
      },
    },
  },
}

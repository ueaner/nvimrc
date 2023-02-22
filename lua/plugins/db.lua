return {
  -- database explorer
  -- dependencies command line client: mysql-client, psql(postgresql client), sqlite3, redis-cli
  {
    "tpope/vim-dadbod",
    event = "VeryLazy",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
      },
    },
    cmd = { "DB" },
    keys = {
      -- stylua: ignore
      { "<leader>E", function() require("utils").toggle.db_explorer() end, desc = "Toggle UI", },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dbui"
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 40
      vim.g.db_ui_notification_width = 36
    end,
    config = function()
      require("utils").on_ft("dbui", function()
        -- 提示信息展示：只改变前景色和边框（如果支持边框的话，线条）
        vim.api.nvim_set_hl(0, "NotificationInfo", { link = "Normal" })
        vim.api.nvim_set_hl(0, "NotificationError", { link = "ErrorMsg" })
        vim.api.nvim_set_hl(0, "WarningMsg", { link = "WarningMsg" })
      end)
    end,
  },
}

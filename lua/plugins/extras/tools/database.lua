local M = {}

M.fe = function()
  if require("utils").has("neo-tree.nvim") then
    return {
      is_visible = function()
        local state = require("neo-tree.sources.manager").get_state("filesystem")
        return require("neo-tree.ui.renderer").tree_is_visible(state)
      end,
      open = function()
        -- Opening is slower than NvimTree
        require("neo-tree.command").execute({ action = "show" })
      end,
      close = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
      toggle = function()
        require("neo-tree.command").execute({ toggle = true, dir = require("utils").get_root() })
      end,
    }
  end
  -- Default is NvimTree
  return {
    is_visible = function()
      return require("nvim-tree.view").is_visible()
    end,
    open = function()
      vim.cmd.NvimTreeOpen()
    end,
    close = function()
      vim.cmd.NvimTreeClose()
    end,
    toggle = function()
      vim.cmd.NvimTreeToggle()
    end,
  }
end

-- database explorer toggle / restore file explorer state
--
--  Actual test conclusion: first close and then open, less side effects
--  DE(database explorer) FE(file explorer)
--    DE   FE     doings
--    on   on     close DE
--    on   off    close DE, open? FE (stored state is open then reopen file explorer)
--    off  off    open DE
--    off  on     open DE, close FE
--
M.db_explorer_toggle = function()
  local fe = M.fe()
  -- current state
  local deOpened = M.dbui_is_visible()
  local feOpened = fe.is_visible()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local feOpenedName = "feOpened"

  if deOpened then -- close DE, check FE state
    local ok, feOpenedOld = pcall(vim.api.nvim_tabpage_get_var, tabnr, feOpenedName)
    if ok then
      vim.api.nvim_tabpage_del_var(tabnr, feOpenedName)
    else
      feOpenedOld = nil
    end

    vim.cmd.DBUIClose()
    if not feOpened and feOpenedOld then -- reopen FE
      fe.open()
    end
  else -- open DE, set FE state
    vim.api.nvim_tabpage_set_var(tabnr, feOpenedName, feOpened)

    if feOpened then
      fe.close()
    end
    vim.cmd.DBUI()
  end

  -- When `DE(off) FE(on)`, executing `open DE, close FE` page switching is not smooth
  -- vim.cmd.DBUIToggle()
  -- if deOpened ~= feOpened then
  --   fe.toggle()
  -- end
end

-- Checks if dbui is visible.
--
-- Return: ~
--     dbui is visible
--- @return boolean
M.dbui_is_visible = function()
  return require("utils").winnr_by_ft("dbui") > -1
end

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
      { "<leader>E", function() M.db_explorer_toggle() end, desc = "Toggle Database Explorer", },
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

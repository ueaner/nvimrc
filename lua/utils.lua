-- ~/.config/nvim/lua/utils.lua
-- require("utils").buf.close_others()

-- NOTE: :help CTRL-W_o  close other windows

local M = {
  buf = {},
  daptest = {},
  toggle = {},
}

M.buf.valid = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

M.buf.modified = function(bufnr)
  return vim.bo[bufnr].modified
end

-- close other buffers under current window
M.buf.close_others = function()
  local bufs = vim.api.nvim_list_bufs()
  local currBuf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(bufs) do
    if buf ~= currBuf and M.buf.valid(buf) and not M.buf.modified(buf) then
      vim.cmd("bd " .. buf)
    end
  end
end

M.toggle.all = function()
  -- stylua: ignore
  return {
    -- fscp
    { "fold",      "", vim.opt.foldenable:get() },
    { "spell",     "", vim.opt.spell:get() },
    { "clipboard", "", vim.tbl_contains(vim.opt.clipboard:get(), "unnamedplus") },
    { "paste",     "", vim.opt.paste:get() },
  }
end

M.toggle.clipboard = function()
  if vim.tbl_contains(vim.opt.clipboard:get(), "unnamedplus") then
    vim.opt.clipboard = ""
  else
    vim.opt.clipboard = "unnamedplus"
  end
end

M.toggle.all_to_winbar = function()
  local colors = require("tokyonight.colors").setup()
  local wb = {}
  local tmp = {}

  local toggles = M.toggle.all()
  for _, item in ipairs(toggles) do
    tmp = { { "  " }, { item[2], guifg = (item[3] and colors.orange or colors.blue) } }
    vim.list_extend(wb, tmp, 1, #tmp)
  end

  return wb
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
M.toggle.db_explorer = function()
  -- current state
  local deOpened = M.toggle.dbui_is_visible()
  local feOpened = require("nvim-tree.view").is_visible()
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
      vim.cmd.NvimTreeOpen()
    end
  else -- open DE, set FE state
    vim.api.nvim_tabpage_set_var(tabnr, feOpenedName, feOpened)

    if feOpened then
      vim.cmd.NvimTreeClose()
    end
    vim.cmd.DBUI()
  end

  -- When `DE(off) FE(on)`, executing `open DE, close fe` page switching is not smooth
  -- vim.cmd.DBUIToggle()
  -- if deOpened ~= feOpened then
  --   vim.cmd.NvimTreeToggle()
  -- end
end

-- Checks if dbui is visible.
--
-- Return: ~
--     dbui is visible
--- @return boolean
M.toggle.dbui_is_visible = function()
  return M.winnr_by_filetype("dbui") > -1
end

-- Gets the winnr by filetype..
--
-- Return: ~
--     window number
--- @return integer
M.winnr_by_filetype = function(ft)
  if M.is_empty(ft) or type(ft) ~= "string" then
    return -1
  end

  local wins = vim.api.nvim_list_wins()
  for _, nr in ipairs(wins) do
    if ft == vim.fn.getwinvar(nr, "&filetype") then
      return nr
    end
  end
  return -1
end

-- Create a FileType autocommand event handler.
-- Examples:
-- ```lua
--    require("utils").on_ft("go", function(event)
--    	vim.keymap.set("n", "<leader>dt", function()
--    		require("dap-go").debug_test()
--    	end, { desc = "debug test", buffer = event.buf })
--    end, "daptest")
-- ```
--- @param ft string|array
--- @param cb function|string
--- @param group? string
M.on_ft = function(ft, cb, group)
  local opts = { pattern = ft, callback = cb }
  if not M.is_empty(group) then
    opts["group"] = group
    vim.api.nvim_create_augroup(opts["group"], { clear = false })
  end
  vim.api.nvim_create_autocmd("FileType", opts)
end

M.is_empty = function(s)
  return s == nil or s == ""
end

M.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

return M

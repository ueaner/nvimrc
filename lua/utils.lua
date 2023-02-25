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

-- Close the current buffer without affecting the editor layout
--
--  :echo &buftype &buflisted &modified &modifiable
--
--             buflisted  modified    buftype
--   editor     1          0 | 1      <empty>
--   terminal   0 | 1      0          terminal
--   explorer   0          0          nofile
--   outliner   0          0          nofile
--   others     0          0          help | quickfix | prompt | acwrite | nowrite
--
M.buf.close = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  -- non-buflisted can be closed directly
  if not vim.bo[bufnr].buflisted then
    vim.cmd("bd!" .. bufnr)
    return
  end

  -- buffer listed - File not modified or saved
  if not vim.bo[bufnr].modified then -- switch, close
    vim.cmd("bp | bd!" .. bufnr)
    return
  end

  -- buffer listed - File modified not saved
  --
  --  If choose to `cancel`, not need to switch buffer
  --
  --   #    choice    doings
  --   1    Yes       save, switch, close
  --   2    No        switch, force close
  --   3    Cancel    do nothing
  --
  -- So here is a simplified version of `:confirm bd bufnr`
  local msg = string.format('Save changes to "%s"?', vim.api.nvim_buf_get_name(bufnr))
  local choice = vim.fn.confirm(msg, "&Yes\n&No\n&Cancel", 1)
  if choice == 1 then
    vim.cmd("update | bp | bd" .. bufnr)
  elseif choice == 2 then
    vim.cmd("bp | bd!" .. bufnr)
  elseif choice == 3 then
    vim.api.nvim_echo(
      { { "E516", "WarningMsg" }, { ": No buffers were deleted: utils.buf.close()", "None" } },
      false,
      {}
    )
  end
end

-- close other buffers under current window
M.buf.close_others = function()
  local bufnrs = vim.api.nvim_list_bufs()
  local currBufnr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(bufnrs) do
    if bufnr ~= currBufnr and M.buf.valid(bufnr) and not M.buf.modified(bufnr) then
      vim.cmd("bd " .. bufnr)
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
--- @param ft string|string[]
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

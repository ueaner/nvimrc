-- ~/.config/nvim/lua/utils.lua

local M = {}

-- Gets the winnr by filetype..
--
-- Return: ~
--     window number
--- @return integer
M.winnr_by_ft = function(ft)
  if M.str_isempty(ft) or type(ft) ~= "string" then
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
--      vim.keymap.set("n", "<leader>dt", function()
--        require("dap-go").debug_test()
--      end, { desc = "debug test", buffer = event.buf })
--    end, "daptest")
-- ```
--- @param ft string|string[]
--- @param cb function|string
--- @param group? string
M.on_ft = function(ft, cb, group)
  local opts = { pattern = ft, callback = cb }
  if not M.str_isempty(group) then
    opts["group"] = group
    vim.api.nvim_create_augroup(opts["group"], { clear = false })
  end
  vim.api.nvim_create_autocmd("FileType", opts)
end

M.str_isempty = function(s)
  return s == nil or s == ""
end

--- Extends a list-like table with the values of another list-like table.
---
---@see vim.tbl_extend()
---
---@param dst table List which will be modified and appended to
---@param src table List from which values will be inserted
---@param start? number Start index on src. Defaults to 1
---@param finish? number Final index on src. Defaults to `#src`
---@return table dst
M.list_extend = function(dst, src, start, finish)
  if type(dst) ~= "table" or type(src) ~= "table" then
    return dst
  end

  for i = start or 1, finish or #src do
    table.insert(dst, src[i])
  end
  return dst
end

--- Removes `item` from `list` by value, returning the removed `list`.
---@generic T
---@param list T[]
---@param item T
---@return T
M.list_remove = function(list, item)
  for i, v in ipairs(list) do
    if v == item then
      table.remove(list, i)
      return list
    end
  end
  return list
end

--- Gets the highlight `fg` or `bg` color by name.
---@param group string Highlight group name
---@param attr "fg"|"bg"
M.hl_color = function(group, attr)
  -- neovim 0.9.0+: vim.api.nvim_get_hl()
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
  if not ok or not hl or not hl[attr] then
    return
  end
  return string.format("#%06x", hl[attr])
end

M.toggles = function()
  -- stylua: ignore
  return {
    -- fscp
    { "fold",      "", vim.opt_local.foldenable:get() },
    { "spell",     "", vim.opt_local.spell:get() },
    { "clipboard", "", vim.tbl_contains(vim.opt_local.clipboard:get(), "unnamedplus") },
    { "paste",     "", vim.opt_local.paste:get() },
  }
end

M.clipboard_toggle = function()
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
M.db_explorer_toggle = function()
  -- current state
  local deOpened = M.dbui_is_visible()
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
M.dbui_is_visible = function()
  return M.winnr_by_ft("dbui") > -1
end

-- M.dump = function(...)
--   local objects = vim.tbl_map(vim.inspect, { ... })
--   print(unpack(objects))
-- end

return M

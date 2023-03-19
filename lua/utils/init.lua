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

--- Gets the highlight `foreground` or `background` color by name.
---@param group string Highlight group name
---@param attr "foreground"|"background"
M.hl_color = function(group, attr)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
  if not ok or not hl[attr] then
    return
  end
  return string.format("#%06x", hl[attr])
end

--- Create window that takes up certain percentags of the current screen.
--
-- from: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/info.lua#L11
--
-- Examples:
-- ```lua
--    local win_bufnr, win_id = make_window(lines)
--    local win_bufnr, win_id = make_window(lines, 0.5, 0.6)
--    -- Custom border highlight style
--    vim.api.nvim_win_set_option(win_id, "winhl", "FloatBorder:XxxInfoBorder")
-- ```
--- @param lines string[]
--- @param height_percentage? number
--- @param width_percentage? number
M.make_window = function(lines, height_percentage, width_percentage)
  height_percentage = height_percentage or 0.5
  width_percentage = width_percentage or 0.6
  local row_start_percentage = (1 - height_percentage) / 2
  local col_start_percentage = (1 - width_percentage) / 2

  local row = math.ceil(vim.o.lines * row_start_percentage)
  local col = math.ceil(vim.o.columns * col_start_percentage)
  local width = math.floor(vim.o.columns * width_percentage)
  local height = math.ceil(vim.o.lines * height_percentage)

  local opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "solid",
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  local win_id = vim.api.nvim_open_win(bufnr, true, opts)
  vim.api.nvim_win_set_buf(win_id, bufnr)

  -- define the buffer properties
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  -- vim.api.nvim_buf_set_option(bufnr, "filetype", "buf42")

  -- close buffer
  local close = function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
    if vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_win_close(win_id, true)
    end
  end

  vim.keymap.set("n", "<ESC>", close, { buffer = bufnr, nowait = true })
  vim.keymap.set("n", "q", close, { buffer = bufnr, nowait = true })
  vim.api.nvim_create_autocmd({ "BufHidden", "BufLeave", "BufDelete" }, {
    buffer = bufnr,
    once = true,
    callback = close,
  })

  return bufnr, win_id
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

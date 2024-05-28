---@class util.ui
local M = {}

--- Gets the highlight `fg` or `bg` color by name.
---@param group string Highlight group name
---@param attr "fg"|"bg"
M.color = function(group, attr)
  -- neovim 0.9.0+: vim.api.nvim_get_hl()
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if not hl or not hl[attr] then
    return
  end
  return string.format("#%06x", hl[attr])
end

function M.fg(name)
  return M.color(name, "fg")
end

function M.bg(name)
  return M.color(name, "bg")
end

---@param buf number?
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then -- Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

M.valid = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

M.modified = function(bufnr)
  return vim.bo[bufnr].modified
end

-- Close the current buffer without affecting the editor layout
--
--             buflisted  modified    buftype
--   editor     1          0 | 1      <empty>
--   terminal   0 | 1      0          terminal
--   explorer   0          0          nofile
--   outliner   0          0          nofile
--   others     0          0          help | quickfix | prompt | acwrite | nowrite
--
--- @param bufnr? integer see |bufnr()|, default: 0 for current.
--- @param force? boolean force close
M.close = function(bufnr, force)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  force = force or false
  -- non-buflisted
  if not vim.bo[bufnr].buflisted then
    if vim.bo[bufnr].buftype == "terminal" then
      -- hide terminal buffer
      vim.cmd("hide")
    else
      -- delete normal buffer
      vim.cmd("bd!" .. bufnr)
    end
    return
  end

  -- buffer listed - File not modified or saved
  if not vim.bo[bufnr].modified then -- switch, close
    vim.cmd("bp | bd" .. bufnr)
    return
  end

  -- force close
  if force then
    vim.cmd("update | bp | bd" .. bufnr)
    return
  end

  -- buffer listed - File modified not saved
  --
  --  If choose to `cancel`, not need to switch buffer
  --
  --   #    choice    doing
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
    vim.api.nvim_echo({ { "E516", "WarningMsg" }, { ": No buffers were deleted: util.ui.close()", "None" } }, false, {})
  end
end

-- close other buffers under current window
-- NOTE: :help CTRL-W_o close other windows
M.close_others = function()
  local bufnrs = vim.api.nvim_list_bufs()
  local currBufnr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(bufnrs) do
    if bufnr ~= currBufnr and M.valid(bufnr) and not M.modified(bufnr) then
      vim.cmd("bd " .. bufnr)
    end
  end
end

-- Display buffer information in a floating window
M.bufinfo = function()
  U.bufinfo()
end

return M

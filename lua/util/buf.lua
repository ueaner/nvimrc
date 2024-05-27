-- require("util.buf").close()
local M = {}

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
    vim.api.nvim_echo(
      { { "E516", "WarningMsg" }, { ": No buffers were deleted: util.buf.close()", "None" } },
      false,
      {}
    )
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
M.info = function()
  require("util.buf.info")()
end

return M

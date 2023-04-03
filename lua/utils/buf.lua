-- require("utils.buf").close()
local M = {}

M.valid = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

M.modified = function(bufnr)
  return vim.bo[bufnr].modified
end

-- Display buffer information in a floating window
M.info = function()
  local vtype = "info42"
  if vim.bo.filetype == vtype then
    print("This buffer is an info window")
    return
  end

  -- buffer options or window options
  local options = { "filetype", "buftype", "buflisted", "modified", "modifiable", "conceallevel" }
  local toggles = require("utils").toggles()

  local lines = {}
  local l = ""

  -- Options
  table.insert(lines, "Options")
  for _, o in ipairs(options) do
    local v = vim.opt_local[o]:get()
    local s = ""
    if type(v) == "string" then
      s = v ~= "" and v or "<empty>"
    elseif type(v) == "boolean" then
      s = tostring(v)
    else
      s = vim.inspect(v)
    end
    l = string.format("- %s: %s", o, s)
    table.insert(lines, l)
  end

  -- Toggles
  table.insert(lines, "")
  table.insert(lines, "Toggles")
  for _, t in ipairs(toggles) do
    l = string.format(" %s %s: %s", t[2], t[1], tostring(t[3]))
    table.insert(lines, l)
  end

  -- LSP servers
  -- DAP adapters
  -- TS parsers

  -- MORE

  local win_bufnr, _ = require("utils.floatwin").make(lines)
  vim.api.nvim_buf_set_option(win_bufnr, "filetype", vtype)
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
M.close = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
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

return M

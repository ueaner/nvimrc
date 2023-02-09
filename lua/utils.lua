-- ~/.config/nvim/lua/utils.lua
-- require("utils").buf.close_others()

-- NOTE: :help CTRL-W_o  close other windows

local daptest_augroup = "daptest"
-- lua library is only required once
vim.api.nvim_create_augroup(daptest_augroup, { clear = true })

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

M.daptest.on_ft = function(ft, cb)
  vim.api.nvim_create_autocmd("FileType", {
    group = daptest_augroup,
    pattern = ft,
    callback = cb,
  })
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

-- winbar 更新频繁做数组合并操作
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

M.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

return M

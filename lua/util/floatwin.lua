local M = {}

--- Create window that takes up certain percentags of the current screen.
--
-- reference: https://github.com/nvimtools/none-ls.nvim/blob/main/lua/null-ls/info.lua#L11
--
-- Examples:
-- ```lua
--    local bufnr, winid = make_window(lines)
--    local bufnr, winid = make_window(lines, 0.5, 0.6)
--    local bufnr, winid = make_window(lines, 0.5, 0.6, "q")
--    -- Custom filetype
--    vim.bo[bufnr]["filetype"] = "buf42"
--    -- Custom border highlight style
--    vim.wo[winid]["winhl"] = "FloatBorder:XxxInfoBorder"
-- ```
--
--- @param lines string[] floating window contents
--- @param height_percentage? number centered window as a percentage of screen height, default is 0.5
--- @param width_percentage? number centered window as a percentage of screen width, default is 0.6
--- @param close_keys string[]? close floating window keymap, default is { "<ESC>", "q" }
--- @return integer bufnr bufnr for floating window
--- @return integer winid winid for floating window
M.make = function(lines, height_percentage, width_percentage, close_keys)
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
    border = "rounded",
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  local winid = vim.api.nvim_open_win(bufnr, true, opts)
  vim.api.nvim_win_set_buf(winid, bufnr)

  -- define the buffer properties
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.bo[bufnr]["modifiable"] = false
  vim.bo[bufnr]["buflisted"] = false
  vim.bo[bufnr]["bufhidden"] = "hide"
  vim.bo[bufnr]["buftype"] = "nofile"
  -- vim.bo[bufnr]["filetype"] = "buf42"

  -- close floating window keymap
  M.close_keymap_set(bufnr, winid, close_keys)

  return bufnr, winid
end

--- Set the keymap to close the floating window, default is: "<ESC>" and "q"
--
--- @param bufnr integer bufnr for floating window
--- @param winid integer winid for floating window
--- @param keys? string[] close floating window keymap, default is { "<ESC>", "q" }
M.close_keymap_set = function(bufnr, winid, keys)
  keys = keys or { "<ESC>", "q" }

  local close = function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
  end

  -- vim.keymap.set("n", "<ESC>", close, { buffer = bufnr, nowait = true })
  -- vim.keymap.set("n", "q", close, { buffer = bufnr, nowait = true })
  for i = 1, #keys do
    vim.keymap.set("n", keys[i], close, { buffer = bufnr, nowait = true })
  end

  vim.api.nvim_create_autocmd({ "BufHidden", "BufLeave", "BufDelete" }, {
    buffer = bufnr,
    once = true,
    callback = close,
  })
end

return M

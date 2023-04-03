local M = {}

--- Create window that takes up certain percentags of the current screen.
--
-- reference: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/info.lua#L11
--
-- Examples:
-- ```lua
--    local win_bufnr, win_id = make_window(lines)
--    local win_bufnr, win_id = make_window(lines, 0.5, 0.6)
--    local win_bufnr, win_id = make_window(lines, 0.5, 0.6, "q")
--    -- Custom filetype
--    vim.api.nvim_buf_set_option(win_id, "filetype", "buf42")
--    -- Custom border highlight style
--    vim.api.nvim_win_set_option(win_id, "winhl", "FloatBorder:XxxInfoBorder")
-- ```
--- @param lines string[] floating window contents
--- @param height_percentage? number centered window as a percentage of screen height, default is 0.5
--- @param width_percentage? number centered window as a percentage of screen width, default is 0.6
--- @param close_keys string[]? close floating window keymap, default is { "<ESC>", "q" }
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
  local win_id = vim.api.nvim_open_win(bufnr, true, opts)
  vim.api.nvim_win_set_buf(win_id, bufnr)

  -- define the buffer properties
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  -- vim.api.nvim_buf_set_option(bufnr, "filetype", "buf42")

  -- close floating window keymap
  M.close_keymap_set(bufnr, win_id, close_keys)

  return bufnr, win_id
end

--- Set the keymap to close the floating window, default is: "<ESC>" and "q"
--
--- @param bufnr integer bufnr for floating window
--- @param win_id integer win_id for floating window
--- @param keys? string[] close floating window keymap, default is { "<ESC>", "q" }
M.close_keymap_set = function(bufnr, win_id, keys)
  keys = keys or { "<ESC>", "q" }

  local close = function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
    if vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_win_close(win_id, true)
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

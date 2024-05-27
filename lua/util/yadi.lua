-- lua of https://github.com/timakro/vim-yadi/blob/main/plugin/yadi.vim

local M = {}

function M.detect_indent()
  local tabbed = 0
  local spaced = 0
  local indents = {}
  local lastwidth = 0
  --  Get the first 1000 lines
  local count = vim.api.nvim_buf_line_count(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, count < 1000 and count or 1000, false)
  for _, line in ipairs(lines) do
    if line:sub(1, 1) == "\t" then
      tabbed = tabbed + 1
    else
      -- The position of the first non-space character is the indentation width.
      -- > Sometimes stdout/stderr is redirected to a file and the "^@" null character is written
      -- >  call match() will throw `Vim:E976: Using a Blob as a String`
      local ok, width = pcall(vim.fn.match, line, "[^ ]")
      if not ok then
        return
      end
      -- local width = vim.fn.match(line, "[^ ]")
      if width ~= -1 then
        if width > 0 then
          spaced = spaced + 1
        end
        local indent = width - lastwidth
        if indent >= 2 then -- Minimum indentation is 2 spaces
          indents[indent] = indents[indent] or 1
        end
        lastwidth = width
      end
    end
  end

  local total = 0
  local max = 0
  local winner = -1
  for indent, n in pairs(indents) do
    total = total + n
    if n > max then
      max = n
      winner = indent
    end
  end

  if tabbed > spaced * 4 then -- Over 80% tabs
    local s = string.format("setlocal noexpandtab shiftwidth=%d softtabstop=%d", 0, 0)
    LazyUtil.debug(s, { title = "Detect Indent (tab)" })
    vim.cmd(s)
  elseif spaced > tabbed * 4 and max * 5 > total * 3 then
    -- Detected over 80% spaces and the most common indentation level makes
    -- up over 60% of all indentations in the file.
    local s = string.format("setlocal expandtab shiftwidth=%d softtabstop=%d", winner, winner)
    LazyUtil.debug(s, { title = "Detect Indent (space)" })
    vim.cmd(s)
  end
end

return M

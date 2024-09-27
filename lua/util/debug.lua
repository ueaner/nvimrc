-- https://github.com/folke/dot/blob/master/nvim/lua/util/debug.lua

local M = {}

function M.get_loc()
  local me = debug.getinfo(1, "S")
  local level = 2
  local info = debug.getinfo(level, "S")
  while info and (info.source == me.source or info.source == "@" .. vim.env.MYVIMRC or info.what ~= "Lua") do
    level = level + 1
    info = debug.getinfo(level, "S")
  end
  info = info or me
  local source = info.source:sub(2)
  source = vim.uv.fs_realpath(source) or source
  return source .. ":" .. info.linedefined
end

---@param value any
---@param opts? {loc:string, bt?:boolean}
function M._dump(value, opts)
  opts = opts or {}
  opts.loc = opts.loc or M.get_loc()
  if vim.in_fast_event() then
    return vim.schedule(function()
      M._dump(value, opts)
    end)
  end
  opts.loc = vim.fn.fnamemodify(opts.loc, ":~:.")
  local msg = vim.inspect(value)
  if opts.bt then
    msg = msg .. "\n" .. debug.traceback("", 2)
  end
  vim.notify(msg, vim.log.levels.INFO, {
    title = "Debug: " .. opts.loc,
    on_open = function(win)
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, "lua") then
        vim.bo[buf].filetype = "lua"
      end
    end,
  })
end

function M.dump(...)
  local value = { ... }
  if vim.tbl_isempty(value) then
    value = nil
  elseif vim.islist(value) and vim.tbl_count(value) <= 1 then
    value = value[1]
  end
  M._dump(value)
end

function M.get_value(...)
  local value = { ... }
  return vim.islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
end

function M.is_debug()
  return require("vim.lsp.log").get_level() == vim.log.levels.DEBUG
end

function M.set_debug()
  vim.log.set_level(vim.log.levels.DEBUG)
end

function M.setup()
  _G.dump = function(...)
    M.dump(...)
  end

  vim.print = _G.dump
  _G.is_debug = M.is_debug
end

return M

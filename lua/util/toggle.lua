---@class util.toggle
local M = {}

---@class util.Toggle
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)

---@class util.Toggle.wrap: util.Toggle
---@operator call:boolean

---@param toggle util.Toggle
function M.wrap(toggle)
  return setmetatable(toggle, {
    __call = function()
      toggle.set(not toggle.get())
      local state = toggle.get()
      if state then
        LazyUtil.info("Enabled " .. toggle.name, { title = toggle.name })
      else
        LazyUtil.warn("Disabled " .. toggle.name, { title = toggle.name })
      end
      return state
    end,
  }) --[[@as util.Toggle.wrap]]
end

---@param lhs string
---@param toggle util.Toggle
function M.map(lhs, toggle)
  local t = M.wrap(toggle)
  -- stylua: ignore
  U.safe_keymap_set("n", lhs, function() t() end, { desc = "Toggle " .. toggle.name })
  M.wk(lhs, toggle)
end

---@param lhs string
---@param toggle util.Toggle
function M.wk(lhs, toggle)
  require("which-key").add({
    {
      lhs,
      icon = function()
        return toggle.get() and { icon = " ", color = "green" } or { icon = " ", color = "yellow" }
      end,
      desc = function()
        return (toggle.get() and "Disable " or "Enable ") .. toggle.name
      end,
    },
  })
end

M.treesitter = M.wrap({
  name = "Treesitter Highlight",
  get = function()
    return vim.b.ts_highlight
  end,
  set = function(state)
    if state then
      vim.treesitter.start()
    else
      vim.treesitter.stop()
    end
  end,
})

---@param buf? boolean
function M.format(buf)
  return M.wrap({
    name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
    get = function()
      if not buf then
        return vim.g.autoformat == nil or vim.g.autoformat
      end
      return U.format.enabled()
    end,
    set = function(state)
      U.format.enable(state, buf)
    end,
  })
end

---@param opts? {values?: {[1]:any, [2]:any}, name?: string}
function M.option(option, opts)
  opts = opts or {}
  local name = opts.name or option
  local on = opts.values and opts.values[2] or true
  local off = opts.values and opts.values[1] or false
  return M.wrap({
    name = name,
    get = function()
      -- We cannot use == to compare tables, but we can use vim.deep_equal
      -- return vim.deep_equal(vim.opt_local[option]:get(), on)
      -- return vim.opt_local["clipboard"]:get() == on
      return vim.o[option] == on
    end,
    set = function(state)
      vim.opt_local[option] = state and on or off
    end,
  })
end

M.diagnostics = M.wrap({
  name = "Diagnostics",
  get = vim.diagnostic.is_enabled,
  set = function(state)
    vim.diagnostic.enable(state)
  end,
})

M.inlay_hints = M.wrap({
  name = "Inlay Hints",
  get = function()
    return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  end,
  set = function(state)
    vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
  end,
})

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

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M

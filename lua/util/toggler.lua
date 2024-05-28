---@class util.toggler
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  -- custom option
  -- local fn = "toggle_" .. option
  -- if type(M[fn]) == "function" then
  --   return M[fn](silent, values)
  -- end

  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return LazyUtil.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()

  if not silent then
    if vim.opt_local[option]:get() then
      LazyUtil.info("Enabled " .. option, { title = "Option" })
    else
      LazyUtil.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

---@param buf? number nil get global, 0 current, otherwise buf
function M.enable(name, buf)
  -- When buf is number, set the buffer's local value
  if type(buf) == "number" then
    if buf > 0 then
      vim.b[buf][name] = true
    else
      vim.b[name] = true
    end
  else
    vim.g[name] = true
    vim.b[name] = nil
  end

  LazyUtil.info("Enabled " .. name, { title = "Toggle" })
end

---@param buf? number nil get global, 0 current, otherwise buf
function M.enabled(name, buf)
  -- When buf is number, If the buffer has a local value, use that
  if type(buf) == "number" then
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    local baf = vim.b[buf][name]

    if baf ~= nil then
      return baf
    end
  end

  local gaf = vim.g[name]

  -- Otherwise use the global value if set, or false by default
  return gaf ~= nil and gaf or false
end

---@param buf? number nil set global, 0 current, otherwise buf
function M.toggle(name, buf)
  local enabled = M.enabled(name, buf)
  if type(buf) == "number" then
    if buf > 0 then
      vim.b[buf][name] = not enabled
    else
      vim.b[name] = not enabled
    end
  else
    vim.g[name] = not enabled
    vim.b[name] = nil
  end

  if M.enabled(name, buf) then
    LazyUtil.info("Enabled " .. name, { title = "Toggle" })
  else
    LazyUtil.warn("Disabled " .. name, { title = "Toggle" })
  end
end

function M.toggle_diagnostics()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
    LazyUtil.warn("Disabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.enable()
    LazyUtil.info("Enabled diagnostics", { title = "Diagnostics" })
  end
end

M.toggle_clipboard = function()
  if vim.tbl_contains(vim.opt.clipboard:get(), "unnamedplus") then
    vim.opt.clipboard = ""
  else
    vim.opt.clipboard = "unnamedplus"
  end
end

M.toggle_conceallevel = function()
  local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
  M.option("conceallevel", false, { 0, conceallevel })
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

return M

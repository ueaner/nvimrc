-- require("utils.option").toggle()

local notify = require("lazy.core.util")

local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
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
    return notify.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()

  if not silent then
    if vim.opt_local[option]:get() then
      notify.info("Enabled " .. option, { title = "Option" })
    else
      notify.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

function M.toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    notify.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    notify.warn("Disabled diagnostics", { title = "Diagnostics" })
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
  M.toggle("conceallevel", false, { 0, conceallevel })
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

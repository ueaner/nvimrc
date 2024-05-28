---@class util.dap
local M = {}

-- https://github.com/leoluz/nvim-dap-go/blob/a5cc8dcad43f0732585d4793deb02a25c4afb766/lua/dap-go.lua#L25
function M.get_args()
  return coroutine.create(function(dap_run_co)
    local args = {}
    vim.ui.input({ prompt = "Args: " }, function(input)
      args = vim.split(input or "", " ")
      coroutine.resume(dap_run_co, args)
    end)
  end)
end

-- Requires debug adapter support
function M.breakpoint_condition()
  local condition = "Breakpoint condition"
  local hit_condition = "Breakpoint hit condition"
  local log_message = "Breakpoint log message"
  vim.ui.select({ condition, hit_condition, log_message }, {
    prompt = "Dap Breakpoint",
  }, function(selected)
    if not selected then
      return
    end

    local label = selected .. ": "
    if selected == condition then
      require("dap").set_breakpoint(vim.fn.input(label))
    elseif selected == hit_condition then
      require("dap").set_breakpoint(nil, vim.fn.input(label))
    elseif selected == log_message then
      require("dap").set_breakpoint(nil, nil, vim.fn.input(label))
    end
  end)
end

return M

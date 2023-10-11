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

return M

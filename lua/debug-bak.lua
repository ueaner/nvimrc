local M = {}

function M.post()
  require("dapui").setup({
    floating = {
      max_width = 0.5,
      max_height = 0.5,
    }
  })

  local dap = require("dap")

  dap.adapters.go = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/.vscode/extensions/golang.go-0.24.1/dist/debugAdapter.js"}
  }
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
      dlvToolPath = vim.fn.exepath("dlv")
    }
  }

end

return M

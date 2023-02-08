--
-- https://github.com/jbyuki/one-small-step-for-vimkind/blob/main/ARCHITECTURE.md for neovim lua, nlua
--
--
-- =============================
--              UI
-- =============================
local dapui = require("dapui")
dapui.setup({
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      position = 'right',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      position = 'bottom',
    },
  },

  floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
})

--vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

-- =============================
--              DAP
-- =============================
local dap = require("dap")
-- ~/.cache/nvim/dap.log
dap.set_log_level('TRACE');

require'nvim-dap-virtual-text'.setup()

-- dap 开始执行时，自动打开 elements ui: repl, stacks, scopes, breakpoints 等
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
-- 调试结束后不自动关闭窗口，有输出内容
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

-- mappings:
-- require("dapui").open()
-- require("dapui").close()
-- require("dapui").toggle()

-- =============================
--            ADAPTERS
-- =============================


-- 查找本地 vscode-go 插件的最新版本路径
local function LookupVSCodeGoDebugAdapter()
  -- ls ~/.vscode/extensions/golang.go-*/dist/debugAdapter.js -t -d -1 | head -n 1
  local p = io.popen('ls ~/.vscode/extensions/golang.go-*/dist/debugAdapter.js -t -d -1')
  for f in p:lines() do
    return f
  end
end
-- print(LookupVSCodeGoDebugAdapter())
-- local GoDapAdapter = LookupVSCodeGoDebugAdapter()

dap.adapters.go = {
  type = "executable",
  command = "node",
  args = {LookupVSCodeGoDebugAdapter()}
  -- args = {os.getenv("HOME") .. "/.vscode/extensions/golang.go-0.32.0/dist/debugAdapter.js"}
}

-- =============================
--         CONFIGURATIONS
-- =============================
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    mode = "debug", -- 编译并调试主程序
    program = "${file}",
    dlvToolPath = vim.fn.exepath('dlv-dap')
  },
  -- configuration for debugging test files
  {
    type = "go",
    name = "Debug test",
    request = "launch",
    mode = "test", -- 编译并调试测试用例
    program = "${file}",
    dlvToolPath = vim.fn.exepath('dlv-dap')
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
    dlvToolPath = vim.fn.exepath('dlv-dap')
  }
}

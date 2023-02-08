-- https://github.com/awwalker/dotfiles/blob/master/.config/nvim/lua/debuggers.lua
-- nvim-dap-ui 作者的配置
-- https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/dap.lua
-- 其他参考：
-- https://github.com/theHamsta/dotfiles
-- 此处文件名不能用 debug.lua，可能和内置的某个功能重合了
--print("loaded debug.lua first line")
--
--
-- =============================
--              UI
-- =============================
-- 配合 alacritty 0.7.2 还有问题
--require("dapui").setup({
--    floating = {
--      max_width = 0.5,
--      max_height = 0.5,
--    }
--  })

require("dapui").setup {
  icons = {
    -- expanded = "⯆",
    -- collapsed = "⯈",
    circular = "↺",
  },
  mappings = {
    expand = "<CR>",
    open = "o",
    remove = "d",
  },
  -- TODO 设置 sidebar 的 statusline
  sidebar = {
    -- elements = {
    --   -- You can change the order of elements in the sidebar
    --   "stacks",
    --   "scopes",
    --   -- "breakpoints",
    --   -- "watches",
    -- },
    size = 60,
    position = "right", -- Can be "left" or "right"
  },
  tray = {
    elements = {
      "repl",
    },
    size = 10,
    position = "bottom", -- Can be "bottom" or "top"
  },
}


-- =============================
--              DAP
-- =============================
local dap = require('dap')
-- :lua print(vim.fn.stdpath('cache'))
-- ~/.cache/nvim/dap.log
dap.set_log_level('TRACE');

-- Enable virtual text.
-- vim.g.dap_virtual_text = true
require'nvim-dap-virtual-text'.setup()

-- dap.defaults.fallback.external_terminal = {
--     command = '/usr/local/bin/alacritty';
--     args = {'-e'};
-- }



-- =============================
--            ADAPTERS
-- =============================

-- Go https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Go
-- 注意项目的运行在 GOPATH 路径下
--
--
--
-- vscode-go-0.24.2 $ npm install -D ts-loader
-- npm WARN deprecated har-validator@5.1.5: this library is no longer supported
-- npm WARN deprecated fsevents@2.1.3: "Please update to latest v2.3 or v2.2"
-- npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
-- npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
-- npm WARN deprecated es5class@2.3.1: this package isn't maintained anymore because ES6+
-- npm WARN deprecated tslint@6.1.3: TSLint has been deprecated in favor of ESLint. Please see https://github.com/palantir/tslint/issues/4534 for more information.
--
-- added 630 packages, and audited 632 packages in 29s
--
-- 96 packages are looking for funding
--   run `npm fund` for details
--
-- 1 moderate severity vulnerability
--
-- To address all issues, run:
--   npm audit fix
--
-- Run `npm audit` for details.
-- vscode-go-0.24.2 $ npm run compile
--
-- > go@0.24.2 compile
-- > webpack --mode production
--
-- (node:40140) [DEP_WEBPACK_DEPRECATION_ARRAY_TO_SET] DeprecationWarning: Compilation.modules was changed from Array to Set (using Array method 'reduce' is deprecated)
-- (Use `node --trace-deprecation ...` to show where the warning was created)
-- (node:40140) [DEP_WEBPACK_MODULE_ERRORS] DeprecationWarning: Module.errors was removed (use getErrors instead)
-- asset goMain.js 3.36 MiB [emitted] (name: goMain) 1 related asset
-- asset debugAdapter.js 1.13 MiB [emitted] (name: debugAdapter) 1 related asset
-- runtime modules 916 bytes 5 modules
-- modules by path ./node_modules/ 3.52 MiB
--   javascript modules 3.26 MiB 455 modules
--   json modules 269 KiB
--     modules by path ./node_modules/har-schema/lib/*.json 6.93 KiB 18 modules
--     modules by path ./node_modules/ajv/lib/refs/*.json 5.58 KiB 3 modules
--     ./node_modules/mime-db/db.json 139 KiB [built] [code generated]
--     ./node_modules/psl/data/rules.json 117 KiB [built] [code generated]
-- modules by path ./src/ 683 KiB
--   modules by path ./src/*.ts 553 KiB 54 modules
--   modules by path ./src/utils/*.ts 25.1 KiB 7 modules
--   ./src/debugAdapter/goDebug.ts 105 KiB [built] [code generated]
-- 21 modules
-- webpack 5.27.2 compiled successfully in 13311 ms


-- -- 查找本地 vscode-go 插件的最新版本路径
-- local function LookupVSCodeGoDebugAdapter()
--     -- ls ~/.vscode/extensions/golang.go-*/dist/debugAdapter.js -t -d -1 | head -n 1
--    local p = io.popen('ls ~/.vscode/extensions/golang.go-*/dist/debugAdapter.js -t -d -1')
--    for f in p:lines() do
--        return f
--    end
-- end
-- -- print(LookupVSCodeGoDebugAdapter())
-- -- local GoDapAdapter = LookupVSCodeGoDebugAdapter()
--
-- dap.adapters.go = {
--     type = "executable",
--     command = "node",
--     -- args = {os.getenv("HOME") .. "/.config/nvim/vscode-extensions/vscode-go-0.24.2/dist/debugAdapter.js"}
--     -- args = {os.getenv("HOME") .. "/.vscode/extensions/golang.go-0.27.2/dist/debugAdapter.js"}
--     args = {LookupVSCodeGoDebugAdapter()}
-- }
--
-- -- "debugAdapter": "dlv-dap"
--
--
-- -- =============================
-- --         CONFIGURATIONS
-- -- =============================
--
-- -- Go
-- dap.configurations.go = {
--     {
--         type = "go";
--         name = "Local File Debugger";
--         request = "launch";
--         program = "${file}";
--         dlvToolPath = vim.fn.exepath("dlv");
--     }
-- }


dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", "127.0.0.1:" .. port},
      detached = true
    }
    -- dlv-dap 是直接从 delve 的 master 分支构建出来的
    handle, pid_or_err = vim.loop.spawn("dlv-dap", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({type = "server", host = "127.0.0.1", port = port})
      end,
      100)
  end
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  -- 调试模型列表，默认为 debug mode，会在执行 Continue 启动调试时进行选择
  -- output 参数可以定义
  -- 首次调试有问题
  -- 需要在 GOPATH 路径下，或者有 go.mod 文件
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      mode = "debug", -- 编译并调试主程序
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test", -- 编译并调试测试用例
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
}



-- DAP mappings
-- vim.api.nvim_set_keymap('n', '<leader>c', '<cmd> lua require"dap".continue()<CR>', silent);
-- vim.api.nvim_set_keymap('n', '<leader>n', '<cmd> lua require"dap".step_over()<CR>', silent);
-- vim.api.nvim_set_keymap('n', '<leader>b', '<cmd> lua require"dap".toggle_breakpoint()<CR>', silent);
-- vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd> lua require"dap".repl.open()<CR>', silent);
-- vim.api.nvim_set_keymap('n', '<leader>si', '<cmd> lua require"dap".step_into()<CR>', silent);
-- vim.api.nvim_set_keymap('n', '<leader>so', '<cmd> lua require"dap".step_out()<CR>', silent);


-- set signcolumn=yes
--vim.o.signcolumn=yes;
-- Save undo history
-- vim.cmd[[ set undofile ]]
-- window option
vim.wo.signcolumn="yes"


















-- ~ $ dlv dap -l 127.0.0.1:38697 --log --log-output="dap"
-- DAP server listening at: 127.0.0.1:38697
-- 2021-05-08T03:08:39+08:00 debug layer=dap DAP server pid = 44440
--
-- 2021-05-08T03:09:08+08:00 debug layer=dap [<- from client]{"seq":0,"type":"request","command":"initialize","arguments":{"clientID":"neovim","clientName":"neovim","adapterID":"nvim-dap","locale":"zh_CN.UTF-8","linesStartAt1":true,"columnsStartAt1":true,"pathFormat":"path","supportsVariableType":true,"supportsRunInTerminalRequest":true}}
-- 2021-05-08T03:09:08+08:00 debug layer=dap [-> to client]{"seq":0,"type":"response","request_seq":0,"success":true,"command":"initialize","body":{"supportsConfigurationDoneRequest":true,"supportsConditionalBreakpoints":true,"supportTerminateDebuggee":true,"supportsDelayedStackTraceLoading":true}}
-- 2021-05-08T03:09:08+08:00 debug layer=dap [<- from client]{"seq":1,"type":"request","command":"launch","arguments":{"name":"Debug","program":"a.go","request":"launch","type":"go"}}
-- 2021-05-08T03:09:08+08:00 debug layer=dap building binary at /Users/ueaner/__debug_bin
-- 2021-05-08T03:09:08+08:00 debug layer=dap Failed to launch: Build error: cannot find package "a.go" in any of:
--         /usr/local/opt/go/libexec/src/a.go (from $GOROOT)
--         /Users/ueaner/go/src/a.go (from $GOPATH) (exit status 1)
-- 2021-05-08T03:09:08+08:00 debug layer=dap [-> to client]{"seq":0,"type":"response","request_seq":1,"success":false,"command":"launch","message":"Failed to launch","body":{"error":{"id":3000,"format":"Failed to launch: Build error: cannot find package \"a.go\" in any of:\n\t/usr/local/opt/go/libexec/src/a.go (from $GOROOT)\n\t/Users/ueaner/go/src/a.go (from $GOPATH) (exit status 1)"}}}
-- 2021-05-08T03:09:08+08:00 debug layer=dap DAP server stopping...
-- 2021-05-08T03:09:08+08:00 debug layer=dap DAP server stopped




-- dap.adapters.go = function(callback, config)
--     local handle
--     local pid_or_err
--     local port = 38697
--     handle, pid_or_err =
--       vim.loop.spawn(
--       "dlv",
--       {
--         args = {"dap", "-l", "127.0.0.1:" .. port},
--         detached = true
--       },
--       function(code)
--         handle:close()
--         print("Delve exited with exit code: " .. code)
--       end
--     )
--     -- Wait 100ms for delve to start
--     vim.defer_fn(
--       function()
--         --dap.repl.open()
--         callback({type = "server", host = "127.0.0.1", port = port})
--       end,
--       100)
--
--
--     --callback({type = "server", host = "127.0.0.1", port = port})
--   end
--   -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
--   dap.configurations.go = {
--     {
--       type = "go",
--       name = "Debug",
--       request = "launch",
--       program = "${file}"
--     }
--   }

--print("loaded debug.lua last line")

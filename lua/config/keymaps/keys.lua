local M = {}

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

function M.RustReplAppendSendCr()
  if vim.bo.filetype == "rust" then
    require("iron.core").send(nil, string.char(13))
  end
end

-- NOTE: Adding ` keys` after the plugin name is handled by the plugin itself.

-- stylua: ignore
---@type { [string]: LazyKeysSpec[] }
local keys = {
  -- Explorer
  ["neo-tree.nvim"] = {
    { "<leader>e", function() require("neo-tree.command").execute({ toggle = true, dir = U.root() }) end, desc = "File Explorer", mode = { "n", "t" } },
    { "ge", function() require("neo-tree.command").execute({ toggle = true, dir = U.root(), source = "git_status" }) end, desc = "Git Explorer", mode = { "n", "t" } },
    { "<leader>E", "<cmd>DBUIToggle<cr>", desc = "Database Explorer", mode = { "n", "t" } },
  },

  -- ,d for Debug
  ["nvim-dap"] = {
    -- Running the program
    { "<leader>md", "<cmd>DapShowLog<cr>", desc = "Dap Show Log" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },   -- Run until breakpoint or program termination
    { "<leader>dr", function() require("dap").continue() end, desc = "Run" },        -- alias to <leader>dc
    { "<leader>d.", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dR", function() require("dap").restart() end, desc = "Restart" },
    { "<leader>dq", function() require("dap").terminate() end, desc = "Terminate" },
    -- steps
    { "<leader>dp", function() require("dap").step_back() end, desc = "Step Back (Prev)" }, -- [p]revious
    { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over (Next)" }, -- [n]ext
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" }, -- [i]nto
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },   -- [o]ut, [u]ninto
    { "<leader>dh", function() require("dap").run_to_cursor() end, desc = "Run to Cursor (Here)" }, -- step to [h]ere
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    -- breakpoints
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<Leader>dB", function() U.dap.breakpoint_condition() end, desc = "Conditional Breakpoint" },
    { "<leader>dx", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Show All Breakpoints" },
    { "<leader>dX", function() require("dap").clear_breakpoints() end, desc = "Removes All Breakpoints" },
    -- watch expressions, show hover
    { "<A-e>", function() require("dapui").eval() end, desc = "Evaluate", mode = { "n", "x" } },
    { "<leader>de", function() require("dap.ui.widgets").hover() end, desc = "Evaluate Expression", mode = { "n", "x" } },
    -- dapui
    { "<leader>du", function() require("dapui").toggle() end, desc = "Dap UI" },

    { "<leader>dwe",
      function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").expression, { border = "rounded" }) end,
      desc = "Evaluate",
      mode = { "n", "x" },
    },
    {
      "<leader>dws",
      function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").sessions, { border = "rounded" }) end,
      desc = "Sessions",
    },
    {
      "<leader>dw1",
      function()
        require("dapui").float_element("scopes", { enter = true })
      end,
      desc = "Scopes      (element)",
    },
    {
      "<leader>dw2",
      function()
        require("dapui").float_element("breakpoints", { enter = true })
      end,
      desc = "Breakpoints (element)",
    },
    {
      "<leader>dw3",
      function()
        require("dapui").float_element("stacks", { enter = true })
      end,
      desc = "Stacks      (element)",
    },
    {
      "<leader>dw4",
      function()
        require("dapui").float_element("watches", { enter = true })
      end,
      desc = "Watches     (element)",
    },
    {
      "<leader>dw5",
      function()
        require("dapui").float_element("repl", { enter = true })
      end,
      desc = "Repl        (element)",
    },
    {
      "<leader>dw6",
      function()
        require("dapui").float_element("console", { enter = true })
      end,
      desc = "Console     (element)",
    },
    {
      "<leader>dw7",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "rounded" })
      end,
      desc = "Scopes      (widget) - scopes",
    },
    {
      "<leader>dw8",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "rounded" })
      end,
      desc = "Frames      (widget) - scopes",
    },
    {
      "<leader>dw9",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "rounded" })
      end,
      desc = "Threads     (widget) - event_thread",
    },
  },
  ["telescope-dap.nvim"] = {
    { "<leader>da", function() require("telescope").extensions.dap.commands() end, desc = "All Commands" },
    {
      "<leader>dd",
      function()
        require("telescope").extensions.dap.configurations({
          language_filter = function(lang)
            return lang == vim.bo.filetype
          end,
        })
      end,
      desc = "Show DAP configurations",
    },
  },
  ["nvim-dap-go"] = {
    { "<leader>dt", function() require("dap-go").debug_test() end, desc = "Debug Test", ft = "go" },
    { "<leader>dT", function() require("dap-go").debug_last_test() end, desc = "Debug Last Test", ft = "go" },
  },
  ["nvim-dap-python"] = {
    { "<leader>dC", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python" },
    { "<leader>dM", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dS", function() require("dap-python").debug_selection() end, desc = "Debug Selection", ft = "python" },
  },

  -- ,t for Test/Terminal
  ["neotest"] = {
    { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>t.", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>tq", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Show Summary" },
    { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch" },

    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Show Output Panel" },
  },
  ["nvterm"] = { -- extras/tools
    -- `<Esc><Esc>` enter normal mode, then switch windows
    { "<leader>tt", function() require("nvterm.terminal").toggle("horizontal") end, desc = "Terminal", mode = { "n", "t" } },
  },

  ["actions-preview.nvim"] = {
    { "ga", function() require("actions-preview").code_actions() end, desc = "Code Action Preview", mode = { "n", "x" } },
  },

  ["refactoring.nvim"] = {
    { "<leader>cr", function() require("telescope").extensions.refactoring.refactors() end, mode = { "n", "x" }, desc = "Refactor" },
  },
  ["nvim-lspconfig keys"] = {
    { "<leader>ml", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    -- NOTE: method textDocument/declaration is not supported by any of the servers registered for the current buffer
    { "ge", vim.lsp.buf.declaration, desc = "Go to D[e]claration", has = "declaration" },
    { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Go to Definition", has = "definition" },
    { "gD", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Go to Type Definition" },
    { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Go to Implementation" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Find References" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
    { "<leader>cl", vim.lsp.codelens.run, desc = "Code Lens", mode = { "n", "x" }, has = "codeLens" },
    { "<leader>cL", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
    { "<leader>ci", vim.lsp.buf.incoming_calls, desc = "Call Hierarchy Incoming Calls", mode = { "n", "x" }, has = "callHierarchy/incomingCalls" },
    { "<leader>co", vim.lsp.buf.outgoing_calls, desc = "Call Hierarchy Outgoing Calls", mode = { "n", "x" }, has = "callHierarchy/outgoingCalls" },
    { "<leader>cn", function() return ":Rename " .. vim.fn.expand("<cword>") end, expr = true, desc = "Rename", has = "rename" },
    { "<leader>cA", U.lsp.action.source, desc = "Source Action", has = "codeAction" },
    { "]]", function() U.lsp.words.jump(vim.v.count1, true) end, desc = "Next Reference", has = "documentHighlight" },
    { "[[", function() U.lsp.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", has = "documentHighlight" },
  },

  ["rustaceanvim"] = {
    { "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, desc = "Hover Actions", mode = { "n", "x" }, ft = "rust" },
    { "<leader>ca", function() vim.cmd.RustLsp("codeAction") end, desc = "Code Action", mode = { "n", "x" }, ft = "rust" },
    { "<leader>dr", function() vim.cmd.RustLsp("debuggables") end, desc = "Run Debuggables", mode = { "n", "x" }, ft = "rust" },
    { "<leader>dA", function() vim.cmd.RustLsp("runnables") end, desc = "Run Runnables", mode = { "n", "x" }, ft = "rust" },
  },

  ["nvim-treesitter"] = {
    { "<space>", desc = "Increment selection" },
    { "<bs>", desc = "Decrement selection", mode = "x" },
    { "<leader>mt", "<cmd>TSConfigInfo<cr>", desc = "Treesitter Info" },
  },

  -- Motions based on syntax trees
  ["nvim-treehopper"] = {
    -- Use `v, c, d, y` to enter Operator-pending mode, and then press `m` to visually select/change/delete/yank
    { "m", ":<C-U>lua require('tsht').nodes()<cr>", desc = "Range Operator", mode = { "o", "x" } },
  },
  --  Enhanced f, t, F, T motions
  ["flash.nvim"] = {
    { "s", function() require("flash").jump() end, desc = "Jump", mode = { "n" } },
    { "s", function() require("flash").jump() end, desc = "Selection", mode = { "o", "x" } },
    { "S", function() require("flash").treesitter() end, desc = "Selection", mode = { "n", "o", "x" } },
    { "<c-r>", function() require("flash").treesitter_search() end, desc = "Selection by Search", mode = { "o", "x" } },
  },

  ["telescope.nvim"] = {
    { "<leader><space>", "<cmd>Telescope<cr>", desc = "Telescope Builtin" },
    { "<leader>fa", "<cmd>Telescope<cr>", desc = "More... (<leader><space>)" },
    { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    { "<leader>/", "<cmd>Telescope live_grep_args<CR>", desc = "Grep" },
    -- NOTE: There is an issue with the CJK character under the search cursor
    { "<leader>/", function() require("telescope-live-grep-args.shortcuts").grep_visual_selection({ postfix = false }) end, desc = "Grep", mode = { "x" } },
    -- find
    { "<leader>fc", "<cmd>Telescope cheat fd<cr>", desc = "Cheatsheets" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Go to Symbol" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope git_files show_untracked=true<cr>", desc = "Find Git Files" },
    { "<leader>fR", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>fp", "<cmd>Telescope project display_type=full<cr>", desc = "Find Project" },
    { "<leader>fx", "<cmd>Telescope lazy_plugins<cr>", desc = "Find Plugin Config" },
    { "<leader>fz", function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end, desc = "Find Plugin File" },
  },

  -- search/replace in multiple files
  ["nvim-spectre"] = {
    { "<leader>fr", function() require("spectre").open() end, desc = "Find and Replace (Spectre)" },
  },

  ["trouble.nvim"] = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous Quickfix",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next Quickfix",
    },
  },
  ["todo-comments.nvim"] = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  },

  ["bufferline.nvim"] = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin Buffer" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Next" },
  },

  -- git
  ["gitsigns.nvim"] = {
    { "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else require("gitsigns").nav_hunk("next") end end, desc = "Next Hunk" },
    { "[h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else require("gitsigns").nav_hunk("prev") end end, desc = "Prev Hunk" },
    { "]H", function() require("gitsigns").nav_hunk("last") end, desc = "Last Hunk" },
    { "[H", function() require("gitsigns").nav_hunk("first") end, desc = "First Hunk" },
    { "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", mode = { "n", "x" } },
    { "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", mode = { "n", "x" } },
    { "<leader>ghS", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
    { "<leader>ghu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Buffer" },
    { "<leader>ghR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
    { "<leader>ghp", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Hunk Inline" },
    { "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line" },
    { "<leader>ghB", function() require("gitsigns").blame() end, desc = "Blame Buffer" },
    { "<leader>ghd", function() require("gitsigns").diffthis() end, desc = "Diff This" },
    { "<leader>ghD", function() require("gitsigns").diffthis("~") end, desc = "Diff This ~" },
  },

  -- outline
  ["aerial.nvim"] = {
    { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Outline" }
  },

  ["outline.nvim"] = {
    { "<leader>cs", "<cmd>Outline<cr>", desc = "Outline" }
  },

  ["zen-mode.nvim"] = {
    { "gz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  },

  ["noice.nvim"] = {
    { "<leader>nh", function() require("noice").cmd("telescope") end, desc = "Noice History" },

    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<Right>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i"}},
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<Left>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i"}},
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"n", "s"}},
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"n", "s"}},

    { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<Del>" end end, silent = true, expr = true, desc = "Scroll Down", mode = {"i"}},
    { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<C-G>u<C-U>" end end, silent = true, expr = true, desc = "Scroll Up", mode = {"i"}},
    { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, silent = true, expr = true, desc = "Scroll Down", mode = {"n", "s"}},
    { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, silent = true, expr = true, desc = "Scroll Up", mode = {"n", "s"}},
  },

  ["nvim-notify"] = {
    { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss All Notifications" },
  },

  ["mason.nvim"] = {
    { "<leader>mm", "<cmd>Mason<cr>", desc = "Mason" },
  },

  ["conform.nvim"] = {
    { "<leader>cF", function() require("conform").format({ formatters = { "injected" } }) end, mode = { "n", "v" }, desc = "Format Injected Langs" },
    { "<leader>mc", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
  },
  ["incline.nvim"] = {
    { "<leader>uw", function () require("incline").toggle() end, desc = "Toggle Winbar (incline)" },
  },

  ["which-key.nvim"] = {
    { "<leader>mk", "<cmd>WhichKey<cr>", desc = "Which Key" },
  },

  ["edgy.nvim"] = {
    { "<leader>ue", function() require("edgy").toggle() end, desc = "Edgy Toggle" },
    { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
  },

  ["plantuml-previewer.vim"] = {
    { "<leader>cp", "<cmd>PlantumlToggle<cr>", desc = "Live Preview (plantuml)", ft = "plantuml" },
  },

  -- If both Glow and Peek are installed, Peek will be used first for markdown files.
  ["glow.nvim"] = {
    { "<leader>cp", "<cmd>Glow!<cr>", desc = "Preview (Glow)", ft = "markdown" },
  },
  ["peek.nvim"] = {
    { "<leader>cp", function() local peek = require("peek"); if peek.is_open() then peek.close() else peek.open() end end, desc = "Live Preview (Peek)", ft = "markdown" },
  },
  ["render-markdown.nvim"] = {
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown Render", ft = "markdown" },
  },

  -- If both Sniprun and Iron are installed, Iron will be used first.
  ["sniprun"] = {
    { "<leader>rr", function() require("sniprun").run() end, desc = "Run Cursor Line" },
    { "<leader>rr", function() require("sniprun").run("v") end, mode = { "v" }, desc = "Run Selected Code Block" },
    { "<leader>rf", function() require("sniprun.api").run_range(1, vim.fn.line("$")) end, desc = "Run File" },
    {
      "<leader>rq",
      function()
        require("sniprun").clear_repl()
        require("sniprun.display").close_all()
        require("sniprun").reset()
      end,
      desc = "Quit",
    },
    { "<leader>ri", function() vim.cmd("e " .. os.getenv("XDG_CACHE_HOME") .. "/sniprun/infofile.txt") end, desc = "Info" },
    {
      "<leader>rI",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root .. "/sniprun/docs/sources/interpreters/",
        })
      end,
      desc = "Find Interpreters",
    },
  },

  ["iron.nvim"] = {
    ft = function () return require("lazy.core.config").spec.plugins["iron.nvim"].ft end,
    { "<leader>rr", function() require("iron.core").run_motion("send_motion") M.RustReplAppendSendCr() end, desc = "Run Code Block" },
    { "<leader>rr", function() require("iron.core").visual_send() M.RustReplAppendSendCr() end, desc = "Run Selected Code Block", mode = { "v" } },
    { "<leader>rl", function() require("iron.core").send_line() M.RustReplAppendSendCr() end, desc = "Run Cursor Line" },
    { "<leader>rf", function() require("iron.core").send_file() M.RustReplAppendSendCr() end, desc = "Run File" },
    { "<leader>r<cr>", function() require("iron.core").send(nil, string.char(13)) end, desc = "Return" },
    { "<leader>ri", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt (<C-c>)" },
    { "<leader>rq", function() require("iron.core").close_repl() end, desc = "Quit" },
    { "<leader>rx", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear" },

    -- NOTE: There needs to be a mapping for all file types so that the default +prefix does not appear in whichkey
    { "<leader>ru", "<cmd>IronRepl<cr>", desc = "Repl UI", mode = { "n", "v" } },
    { "<leader>rR", "<cmd>IronRestart<cr>", desc = "Repl Restart" },
    { "<leader>rF", "<cmd>IronFocus<cr>", desc = "Repl Focus" },
  },
  ["grpc-nvim"] = {
    { "<leader>rr", "<cmd>Grpc<cr>", desc = "Run gRPC Request", ft = "grpc" },
  },
  ["kulala.nvim"] = {
    { "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run Http Request", ft = "http" },
    { "<leader>r.", "<cmd>lua require('kulala').replay()<cr>", desc = "Run Last Http Request", ft = "http" },
    { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL", ft = "http" },
    { "<leader>rp", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from curl", ft = "http" },
    { "<leader>rs", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show stats", ft = "http" },
    { "<leader>rq", "<cmd>lua require('kulala').close()<cr>", desc = "Close window", ft = "http" },
  },

  ["nvim-toc"] = {
    { "<leader>tc", "<cmd>TOC<cr>", desc = "TOC", ft = "markdown" },
  },

  ["translate.nvim"] = {
    { "<leader>tz", "<cmd>Translate ZH<cr><esc>", desc = "Translate from English to Chinese", mode = { "x" } },
    { "<leader>te", "<cmd>Translate EN<cr><sec>", desc = "Translate from Chinese to English", mode = { "x" } },
  },

}

return keys

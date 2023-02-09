return {

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            commented = true,
          })
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end,
      },
    },
    config = function()
      -- https://microsoft.github.io/vscode-codicons/dist/codicon.html
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" }) -- debug-breakpoint-conditional
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
      -- Open automatically when a new debug session is created
      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function(args)
          vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
          require("dap.ext.autocompl").attach()
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      -- Running the program
      { "<leader>dr", "<cmd>Telescope dap configurations<cr>", desc = "run" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "run last" },
      { "<leader>dR", function() require("dap").restart() end, desc = "restart" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "terminate" },
      -- steps
      { "<leader>dp", function() require("dap").step_back() end, desc = "step back" }, -- [p]revious
      { "<leader>dn", function() require("dap").step_over() end, desc = "step over" }, -- [n]ext
      { "<leader>di", function() require("dap").step_into() end, desc = "step into" }, -- [i]nto
      { "<leader>do", function() require("dap").step_out() end, desc = "step out" },   -- [o]ut, [u]ninto
      { "<leader>dc", function() require("dap").continue() end, desc = "continue" },   -- Run until breakpoint or program termination
      { "<leader>dh", function() require("dap").run_to_cursor() end, desc = "step to here(cursor)" }, -- step to [h]ere
      -- breakpoints
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[B] toggle breakpoint" },
      { "<leader>da", "<cmd>Telescope dap list_breakpoints<cr>", desc = "[B] show all breakpoints" },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "[B] removes all breakpoints" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "[B] conditional breakpoint" },
      { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "[B] logpoint" },
      -- dapui
      { "<leader>du", function() require("dapui").toggle() end, desc = "toggle dapui" },
      -- watch expressions
      { "<leader>dk", function() require("dap.ui.widgets").hover() end, desc = "hover expression", mode = { "n", "v" } },
      { "<leader>dK", function() require("dap.ui.widgets").preview() end, desc = "preview expression"},
    },
  },

  {
    "leoluz/nvim-dap-go",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    init = function()
      -- stylua: ignore
      require("utils").daptest.on_ft("go", function(event)
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end, { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end, { desc = "debug last test", buffer = event.buf })
      end)
    end,
    config = function()
      require("dap-go").setup()
    end,
  },
}

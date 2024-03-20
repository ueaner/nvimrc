return {
  -- dap
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
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          require("dapui").setup()
        end,
      },
      {
        "stevearc/overseer.nvim",
        config = true,
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(require("config").icons.dap) do
        ---@cast sign string[]
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Open automatically when a new debug session is created
      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end

      require("utils").on_ft("dap-repl", function(event)
        vim.bo[event.buf]["buflisted"] = false
        require("dap.ext.autocompl").attach()
      end)
    end,
    -- stylua: ignore
    keys = {
      -- Running the program
      { "<leader>mD", "<cmd>DapShowLog<cr>", desc = "Dap Show Log" },
      { "<leader>md", function() require("telescope").extensions.dap.configurations({}) end, desc = "dap configurations" }, -- opts.language_filter
      { "<leader>dc", function() require("dap").continue() end, desc = "continue" },   -- Run until breakpoint or program termination
      { "<leader>dr", function() require("dap").continue() end, desc = "run" },        -- alias to <leader>dc
      { "<leader>d.", function() require("dap").run_last() end, desc = "run repeat last" },
      { "<leader>dR", function() require("dap").restart() end, desc = "restart" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "terminate" },
      -- steps
      { "<leader>dp", function() require("dap").step_back() end, desc = "step back" }, -- [p]revious
      { "<leader>dn", function() require("dap").step_over() end, desc = "step over" }, -- [n]ext
      { "<leader>di", function() require("dap").step_into() end, desc = "step into" }, -- [i]nto
      { "<leader>do", function() require("dap").step_out() end, desc = "step out" },   -- [o]ut, [u]ninto
      { "<leader>dh", function() require("dap").run_to_cursor() end, desc = "step to here(cursor)" }, -- step to [h]ere
      { "<leader>dg", function() require("dap").goto_() end, desc = "goto line (no execute)" },
      { "<leader>dj", function() require("dap").down() end, desc = "down" },
      { "<leader>dk", function() require("dap").up() end, desc = "up" },
      -- breakpoints
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[B] toggle breakpoint" },
      { "<Leader>dB", function() require("utils.dap").breakpoint_condition() end, desc = "[B] conditional breakpoint" },
      { "<leader>dx", "<cmd>Telescope dap list_breakpoints<cr>", desc = "[B] show all breakpoints" },
      { "<leader>dX", function() require("dap").clear_breakpoints() end, desc = "[B] removes all breakpoints" },
      -- watch expressions, show hover
      { "<A-e>", function() require("dapui").eval() end, desc = "eval (<A-e>)", mode = { "n", "v" } },
      { "<leader>de", function() require("dap.ui.widgets").hover() end, desc = "eval expression", mode = { "n", "v" } },
      -- dapui
      { "<leader>du", function() require("dapui").toggle() end, desc = "toggle dapui" },

      { "<leader>dwe",
        function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").expression, { border = "rounded" }) end,
        desc = "Eval",
        mode = { "n", "v" },
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
        desc = "scopes      (element)",
      },
      {
        "<leader>dw2",
        function()
          require("dapui").float_element("breakpoints", { enter = true })
        end,
        desc = "breakpoints (element)",
      },
      {
        "<leader>dw3",
        function()
          require("dapui").float_element("stacks", { enter = true })
        end,
        desc = "stacks      (element)",
      },
      {
        "<leader>dw4",
        function()
          require("dapui").float_element("watches", { enter = true })
        end,
        desc = "watches     (element)",
      },
      {
        "<leader>dw5",
        function()
          require("dapui").float_element("repl", { enter = true })
        end,
        desc = "repl        (element)",
      },
      {
        "<leader>dw6",
        function()
          require("dapui").float_element("console", { enter = true })
        end,
        desc = "console     (element)",
      },
      {
        "<leader>dw7",
        function()
          require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "rounded" })
        end,
        desc = "scopes      (widget) - scopes",
      },
      {
        "<leader>dw8",
        function()
          require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "rounded" })
        end,
        desc = "frames      (widget) - scopes",
      },
      {
        "<leader>dw9",
        function()
          require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "rounded" })
        end,
        desc = "threads     (widget) - event_thread",
      },
    },
  },

  -- dap cmp source
  {
    "nvim-cmp",
    dependencies = {
      "rcarriga/cmp-dap",
    },
    opts = function()
      require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },
}

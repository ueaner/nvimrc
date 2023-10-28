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
        config = function()
          require("dapui").setup()
        end,
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
        "<leader>dwf",
        function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "rounded" }) end,
        desc = "Frames",
      },
      {
        "<leader>dws",
        function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "rounded" }) end,
        desc = "Scopes",
      },
      {
        "<leader>dwt",
        function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "rounded" }) end,
        desc = "Threads",
      },
      {
        "<leader>dwS",
        function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").sessions, { border = "rounded" }) end,
        desc = "Sessions",
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

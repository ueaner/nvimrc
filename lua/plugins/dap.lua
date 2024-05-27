return {
  -- dap
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
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

      require("util").on_ft("dap-repl", function(event)
        vim.bo[event.buf]["buflisted"] = false
        require("dap.ext.autocompl").attach()
      end)
    end,
  },

  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    config = function()
      require("telescope").load_extension("dap")
    end,
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

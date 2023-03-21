return {
  -- neotest
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      {
        "andythigpen/nvim-coverage",
        config = function()
          require("coverage").setup()
        end,
      },
      {
        "stevearc/overseer.nvim",
        config = function()
          require("overseer").setup()
        end,
      },
      -- "nvim-neotest/neotest-go",
    },
    -- stylua: ignore
    keys = {
      { "<leader>ta", function() require('neotest').run.attach() end, desc = "Attach" },
      { "<leader>tr", function() require('neotest').run.run() end, desc = "Run Nearest" },
      { "<leader>tl", function() require('neotest').run.run_last() end, desc = "Run Last" },
      { "<leader>tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run File" },
      { "<leader>to", function() require('neotest').output.open() end, desc = "Output" },
      { "<leader>tq", function() require('neotest').run.stop() end, desc = "Stop" },
      { "<leader>ts", function() require('neotest').summary.toggle() end, desc = "Summary" },
    },
    -- 使用 config 自定义 setup
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      local opts = {
        diagnostic = {
          enabled = true,
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        -- adapters = {
        --   require("neotest-go")({
        --     args = { "-count=1", "-timeout=60s", "-race", "-cover" },
        --   }),
        -- },
        -- Should require `plugins.extras.lang.ZZZ` to be loaded before `neotest`
        adapters = require("plugins.extras.lang.spec").test_adapters(),
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
      require("neotest").setup(opts)
    end,
  },
}

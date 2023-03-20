return {
  -- http client, treesitter: http, json
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- 最好可以和 neotest 兼容使用 ,tt 发起请求
      { "<leader>th", "<Plug>RestNvim", desc = "run http request" },
      { "<leader>tl", "<Plug>RestNvimLast", desc = "run last http request" },
      { "<leader>tc", "<Plug>RestNvimPreview", desc = "preview cURL command" },
    },
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 0,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
  },

  -- grpc client
  {
    "hudclark/grpc-nvim",
    ft = "grpc",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Grpc" },
    keys = {
      { "<leader>tg", "<cmd>Grpc<cr>", desc = "run grpc request" },
    },
  },

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

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
    },
    -- stylua: ignore
    keys = {
      { "<leader>ta", function() require('neotest').run.attach() end, desc = "Attach" },
      { "<leader>tr", function() require('neotest').run.run() end, desc = "Run Nearest" },
      { "<leader>t.", function() require('neotest').run.run_last() end, desc = "Run repeat last" },
      { "<leader>tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run File" },
      { "<leader>to", function() require('neotest').output.open() end, desc = "Output" },
      { "<leader>tq", function() require('neotest').run.stop() end, desc = "Stop" },
      { "<leader>ts", function() require('neotest').summary.toggle() end, desc = "Summary Toggle" },
    },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-count=1", "-timeout=60s", "-race", "-cover" },
      --   },
      -- },
      diagnostic = { enabled = true },
      status = { virtual_text = true, signs = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if require("utils").has("trouble.nvim") then
            vim.cmd("Trouble quickfix")
          else
            vim.cmd("copen")
          end
        end,
      },
    },
    -- use config to customize setup options
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/test/core.lua
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            elseif type(config) == "function" then
              config = config()
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      opts.consumers = { overseer = require("neotest.consumers.overseer") }
      opts.overseer = { enabled = true, force_default = true }

      require("neotest").setup(opts)
    end,
  },
}

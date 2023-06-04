return {

  -- add language parsers to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
      })
    end,
  },

  -- cmdline tools for LSP servers, DAP servers, formatters and linters
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver", -- Wraps golangci-lint as a language server
        "delve",
      })
    end,
  },

  -- setup lspconfig servers
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- server cmdline will be automatically installed with mason and loaded with lspconfig
      ---@type lspconfig.options
      servers = {
        gopls = {},
        golangci_lint_ls = {}, -- linter
      },
    },
  },

  -- setup formatters & linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.goimports,
      })
    end,
  },

  -- setup DAP
  {
    "leoluz/nvim-dap-go",
    init = function()
      require("utils").on_ft("go", function(event)
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end, { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end, { desc = "debug last test", buffer = event.buf })
        -- stylua: ignore end
      end)
    end,
    config = function()
      require("dap-go").setup()
    end,
  },

  -- setup neotest adapter
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = function(_, opts)
      table.insert(opts.adapters, function()
        return require("neotest-go")({
          args = { "-count=1", "-timeout=60s", "-race", "-cover" },
        })
      end)
    end,
  },
}

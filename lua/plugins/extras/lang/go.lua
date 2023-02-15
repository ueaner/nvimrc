return {

  -- add go to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local packages = { "go", "gomod", "gowork" }
        vim.list_extend(opts.ensure_installed, packages, 1, #packages)
      end
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- :lua =require("mason-lspconfig").get_installed_servers()
      local packages = {
        "gopls",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver",
        --"staticcheck",
      }
      vim.list_extend(opts.ensure_installed, packages, 1, #packages)
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- make sure mason installs the server
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        gopls = {},
        golangci_lint_ls = {}, -- linter
      },
    },
  },

  -- formatters & linter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.goimports,
        },
      }
    end,
  },

  -- DAP
  {
    "leoluz/nvim-dap-go",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("go", function(event)
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end, { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end, { desc = "debug last test", buffer = event.buf })
      end)
    end,
    config = function()
      require("dap-go").setup()
    end,
  },
}

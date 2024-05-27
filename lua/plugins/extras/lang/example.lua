-- stylua: ignore
if true then return {} end

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
        "gofumpt",
        "golangci-lint",
        "golangci-lint-langserver", -- Wraps golangci-lint as a language server
        "delve",
        --"staticcheck",
        "gomodifytags",
        "impl",
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
        gopls = {
          gofumpt = true, -- formatter, default "goimports"
        },
        golangci_lint_ls = {}, -- linter
      },
    },
  },

  -- setup code actions
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
      })
    end,
  },

  -- setup DAP
  {
    "leoluz/nvim-dap-go",
    init = function()
      require("util").on_ft("go", function(event)
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

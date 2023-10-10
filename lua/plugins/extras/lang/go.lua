local generator = require("plugins.extras.langspec"):new()
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = "go",
  parsers = { -- nvim-treesitter: language parsers
    "go",
    "gomod",
    "gowork",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "gopls",
    "goimports",
    "gofumpt",
    "golangci-lint",
    "golangci-lint-langserver", -- Wraps golangci-lint as a language server
    "delve",
    --"staticcheck",
    "gomodifytags",
    "impl",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        gofumpt = true, -- formatter, default "goimports"
      },
      golangci_lint_ls = {}, -- linter
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.code_actions.gomodifytags,
      nls.builtins.code_actions.impl,
    },
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "leoluz/nvim-dap-go",
      -- stylua: ignore
      on_ft = function(event)
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end,
          { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end,
          { desc = "debug last test", buffer = event.buf })
      end,
    },
  },
  test = { -- neotest: language specific adapters
    {
      "nvim-neotest/neotest-go",
      adapter_fn = function()
        return require("neotest-go")({
          args = { "-count=1", "-timeout=60s", "-race", "-cover" },
        })
      end,
    },
  },
}

return generator:generate(conf)

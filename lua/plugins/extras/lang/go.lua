local generator = require("plugins.extras.langspec"):new()

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
        settings = {
          -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
          gopls = {
            gofumpt = true, -- formatter, default "goimports"
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
          },
        },
      },
      golangci_lint_ls = {}, -- linter
    },
  },
  code_actions = { -- null-ls.nvim: builtins code_actions
    "gomodifytags",
    "impl",
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
    "nvim-neotest/neotest-go",
    adapters = {
      ["neotest-go"] = {
        args = { "-count=1", "-timeout=60s", "-race", "-cover" },
      },
    },
  },
}

return generator:generate(conf)

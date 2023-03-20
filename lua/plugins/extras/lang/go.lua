local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
  parsers = { -- nvim-treesitter: language parsers
    "go",
    "gomod",
    "gowork",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "gopls",
    "goimports",
    "golangci-lint",
    "golangci-lint-langserver", -- Wraps golangci-lint as a language server
    "delve",
    --"staticcheck",
    "gomodifytags",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      gopls = {},
      golangci_lint_ls = {}, -- linter
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.goimports,
      nls.builtins.code_actions.gomodifytags,
    },
  },
  test_adapters = { -- neotest: language specific adapter functions
    function()
      return require("neotest-go")({
        args = { "-count=1", "-timeout=60s", "-race", "-cover" },
      })
    end,
  },
}

local specs = generate(conf)

table.insert(specs, {
  "nvim-neotest/neotest-go",
  ft = "go",
})

table.insert(specs, {
  "leoluz/nvim-dap-go",
  ft = "go",
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
})

return specs

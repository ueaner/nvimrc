local generator = require("plugins.extras.langspecs"):new()
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
    "golangci-lint",
    "golangci-lint-langserver", -- Wraps golangci-lint as a language server
    "delve",
    --"staticcheck",
    "gomodifytags",
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
      },
      golangci_lint_ls = {}, -- linter
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.goimports,
      nls.builtins.code_actions.gomodifytags,
    },
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "leoluz/nvim-dap-go",
      -- stylua: ignore
      on_ft = function(event)
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end, { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end, { desc = "debug last test", buffer = event.buf })
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

return generator
  :append({
    "ueaner/hierarchy-tree-go.nvim",
    ft = { "go" },
    config = function()
      require("hierarchy-tree-go").setup({
        keymap = {
          -- global keymap
          incoming = "<leader>ci", -- call incoming under cursorword
          outgoing = "<leader>co", -- call outgoing under cursorword
          open = "<leader>ho", -- open hierarchy win
          close = "<leader>hc", -- close hierarchy win
          -- focus: if hierarchy win is valid but is not current win, set to current win
          -- focus: if hierarchy win is valid and is current win, close
          -- focus  if hierarchy win not existing,open and focus
          focus = "<leader>hu", -- toggle hierarchy win
          tograph = "<leader>hs", -- to svg

          -- buffer keymap
          expand = "o", -- expand or collapse hierarchy
          jump = "<CR>", -- jump
          move = "<space><space>", -- switch the hierarchy window position, must be current win
        },
      })
    end,
  })
  :generate(conf)

local generator = require("plugins.extras.langspec"):new()
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = { "sh", "bash" },
  parsers = { -- nvim-treesitter: language parsers
    "bash",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "bash-language-server",
    "shfmt",
    "shellcheck", -- bashls is integrated, so no need to configure `null-ls` diagnostics
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      bashls = {},
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.shfmt,
    },
  },
  formatters = { -- conform.nvim
    "shfmt",
  },
}

return generator:generate(conf)

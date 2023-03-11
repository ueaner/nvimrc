local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
  parsers = { -- nvim-treesitter: language parsers
    "bash",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "bash-language-server",
    "shfmt",
    "shellcheck", -- bashls integrated
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      bashls = {},
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.shfmt,
    },
  },
}

return generate(conf)

local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = "php",
  parsers = { -- nvim-treesitter: language parsers
    "php",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "phpactor",
    "php-cs-fixer",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      phpactor = {},
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.phpcsfixer,
    },
  },
}

return generate(conf)

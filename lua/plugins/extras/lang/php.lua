local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
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
    formatters = { -- null-ls.nvim: builtins formatters
      nls.builtins.formatting.phpcsfixer,
    },
  },
}

return generate(conf)

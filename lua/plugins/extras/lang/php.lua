local generator = require("plugins.extras.langspec"):new()
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = "php",
  parsers = { -- nvim-treesitter: language parsers
    "php",
  },
}

if vim.fn.executable("php") == 1 then
  conf = vim.tbl_extend("force", conf, {
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
    formatters = { -- conform.nvim
      "php_cs_fixer",
    },
  })
end

return generator:generate(conf)

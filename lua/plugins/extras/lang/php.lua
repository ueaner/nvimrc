local generator = require("plugins.extras.langspec"):new()

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
    },
    formatters = { -- conform.nvim
      "php_cs_fixer",
    },
  } --[[@as LangConfig]])
end

return generator:generate(conf)

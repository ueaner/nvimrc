local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "toml",
  parsers = { -- nvim-treesitter: language parsers
    "toml",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "taplo",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      taplo = {},
    },
  },
}

return generator:generate(conf)

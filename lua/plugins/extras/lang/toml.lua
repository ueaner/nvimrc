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
      taplo = {
        filetypes = { "toml" },
        -- This is necessary for using taplo LSP in non-git repositories.
        root_dir = require("lspconfig.util").root_pattern("*.toml", ".git"),
      },
    },
  },
}

return generator:generate(conf)

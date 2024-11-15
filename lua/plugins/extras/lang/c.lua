local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  parsers = { -- nvim-treesitter: language parsers
    "c",
    "cpp",
    "proto",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "clangd",
    "clang-format",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      ---@type lspconfig.options.clangd
      clangd = {},
    },
  },
  formatters = { -- conform.nvim
    "clang-format",
  },
}

return generator:generate(conf)

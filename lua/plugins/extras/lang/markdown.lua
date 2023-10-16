local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = { "markdown", "markdown.mdx" },
  parsers = { -- nvim-treesitter: language parsers
    "markdown",
    "markdown_inline",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "prettier",
  },
  formatters = { -- conform.nvim
    "prettier",
  },
}

return generator:generate(conf)

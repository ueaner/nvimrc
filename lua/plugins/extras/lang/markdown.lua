local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = { "markdown", "markdown.mdx" },
  parsers = { -- nvim-treesitter: language parsers
    "markdown",
    "markdown_inline",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "prettierd",
  },
  formatters = { -- conform.nvim
    "prettierd",
  },
}

return generator:generate(conf)

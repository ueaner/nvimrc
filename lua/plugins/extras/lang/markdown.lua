local generator = require("plugins.extras.langspec"):new()

-- Register the markdown.mdx filetype
-- au BufRead,BufNewFile *.mdx   setlocal ft=markdown.mdx
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

-- Register the markdown parser for markdown.mdx files
vim.treesitter.language.register("markdown", "markdown.mdx")

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

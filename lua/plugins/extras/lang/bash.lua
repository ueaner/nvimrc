local generator = require("plugins.extras.langspec"):new()

-- Register the bash parser for zsh
vim.treesitter.language.register("bash", "zsh")
-- lua= vim.treesitter.language.get_filetypes("bash")
-- lua= vim.treesitter.language.get_lang("zsh")

---@type LangConfig
local conf = {
  ft = { "sh", "bash", "zsh" },
  parsers = { -- nvim-treesitter: language parsers
    "bash",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "bash-language-server",
    "shfmt",
    "shellcheck", -- bashls is integrated, so no need to configure `null-ls` diagnostics
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      ---@type lspconfig.options.bashls
      bashls = {},
    },
  },
  formatters = { -- conform.nvim
    "shfmt",
  },
}

return generator:generate(conf)

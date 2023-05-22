local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = "yaml",
  parsers = { -- nvim-treesitter: language parsers
    "yaml",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "yaml-language-server",
    "yamllint",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      },
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.diagnostics.yamllint.with({
        filetypes = {
          "yaml",
          "yaml.ansible", -- show null-ls in statusline
        },
      }),
    },
  },
}

return generate(conf)

local generator = require("plugins.extras.langspecs"):new()

---@type LangConfig
local conf = {
  ft = "yaml.ansible",
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "ansible-language-server",
    -- https://github.com/microsoft/vscode-python/issues/14327#issuecomment-757408341
    "ansible-lint", -- ansiblels is integrated, so no need to configure `null-ls` diagnostics
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      ansiblels = {},
    },
  },
}
local specs = generator:generate(conf)

-- table.insert(specs, {
--   "mfussenegger/nvim-ansible",
--   event = "VeryLazy",
-- })

return specs

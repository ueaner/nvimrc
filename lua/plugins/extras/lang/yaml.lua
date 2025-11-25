local generator = require("plugins.extras.langspec"):new()

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
    ---@type table<string, vim.lsp.Config>
    servers = { -- nvim-lspconfig: setup lspconfig servers
      yamlls = {
        -- Have to add this for yamlls to understand that we support line folding
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        -- lazy-load schemastore when needed
        before_init = function(_, new_config)
          new_config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
            schemaStore = {
              -- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
          },
        },
      },
    },
  },
  linters = { -- nvim-lint
    "yamllint",
  },
}

return generator:generate(conf)

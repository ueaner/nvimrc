local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "json",
  parsers = { -- nvim-treesitter: language parsers
    "json",
    "json5",
    "jsonc",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      ---@type lspconfig.options.jsonls
      jsonls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      },
    },
  },
}

return generator:generate(conf)

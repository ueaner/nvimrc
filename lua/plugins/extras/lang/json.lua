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
    ---@type table<string, vim.lsp.Config>
    servers = { -- nvim-lspconfig: setup lspconfig servers
      jsonls = {
        -- lazy-load schemastore when needed
        before_init = function(_, new_config)
          new_config.settings.json.schemas =
            vim.tbl_deep_extend("force", new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
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

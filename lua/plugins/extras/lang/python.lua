local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "python",
  parsers = { -- nvim-treesitter: language parsers
    "python",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "pyright",
    -- "black",
    "ruff",
    "debugpy",
  },
  lsp = {
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- "openFilesOnly",
            },
          },
        },
      },
      ruff = { -- linter
        init_options = {
          settings = {
            args = { "--max-line-length=180" },
          },
        },
        keys = {
          { "<leader>cI", U.lsp.action["source.organizeImports"], desc = "Organize Imports" },
        },
      },
    },
  },
  formatters = { -- conform.nvim
    -- To fix auto-fixable lint errors.
    "ruff_fix",
    -- To run the Ruff formatter.
    "ruff_format",
    -- To organize the imports.
    "ruff_organize_imports",
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        -- https://github.com/mfussenegger/nvim-dap-python#usage
        require("dap-python").setup("uv")
      end,
    },
  },
  test = { -- neotest: language specific adapters
    "nvim-neotest/neotest-python",
    adapters = {
      -- https://github.com/nvim-neotest/neotest-python/blob/master/lua/neotest-python/init.lua#L72
      -- match_root_pattern: touch pyproject.toml in project root directory
      --
      -- ├── foo_test.py
      -- └── pyproject.toml
      --
      ["neotest-python"] = {
        dap = { justMyCode = false },
      },
    },
  },
}

return generator:generate(conf)

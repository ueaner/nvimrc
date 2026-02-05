local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "python",
  parsers = { -- nvim-treesitter: language parsers
    "python",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    -- "ty",
    "basedpyright",
    -- "pyright",
    -- "mypy",
    "ruff",
    "debugpy",
  },
  lsp = {
    servers = {
      basedpyright = {
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              typeCheckingMode = "basic", -- strict
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- openFilesOnly
            },
          },
        },
      },
      -- ty 默认支持自动导入和库代码类型解析，无需手动开启
      -- ty = { -- type checker
      --   diagnosticMode = "workspace",
      -- },
      ruff = { -- linter
        init_options = {
          settings = {
            args = { "--max-line-length=140" },
          },
        },
        keys = {
          { "<leader>ci", U.lsp.action["source.organizeImports"], desc = "Organize Imports" },
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
  linters = { -- nvim-lint
    -- "mypy",
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

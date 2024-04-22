local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "python",
  parsers = { -- nvim-treesitter: language parsers
    "python",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "pyright",
    "black",
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
          {
            "<leader>cI",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
        },
      },
    },
  },
  formatters = { -- conform.nvim
    "black",
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      end,
      -- stylua: ignore
      on_ft = function(event)
        vim.keymap.set("n", "<leader>dC", function() require("dap-python").test_class() end,
          { buffer = event.buf, desc = "Debug Class" })
        vim.keymap.set("n", "<leader>dM", function() require("dap-python").test_method() end,
          { buffer = event.buf, desc = "Debug Method" })
        vim.keymap.set("v", "<leader>dS", function() require("dap-python").debug_selection() end,
          { buffer = event.buf, desc = "Debug Selection" })
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

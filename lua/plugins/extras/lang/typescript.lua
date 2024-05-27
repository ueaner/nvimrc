local generator = require("plugins.extras.langspec"):new()
local UDap = require("util.dap")

---@type LangConfig
local conf = {
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  parsers = { -- nvim-treesitter: language parsers
    "css",
    "html",
    "javascript",
    "jsdoc",
    "typescript",
    "tsx", -- typescriptreact
    "glimmer", -- .hbs
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "js-debug-adapter",
    "firefox-debug-adapter",
    "prettier",
    "eslint-lsp", -- pnpm install -g eslint
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      ---@type lspconfig.options.tsserver
      tsserver = {
        keys = {
          {
            "<leader>cI",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
          {
            "<leader>cu",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused Imports",
          },
        },
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      },
      cssls = {
        settings = {
          css = { validate = false },
        },
      },
    },
  },
  formatters = { -- conform.nvim
    "prettier",
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "mxsdev/nvim-dap-vscode-js",
      config = function()
        local dap = require("dap")
        if not dap.adapters["pwa-node"] then
          dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              -- 💀 Make sure to update this path to point to your installation
              args = {
                -- ~/.local/share/nvim/mason/bin/js-debug-adapter
                require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                  .. "/js-debug/src/dapDebugServer.js",
                "${port}",
              },
            },
          }
        end
        dap.adapters.firefox = {
          type = "executable",
          command = "node",
          args = {
            require("mason-registry").get_package("firefox-debug-adapter"):get_install_path()
              .. "/dist/adapter.bundle.js",
          },
        }
        for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file (" .. language .. ")",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach (" .. language .. ")",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },

            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file with arguments (" .. language .. ")",
              program = "${file}",
              args = UDap.get_args,
              cwd = "${workspaceFolder}",
            },

            {
              name = "Launch Firefox to debug client",
              type = "firefox",
              request = "launch",
              reAttach = true,
              url = "http://localhost:1420",
              webRoot = "${workspaceFolder}",
              firefoxExecutable = "/usr/bin/firefox",
            },
          }
        end
      end,
    },
  },
  test = { -- neotest: language specific adapters
    "nvim-neotest/neotest-jest",
    adapters = {
      ["neotest-jest"] = {
        -- jestCommand = "npm test --",
        jestCommand = "jest --watch ",
      },
    },
  },
}

return generator:generate(conf)

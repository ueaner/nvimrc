local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
---@diagnostic disable-next-line: missing-fields
local conf = {
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  parsers = { -- nvim-treesitter: language parsers
    "css",
    "html",
    "javascript",
    "jsdoc",
    "typescript",
    "tsx", -- typescriptreact
  },
}

if vim.fn.executable("node") == 1 then
  conf = vim.tbl_extend("force", conf, {
    cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
      "css-lsp",
      "html-lsp",
      "vtsls",
      --- "typescript-language-server",
      -- "tsc",
      "js-debug-adapter",
      -- "firefox-debug-adapter",
      -- "prettier",
      "oxfmt",
      -- "eslint-lsp", -- pnpm install -g eslint
      "oxlint", -- Create .oxlintrc.json in the project root directory
    },
    lsp = {
      servers = { -- nvim-lspconfig: setup lspconfig servers
        --- 暂时使用 typescript
        tsc = { enabled = false },
        ts_ls = { enabled = false },
        ---@type lspconfig.settings.vtsls
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        cssls = {
          init_options = { provideFormatter = false },
          settings = {
            css = { validate = false },
          },
        },
        ---@type lspconfig.settings.oxlint
        oxlint = {
          root_dir = function(bufnr, on_dir)
            -- prefer the top-level oxlint config if it exists (monorepo support)
            local git = vim.fs.root(bufnr, ".git")
            local markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
            local root = git and vim.fs.root(git, markers) or vim.fs.root(bufnr, markers)
            if root then
              on_dir(root)
            end
          end,
          settings = {
            fixKind = "all",
          },
        },
      },
    },
    formatters = { -- conform.nvim
      "oxfmt",
    },
    linters = { -- nvim-lint: linters
      "oxlint",
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
                  vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                  "${port}",
                },
              },
            }
          end
          -- dap.adapters.firefox = {
          --   type = "executable",
          --   command = "node",
          --   args = {
          --     vim.fn.stdpath("data") .. "/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js",
          --   },
          -- }

          local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

          local vscode = require("dap.ext.vscode")
          vscode.type_to_filetypes["node"] = js_filetypes
          vscode.type_to_filetypes["pwa-node"] = js_filetypes

          for _, language in ipairs(js_filetypes) do
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
                args = U.dap.get_args,
                cwd = "${workspaceFolder}",
              },

              -- {
              --   name = "Launch Firefox to debug client",
              --   type = "firefox",
              --   request = "launch",
              --   reAttach = true,
              --   url = "http://localhost:1420",
              --   webRoot = "${workspaceFolder}",
              --   firefoxExecutable = "/usr/bin/firefox",
              -- },
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
  })
end

return generator:generate(conf)

local generator = require("plugins.extras.langspec"):new()

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
}

if vim.fn.executable("node") == 1 then
  conf = vim.tbl_extend("force", conf, {
    cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
      "css-lsp",
      "html-lsp",
      "vtsls",
      "js-debug-adapter",
      -- "firefox-debug-adapter",
      "prettier",
      "eslint-lsp", -- pnpm install -g eslint
    },
    lsp = {
      servers = { -- nvim-lspconfig: setup lspconfig servers
        ---@type lspconfig.options.vtsls
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
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = U.config.sidebar.width,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gd",
              function()
                local params = vim.lsp.util.make_position_params()
                U.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gr",
              function()
                U.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>cO",
              U.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              U.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              U.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cf",
              U.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
          },
        },
        cssls = {
          settings = {
            css = { validate = false },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          U.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client.request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
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

local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

local function get_codelldb()
  local mason_registry = require("mason-registry")
  local codelldb = mason_registry.get_package("codelldb")
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  return codelldb_path, liblldb_path
end

---@type LangConfig
local conf = {
  ft = "rust",
  parsers = { -- nvim-treesitter: language parsers
    "rust",
    "ron",
    "toml",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "rust-analyzer",
    "rustfmt", -- bashls is integrated, so no need to configure `null-ls` diagnostics
    "codelldb",
    "taplo",
  },
  lsp = {
    servers = { -- nvim-lspconfig: lspconfig servers settings with filetype
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              -- allFeatures = true,
              features = { "gnome" },
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            check = {
              command = "cargo clippy",
              features = "all",
              -- features = "gnome",
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
    },
    setup = { -- nvim-lspconfig: setup lspconfig servers, see https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
      rust_analyzer = function(_, opts)
        local rt = require("rust-tools")
        local codelldb_path, liblldb_path = get_codelldb()
        require("lazyvim.util").on_attach(function(client, bufnr)
          -- stylua: ignore
          if client.name == "rust_analyzer" then
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr }) -- open hover action window
            -- Use `cargo init --name xxx` to create a separate project for debugging
            vim.keymap.set("n", "<leader>dr", rt.debuggables.debuggables, { buffer = bufnr, desc = "Run Debug (Debuggables)" })
            vim.keymap.set("n", "<leader>rA", rt.runnables.runnables, { buffer = bufnr, desc = "Runnables" })
            vim.keymap.set("n", "<leader>cR", function() vim.lsp.codelens.refresh() end, { buffer = bufnr, desc = "Refresh Code Lens" })
            vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.run() end, { buffer = bufnr, desc = "Code Lens" })
          end
        end)

        require("rust-tools").setup({
          tools = {
            hover_actions = { border = "solid" },
            on_initialized = function()
              vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                pattern = { "*.rs" },
                callback = function()
                  vim.lsp.codelens.refresh()
                end,
              })
            end,
          },
          server = opts,
          dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        })

        -- local codelldb_path, _ = get_codelldb()
        local dap = require("dap")
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          host = "127.0.0.1",
          executable = {
            command = codelldb_path,
            args = { "--liblldb", liblldb_path, "--port", "${port}" },

            -- On windows you may have to uncomment this:
            -- detached = false,
          },
        }
        -- dap.configurations.rust = {
        --   {
        --     name = "Launch file",
        --     type = "codelldb",
        --     request = "launch",
        --     program = function()
        --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        --     end,
        --     cwd = "${workspaceFolder}",
        --     stopOnEntry = false,
        --     args = {},
        --   },
        -- }

        -- dap.configurations.c = dap.configurations.rust
        -- dap.configurations.cpp = dap.configurations.rust

        -- .vscode/launch.json example:
        -- ```json
        -- {
        --     "version": "0.2.0",
        --     "configurations": [
        --         {
        --             "name": "Launch file (rt_lldb)",
        --             "type": "rt_lldb",
        --             "request": "launch",
        --             "cwd": "${workspaceFolder}",
        --             "program": "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        --             "stopOnEntry": false,
        --             "args": [
        --                 "${workspaceFolder}/example/config.yml"
        --             ]
        --         }
        --     ]
        -- }
        -- ```
        -- a nil path defaults to .vscode/launch.json
        require("dap.ext.vscode").load_launchjs(nil, { rt_lldb = { "rust" } })

        return true
      end,

      taplo = function(_, _)
        local crates = require("crates")
        local function show_documentation()
          if vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
            crates.show_popup()
          else
            vim.lsp.buf.hover()
          end
        end
        require("lazyvim.util").on_attach(function(client, bufnr)
            -- stylua: ignore
            if client.name == "taplo" then
              vim.keymap.set("n", "K", show_documentation, { buffer = bufnr, desc = "Show Crate Documentation" })
            end
        end)
        return false -- make sure the base implementation calls taplo.setup
      end,
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.rustfmt,
    },
  },
  dap = { -- nvim-dap: language specific extensions
  },
  test = { -- neotest: language specific adapters
    {
      "rouge8/neotest-rust",
      adapter_fn = function()
        return require("neotest-rust")({
          args = { "--no-capture" },
          dap_adapter = "codelldb", -- rt_lldb
        })
      end,
    },
  },
}

return generate(conf)
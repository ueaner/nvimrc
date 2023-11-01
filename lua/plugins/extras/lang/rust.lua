local notify = require("lazy.core.util")
local UDap = require("utils.dap")
local generator = require("plugins.extras.langspec"):new()

local function get_codelldb()
  local mason_registry = require("mason-registry")
  local codelldb = mason_registry.get_package("codelldb")
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  if vim.fn.has("mac") == 1 then
    liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
  end
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
    "codelldb",
    "taplo",
  },
  lsp = {
    servers = { -- nvim-lspconfig: lspconfig servers settings with filetype
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              -- features = { "gnome" },
              -- features = "all",
              buildScripts = {
                enable = false,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            check = {
              command = "cargo clippy",
              -- features = "all",
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
        local codelldb_path, liblldb_path = get_codelldb()

        require("utils.lsp").on_attach(function(client, bufnr)
          -- stylua: ignore
          if client.name == "rust_analyzer" then
            -- open hover action window
            vim.keymap.set("n", "K", "<cmd>RustHoverActions<cr>", { buffer = bufnr, desc = "Hover Actions" })
            -- Use `cargo init --name xxx` to create a separate project for debugging
            vim.keymap.set("n", "<leader>dr", "<cmd>RustDebuggables<cr>", { buffer = bufnr, desc = "Run Debuggables" })
            vim.keymap.set("n", "<leader>rA", "<cmd>RustRunnables<cr>", { buffer = bufnr, desc = "Run Runnables" })
          end
        end)

        require("rust-tools").setup({
          tools = {
            hover_actions = { border = "solid" },
            on_initialized = function()
              vim.cmd([[
                augroup RustLSP
                  autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                augroup END
              ]])
            end,
            inlay_hints = {
              auto = false,
            },
          },
          server = opts,
          dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        })

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

        dap.configurations.rust = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            -- program = function()
            --   return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            --   return vim.fn.input("Path to executable: ", "~/.target/debug/", "file")
            -- end,
            program = function()
              local workspaceFolderBasename = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              -- ~/.cargo/config.toml: build.target-dir
              local debug_bin = vim.fn.expand("~/.target/debug/" .. workspaceFolderBasename)
              if vim.fn.executable(debug_bin) == 1 then
                return debug_bin
              end
              notify.warn("Unable to find executable for '" .. debug_bin .. "'", { title = "DAP" })
              return dap.ABORT
            end,
            args = {},
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file (cargo build)",
            preLaunchTask = "cargo build",
            -- ~/.cargo/config.toml: build.target-dir
            program = "~/.target/debug/${workspaceFolderBasename}",
            args = {},
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file with arguments",
            program = "~/.target/debug/${workspaceFolderBasename}",
            args = UDap.get_args,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file with arguments (cargo build)",
            preLaunchTask = "cargo build",
            program = "~/.target/debug/${workspaceFolderBasename}",
            args = UDap.get_args,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }

        -- dap.configurations.c = dap.configurations.rust
        -- dap.configurations.cpp = dap.configurations.rust

        -- .vscode/launch.json example:
        -- ```json
        -- {
        --     "version": "0.2.0",
        --     "configurations": [
        --         {
        --             "name": "Launch file (codelldb)",
        --             "type": "codelldb",
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
        require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "rust" } })

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
        require("utils.lsp").on_attach(function(client, bufnr)
          -- stylua: ignore
          if client.name == "taplo" then
            vim.keymap.set("n", "K", show_documentation, { buffer = bufnr, desc = "Show Crate Documentation" })
          end
        end)
        return false -- make sure the base implementation calls taplo.setup
      end,
    },
  },
  formatters = { -- conform.nvim
    "rustfmt",
  },
  dap = { -- nvim-dap: language specific extensions
  },
  test = { -- neotest: language specific adapters
    -- cargo install cargo-nextest --locked
    "rouge8/neotest-rust",
    adapters = {
      ["neotest-rust"] = {
        --- args = { "--no-capture" }, -- DON'T USE `--no-capture`
        dap_adapter = "codelldb", -- codelldb is the default adapter used for debugging.
      },
    },
  },
}

return generator
  :prepend(
    { "simrat39/rust-tools.nvim", ft = { "rust" } },
    -- crates cmp source
    {
      "nvim-cmp",
      dependencies = {
        {
          "Saecki/crates.nvim",
          event = { "BufRead Cargo.toml" },
          opts = {
            src = {
              cmp = { enabled = true },
            },
          },
        },
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
          { name = "crates", group_index = 2 },
        }))
      end,
    }
  )
  :generate(conf)

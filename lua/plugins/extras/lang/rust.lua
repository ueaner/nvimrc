local function get_codelldb()
  local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  if vim.fn.has("mac") == 1 then
    liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
  end
  return codelldb_path, liblldb_path
end

return {

  -- crates cmp source
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = { enabled = true },
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
  },

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "ron",
        "rust",
        "toml",
      })
    end,
  },

  -- Ensure Rust debugger is installed
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer",
        "codelldb",
        "taplo",
      })
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              buildScripts = {
                enable = false,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              command = "cargo clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local codelldb_path, liblldb_path = get_codelldb()
      ---@type RustaceanOpts
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      vim.g.rustaceanvim.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
      }

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
            LazyUtil.warn("Unable to find executable for '" .. debug_bin .. "'", { title = "DAP" })
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
          args = U.dap.get_args,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file with arguments (cargo build)",
          preLaunchTask = "cargo build",
          program = "~/.target/debug/${workspaceFolderBasename}",
          args = U.dap.get_args,
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
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("rustaceanvim.neotest"),
      })
    end,
  },
}

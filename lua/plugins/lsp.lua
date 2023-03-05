return {
  -- cmdline tools and lsp servers
  -- https://github.com/williamboman/mason.nvim/tree/main/lua/mason-registry
  -- https://github.com/williamboman/mason.nvim/blob/main/lua/mason-core/package/init.lua#L39-L47
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua
        "lua-language-server",
        "stylua",
        -- "selene", -- linter
        -- shell
        "bash-language-server",
        "shfmt",
        "shellcheck", -- bashls integrated
        -- golang
        "gopls",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver", -- Wraps golangci-lint as a language server
        --"staticcheck",
        "delve",
        -- typescript/javascript
        "prettierd",
      },
    },
  },

  -- formatters
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- lua
          nls.builtins.formatting.stylua,
          -- shell
          nls.builtins.formatting.shfmt,
          -- golang
          nls.builtins.formatting.goimports,
          -- typescript/javascript
          nls.builtins.formatting.prettierd,
        },
      }
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                library = {
                  "~/.config/luameta",
                  -- Make the server aware of Neovim runtime files
                  vim.fn.expand("$VIMRUNTIME/lua"),
                  vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                },
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = {
                  "vim",
                  "require",
                },
              },
            }, -- end Lua
          },
        },
      },
    },
  },

  -- language specific extension modules
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "plugins.extras.lang.plantuml" },
  { import = "plugins.extras.lang.markdown" },
  -- { import = "plugins.extras.lang.go" },
  -- { import = "plugins.extras.lang.lua" },
  -- { import = "plugins.extras.lang.bash" },
}

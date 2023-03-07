local list_extend = require("utils").list_extend
local list_remove = require("utils").list_remove

return {
  -- cmdline tools and lsp servers
  -- https://github.com/williamboman/mason.nvim/tree/main/lua/mason-registry
  -- https://github.com/williamboman/mason.nvim/blob/main/lua/mason-core/package/init.lua#L39-L47
  -- :lua =require("mason-lspconfig").get_installed_servers()
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      list_extend(opts.ensure_installed, {
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
        -- Use `prettierd` formatting markdown files
        "prettierd",
      })

      -- filter flake8
      list_remove(opts.ensure_installed, "flake8")
    end,
  },

  -- formatters
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting
  -- :lua =require("null-ls").get_sources()
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      list_extend(opts.sources, {
        -- lua
        nls.builtins.formatting.stylua,
        -- shell
        nls.builtins.formatting.shfmt,
        -- golang
        nls.builtins.formatting.goimports,
        -- markdown
        nls.builtins.formatting.prettierd.with({
          filetypes = { "markdown" },
        }),
      })
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
}

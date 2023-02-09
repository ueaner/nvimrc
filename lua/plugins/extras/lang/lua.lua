return {

  -- add lua to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local packages = { "lua" }
        vim.list_extend(opts.ensure_installed, packages, 1, #packages)
      end
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- :lua =require("mason-lspconfig").get_installed_servers()
      local packages = {
        "lua-language-server",
        "stylua",
        "selene", -- linter: enhance lua diagnostics
      }
      vim.list_extend(opts.ensure_installed, packages, 1, #packages)
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      ---@type lspconfig.options
      servers = {
        sumneko_lua = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                library = {
                  "~/.config/luameta",
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
                },
              },
            }, -- end Lua
          },
        },
      },
    },
  },

  -- formatters & linter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.selene.with({
            condition = function(utils)
              return utils.root_has_file({ "selene.toml" })
            end,
          }),
        },
      }
    end,
  },
}

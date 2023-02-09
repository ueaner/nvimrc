return {

  -- add bash to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local packages = { "bash" }
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
        "bash-language-server",
        "shfmt",
        "shellcheck", -- bashls integrated
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
        bashls = {},
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
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
}

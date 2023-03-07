local list_extend = require("utils").list_extend

return {

  -- add php to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      list_extend(opts.ensure_installed, {
        "php",
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      list_extend(opts.ensure_installed, {
        "phpactor",
        "php-cs-fixer",
      })
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- phpactor will be automatically installed with mason and loaded with lspconfig
      ---@type lspconfig.options
      servers = {
        phpactor = {},
      },
    },
  },

  -- formatters & linter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      list_extend(opts.ensure_installed, {
        nls.builtins.formatting.phpcsfixer,
      })
    end,
  },

  -- DAP
  -- test
}

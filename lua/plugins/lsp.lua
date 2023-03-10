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
        -- markdown
        nls.builtins.formatting.prettierd.with({
          filetypes = { "markdown" },
        }),
      })
    end,
  },
}

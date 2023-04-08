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
    end,
  },

  -- formatters
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting
  -- :lua =require("null-ls").get_sources()
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      list_extend(opts.sources, {
        nls.builtins.code_actions.refactoring,
        -- format tables in markdown
        nls.builtins.formatting.prettierd.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "markdown",
            "markdown.mdx",
          },
        }),
      })

      list_remove(opts.sources, nls.builtins.formatting.fish_indent)
      list_remove(opts.sources, nls.builtins.diagnostics.fish)
    end,
  },
}

-- Coding Features: auto completion, snippets, comments, refactoring, auto pairs, etc.
return {
  -- prettier lsp server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Use `prettierd` formatting markdown files
        "prettierd",
      })
    end,
  },

  -- formatters
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
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
    end,
  },
}

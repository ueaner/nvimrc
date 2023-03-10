local list_extend = require("utils").list_extend

-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
-- List of installed treesitter parsers `:checkhealth nvim-treesitter`
-- installation directory: ~/.local/share/nvim/lazy/nvim-treesitter/parser
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      list_extend(opts.ensure_installed, {
        "query",
        "regex",
        "lua",
        "vim",
        "help",
        "markdown",
        "markdown_inline",
        "html",
        "javascript",
        "tsx",
        "typescript",
        "http",
        "json",
        "jsonc",
        "yaml",
        "comment", -- NOTE TODO FIXME ...
        "diff",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "sql",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },

  -- Motions based on syntax trees
  -- Use v, d, c, y to visually select/delete/change/yank, then press m
  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<cr>
        xnoremap <silent> m :lua require('tsht').nodes()<cr>
      ]])
    end,
  },
}

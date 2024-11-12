return {
  -- HTTP Client
  -- treesitter: http, json, graphql
  -- for rest.nvim:
  -- sudo dnf install compat-lua-libs-5.1.5 compat-lua-devel-5.1.5 compat-lua-5.1.5 luajit-devel luarocks
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      default_view = "headers_body",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "http",
        "graphql",
      })
    end,
  },
}

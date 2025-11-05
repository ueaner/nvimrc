return {
  -- HTTP Client
  -- treesitter: http, json, graphql
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

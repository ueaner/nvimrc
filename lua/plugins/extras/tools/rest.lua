return {
  -- HTTP Client
  -- treesitter: http, json
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_env = "default",
      ui = {
        default_view = "headers_body",
        default_winbar_panes = { "body", "headers", "verbose", "script_output", "report" },
      },
      lsp = {
        enable = true,
        filetypes = { "http", "rest", "javascript", "typescript", "lua" },
      },
      treesitter = {
        enable = false,
      },
    },
  },

  {
    "neovim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http" })
    end,
  },
}

return {
  -- HTTP Client
  -- treesitter: http, json
  -- sudo dnf install compat-lua-libs-5.1.5 compat-lua-devel-5.1.5 compat-lua-5.1.5 luajit-devel luarocks
  -- /usr/bin/lua-5.1
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 0,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "http",
      })
    end,
  },
}

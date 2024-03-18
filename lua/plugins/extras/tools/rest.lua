return {
  -- http client, treesitter: http, json
  {
    "rest-nvim/rest.nvim",
    version = "^1.2.1",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- keys = {
    --   { "<leader>rr", "<Plug>RestNvim", desc = "Run Http request", ft = "http" },
    --   { "<leader>r.", "<Plug>RestNvimLast", desc = "Run Last Http request", ft = "http" },
    -- },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("http", function(event)
        vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { desc = "Run Http request", buffer = event.buf })
        vim.keymap.set("n", "<leader>r.", "<Plug>RestNvimLast", { desc = "Run Last Http request", buffer = event.buf })
      end)
    end,
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
}

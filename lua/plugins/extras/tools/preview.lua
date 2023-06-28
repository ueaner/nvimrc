return {
  -- browse and preview json files
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },

  -- markdown preview in terminal
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    cmd = { "Glow" },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fv", "<cmd>Glow!<cr>", { desc = "Glow Preview (Markdown)", buffer = event.buf })
      end)
    end,
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
        border = "rounded",
      })
    end,
  },

  -- markdown preview in browser
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    cond = function()
      return vim.fn.executable("deno") == 1
    end,
    init = function()
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fo", function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end, { desc = "Live Preview (Markdown)", buffer = event.buf })
      end)
    end,
    opts = {
      theme = "light",
      app = "browser",
    },
  },
}

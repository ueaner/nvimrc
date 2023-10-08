return {
  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    config = function()
      require("ibl").setup({
        indent = { char = "│", tab_char = "│" },
        exclude = {
          filetypes = require("config").excluded_filetypes,
        },
      })
    end,
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    event = "LazyFile",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = require("config").excluded_filetypes,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- auto detect indent
  {
    "timakro/vim-yadi",
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        callback = function()
          vim.cmd("DetectIndent")
        end,
      })
    end,
  },
}

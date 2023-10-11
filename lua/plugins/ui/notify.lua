return {
  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },

      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<Right>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i"}},
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<Left>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i"}},
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"n", "s"}},
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"n", "s"}},

      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<Del>" end end, silent = true, expr = true, desc = "Scroll down", mode = {"i"}},
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<C-G>u<C-U>" end end, silent = true, expr = true, desc = "Scroll up", mode = {"i"}},
      { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, silent = true, expr = true, desc = "Scroll down", mode = {"n", "s"}},
      { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, silent = true, expr = true, desc = "Scroll up", mode = {"n", "s"}},
    },
  },

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    dependencies = { "folke/noice.nvim" },
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local U = require("utils")
      if not U.has("noice.nvim") then
        U.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
}

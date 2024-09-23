return {

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      ---@type wk.Spec
      spec = {
        -- { "<leader>t", group = "test" },
        { "<leader>t", group = "test", mode = "n" },
        { "<leader>t", group = "translate", mode = "x", desc = "Translate" },
        {
          mode = { "n", "v" },
          { "<leader>a", group = "a tool" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dw", group = "dap widgets" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>m", group = "manager/info" },
          { "<leader>n", group = "notes" },
          { "<leader>q", group = "quit/session" },
          { "<leader>r", group = "run/repl" },
          { "<leader>s", group = "search" },
          { "<leader>sn", group = "noice" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "z", group = "fold" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}

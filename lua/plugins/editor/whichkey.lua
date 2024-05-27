return {

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["z"] = { name = "+fold" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },

        ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
        ["<leader>dw"] = { name = "+dap widgets" },
        ["<leader>t"] = { name = "+test", mode = { "n" } },
        ["<leader>r"] = { name = "+run/repl", mode = { "n", "v" } },
        ["<leader>a"] = { name = "+a tool" },
        ["<leader>m"] = { name = "+manager/info" },
        ["<leader>n"] = { name = "+notes/noice" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)

      wk.register({
        ["<leader>t"] = { name = "+translate", mode = { "x" } },
      })
    end,
  },
}

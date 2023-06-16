return {
  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
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
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)

      wk.register({
        ["<leader>d"] = { name = "+debug", mode = { "n", "x" } },
        ["<leader>t"] = { name = "+test", mode = { "n" } },
        ["<leader>r"] = { name = "+run/REPL", mode = { "n", "x" } },
        ["<leader>D"] = { name = "+db" },
        ["<leader>a"] = { name = "+a tool" },
      })
      wk.register({
        ["<leader>t"] = { name = "+translate", mode = { "x" } },
      })

      if require("utils").has("noice.nvim") then
        wk.register({
          ["<leader>sn"] = { name = "+noice" },
        })
      end
    end,
  },
}

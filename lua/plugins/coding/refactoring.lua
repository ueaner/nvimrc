return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "ThePrimeagen/refactoring.nvim",
    },
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.refactoring,
      })
    end,
  },
}

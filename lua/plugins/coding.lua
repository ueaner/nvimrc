-- auto completion, refactoring, rename, etc.
return {
  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "lukas-reineke/cmp-rg",
      "rcarriga/cmp-dap",
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql" },
        init = function()
          require("utils").on_ft({ "sql", "mysql" }, function()
            vim.opt_local["omnifunc"] = "vim_dadbod_completion#omni"
          end)
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "rg" },
      }))

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
      cmp.setup.filetype({ "sql", "mysql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
        },
      })
    end,
  },
}

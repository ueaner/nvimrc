local list_extend = require("utils").list_extend

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
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(list_extend(opts.sources, {
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

      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },

  -- language specific extension modules
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "plugins.extras.lang.plantuml" },
  { import = "plugins.extras.lang.markdown" },
  { import = "plugins.extras.lang.php" },
  -- { import = "plugins.extras.lang.go" },
  -- { import = "plugins.extras.lang.lua" },
  -- { import = "plugins.extras.lang.bash" },
}

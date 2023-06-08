-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
-- List of installed treesitter parsers `:checkhealth nvim-treesitter`
-- installation directory: ~/.local/share/nvim/lazy/nvim-treesitter/parser
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
    keys = {
      { "<Space>", desc = "Increment selection" },
      { "<BS>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "query",
        "regex",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "html",
        "javascript",
        "tsx",
        "typescript",
        "http", -- rest.nvim
        "json",
        "jsonc",
        "yaml",
        "comment", -- NOTE TODO FIXME ...
        "diff",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "sql",
        "mermaid",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Space>",
          node_incremental = "<Space>",
          node_decremental = "<BS>",
          scope_incremental = false,
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },

  -- Motions based on syntax trees
  -- Use `v, c, d, y` to enter Operator-pending mode, and then press `m` to visually select/change/delete/yank
  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<cr>
        xnoremap <silent> m :lua require('tsht').nodes()<cr>
      ]])
    end,
  },
}

-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
-- List of installed treesitter parsers `:checkhealth nvim-treesitter`
-- installation directory: ~/.local/share/nvim/lazy/nvim-treesitter/parser
return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- Disable class keymaps in diff mode
          vim.api.nvim_create_autocmd("BufReadPost", {
            callback = function(event)
              if vim.wo.diff then
                for _, key in ipairs({ "[c", "]c", "[C", "]C" }) do
                  pcall(vim.keymap.del, "n", key, { buffer = event.buf })
                end
              end
            end,
          })
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
        "luadoc",
        "luap",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "comment", -- NOTE TODO FIXME ...
        "diff",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "sql",
        "csv",
        "ini",
        "ssh_config",
        "strace",
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
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
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

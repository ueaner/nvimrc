-- https://github.com/neovim-treesitter/nvim-treesitter#supported-languages-and-features
-- https://github.com/neovim-treesitter/nvim-treesitter/blob/main/lua/nvim-treesitter/parsers.lua
-- List of installed treesitter parsers `:checkhealth nvim-treesitter`
-- installation directory: ~/.local/share/nvim/site/parser
return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "neovim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    lazy = false,
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    cmd = { "TSCacheClear", "TSInstall", "TSLog", "TSStatus", "TSUninstall", "TSUpdate" },
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
        "tsv",
        "ini",
        "ssh_config",
        "strace",
        "mermaid",
      },
      textobjects = {
        move = {
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = U.dedup(opts.ensure_installed)
      end

      local ts = require("nvim-treesitter")
      ts.setup()

      if type(opts.ensure_installed) == "table" and #opts.ensure_installed > 0 then
        ts.install(opts.ensure_installed)
      end

      local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not lang then
            return
          end

          if opts.highlight and opts.highlight.enable then
            pcall(vim.treesitter.start, event.buf, lang)
          end

          local has_indents = false
          pcall(function()
            has_indents = vim.treesitter.query.get(lang, "indents") ~= nil
          end)
          if has_indents and opts.indent and opts.indent.enable then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = function()
      return U.opts("nvim-treesitter").textobjects
    end,
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = opts.move.set_jumps } })

      local move = require("nvim-treesitter-textobjects.move")
      local labels = {
        goto_next_start = "Next start",
        goto_next_end = "Next end",
        goto_previous_start = "Previous start",
        goto_previous_end = "Previous end",
      }

      for method, mappings in pairs(opts.move) do
        if method:find("goto") == 1 then
          for key, query in pairs(mappings) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              -- In diff mode, keep Vim's native change motions on ]c/[c.
              if vim.wo.diff and key:find("[%]%[][cC]") then
                vim.cmd("normal! " .. key)
                return
              end
              move[method](query, "textobjects")
            end, { desc = labels[method], silent = true })
          end
        end
      end
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = { mode = "cursor", max_lines = 3 },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "]", group = "Treesitter next" },
        { "[", group = "Treesitter previous" },
      },
    },
  },
}

return {
  -- file explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer NvimTree (root dir)", mode = { "n", "t" } },
    },
    -- :help nvim-tree-setup  view default options
    opts = {
      filters = {
        -- hotkeys:
        -- I: toggle_git_ignored
        -- H: toggle_dotfiles
        -- C: toggle_git_clean
        -- B: toggle_no_buffer
        -- U: toggle_custom
        custom = {
          "node_modules$",
          ".git$",
          "go.mod$",
        },
      },
      disable_netrw = true,
      hijack_cursor = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = "left",
        width = 40,
        hide_root_folder = true,
        mappings = {
          list = {
            { key = "?", action = "toggle_help" },
          },
        },
      },
      renderer = {
        highlight_git = true,
        -- https://en.wikipedia.org/wiki/List_of_Unicode_characters
        -- https://www.nerdfonts.com/cheat-sheet
        -- https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.csv
        icons = {
          git_placement = "signcolumn", -- after, before or signcolumn
          glyphs = {
            bookmark = "炙", -- 
            git = {
              unstaged = "✗", -- ✘
              staged = "✓", -- ✔
              unmerged = "",
              renamed = "→", -- ➜
              untracked = "*", -- 
              deleted = "☓", -- ⚊ 
              ignored = "◌",
            },
          },
        },
      },
    },
  },

  -- outline
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    keys = { { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Aerial Outline" } },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 40 },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },

  -- fuzzy finder
  -- MORE: https://github.com/appelgriebsch/Nv/blob/main/lua/plugins/editor.lua#L56
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
    },
    keys = {
      {
        "<leader>fp",
        "<CMD>Telescope project display_type=full<CR>",
        desc = "Find project",
      },
    },

    opts = function(_, opts)
      -- remove <C-h> mapping
      opts.defaults.mappings.i["<C-h>"] = nil

      -- override
      opts.extensions = {
        project = {
          base_dirs = {
            "~/projects",
          },
        },
      }

      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("project")
    end,
  },

  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- which-key extensions
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
        ["<leader>t"] = { name = "+test" },
      })
    end,
  },

  -- auto-resize windows
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    keys = { { "<leader>z", "<cmd>WindowsMaximize<cr>", desc = "Zoom", mode = { "n", "t" } } },
    config = function()
      vim.o.winwidth = 5
      vim.o.equalalways = false
      require("windows").setup()
    end,
  },

  -- folke/twilight.nvim: dims inactive portions of the code
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 0.85, -- width of the Zen window
        height = 0.95, -- height of the Zen window
      },
    },
    keys = { { "<leader>Z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}

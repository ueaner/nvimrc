return {
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer", mode = { "n", "t" } },
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
    event = "VeryLazy",
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
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope<cr>", desc = "Telescope" },
      { "<leader>fp", "<cmd>Telescope project display_type=full<cr>", desc = "Find project" },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      extensions = {
        project = {
          base_dirs = {
            "~/projects",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("project")
      telescope.load_extension("fzf")
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    opts = { use_diagnostic_signs = true },
  },

  -- which-key extensions
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
        ["<leader>t"] = { name = "+test" },
        ["<leader>D"] = { name = "+db" },
        ["<leader>a"] = { name = "+a tool" },
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

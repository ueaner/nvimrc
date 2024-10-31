return {
  -- Easily create and manage predefined window layouts
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      ---@type table<Edgy.Pos, {size:integer | fun():integer, wo:vim.wo?}>
      options = {
        left = { size = U.config.sidebar.width },
        bottom = { size = U.config.panel.height },
        right = { size = U.config.sidebar.width },
        top = { size = U.config.panel.height },
      },
      bottom = {
        {
          ft = "terminal",
          title = "Terminal",
          size = { height = 0.3 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "noice",
          size = { height = 0.3 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "Trouble",
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 0.3 },
          -- don't open help files in edgy that we're editing
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "spectre_panel", size = { height = 0.3 } },
        { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 0.3 } },
        { title = "DB Query Result", ft = "dbout", size = { height = 0.3 } },
      },
      -- left = {
      --   -- Use `>`/`<` to switch git_status/buffers sources on the neo-tree window
      --   -- or use the telescope git_status/buffers commands
      --   {
      --     title = "FILE SYSTEM",
      --     ft = "neo-tree",
      --     filter = function(buf)
      --       return vim.b[buf].neo_tree_source == "filesystem"
      --     end,
      --     pinned = true,
      --     open = function()
      --       vim.api.nvim_input(vim.g.mapleader .. "e") -- <leader>e
      --     end,
      --     size = { height = 0.5 },
      --   },
      --   { title = "Neotest Summary", ft = "neotest-summary" },
      -- },
      right = {
        {
          title = "Aerial",
          ft = "aerial",
          open = "AerialOpen",
        },
        {
          title = "Outline",
          ft = "Outline",
          open = "Outline",
        },
        {
          title = "Database",
          ft = "dbui",
          pinned = true,
          open = "DBUIToggle",
        },
        {
          title = "Neotest Summary",
          ft = "neotest-summary",
        },
      },
      keys = {
        -- increase width
        ["<c-Right>"] = function(win)
          win:resize("width", 2)
        end,
        -- decrease width
        ["<c-Left>"] = function(win)
          win:resize("width", -2)
        end,
        -- increase height
        ["<c-Up>"] = function(win)
          win:resize("height", 2)
        end,
        -- decrease height
        ["<c-Down>"] = function(win)
          win:resize("height", -2)
        end,
      },
    },
  },

  -- use edgy's selection window
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        get_selection_window = function()
          require("edgy").goto_main()
          return 0
        end,
      },
    },
  },
}

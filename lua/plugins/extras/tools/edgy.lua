return {
  -- edgy
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<leader>ue", function() require("edgy").toggle() end, desc = "Edgy Toggle" },
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = {
      ---@type table<Edgy.Pos, {size:integer | fun():integer, wo?:vim.wo}>
      options = {
        left = { size = 40 },
        bottom = { size = 10 },
        right = { size = 40 },
        top = { size = 10 },
      },
      bottom = {
        {
          ft = "terminal",
          title = "Terminal",
          size = { height = 0.3 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "noice",
          size = { height = 0.3 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        "Trouble",
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
      },
      left = {
        -- Use `>`/`<` to switch git_status/buffers sources on the neo-tree window
        -- or use the telescope git_status/buffers commands
        {
          title = "Explorer",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          pinned = true,
          open = function()
            vim.api.nvim_input(vim.g.mapleader .. "e") -- <leader>e
          end,
          size = { height = 0.5 },
        },
        { title = "Neotest Summary", ft = "neotest-summary" },
      },
      right = {
        {
          title = "Outline",
          ft = "aerial",
        },
        {
          title = "Database",
          ft = "dbui",
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
}

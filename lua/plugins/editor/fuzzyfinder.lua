-- preview_cutoff = 120,
local layout_strategy = function()
  if vim.o.columns > vim.o.lines then
    return vim.o.columns >= 120 and "horizontal" or "vertical"
  else
    return vim.o.lines >= 40 and "vertical" or "horizontal"
  end
end

return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      {
        "nvim-telescope/telescope-cheat.nvim",
        dependencies = "kkharji/sqlite.lua",
        config = function()
          -- fix: https://github.com/nvim-telescope/telescope-cheat.nvim/issues/7
          local dbdir = vim.fn.stdpath("data") .. "/databases"
          if not vim.uv.fs_stat(dbdir) then
            vim.uv.fs_mkdir(dbdir, 493)
          end
        end,
      },
      {
        "dhruvmanila/browser-bookmarks.nvim",
        version = "*",
        config = function()
          require("browser_bookmarks").setup({
            selected_browser = "chrome",
          })
        end,
      },
      { "polirritmico/telescope-lazy-plugins.nvim" },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      local layout = require("telescope.actions.layout")

      local open_with_trouble = require("trouble.sources.telescope").open

      return {
        ---@type Picker
        defaults = {
          -- path_display = {
          --   shorten = { len = 1, exclude = { 1, -1 } },
          -- },
          dynamic_preview_title = true,
          layout_strategy = layout_strategy(),

          layout_config = { prompt_position = "top", height = 0.90, width = 0.95 },
          sorting_strategy = "ascending",
          winblend = 0,
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<C-x>"] = open_with_trouble,
              ["<A-x>"] = open_with_trouble,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              -- `<C-n/p>` for select result items
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<A-p>"] = layout.toggle_preview,
            },
            n = {
              ["q"] = actions.close,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<A-p>"] = layout.toggle_preview,
            },
          },
          -- require("telescope.config").values.vimgrep_arguments
        },
        pickers = {
          buffers = { sort_mru = true, sort_lastused = true },
          colorscheme = { enable_preview = true },
          lsp_document_symbols = { symbols = require("config").get_kind_filter() },
        },
        extensions = {
          project = {
            base_dirs = {
              "~/projects",
            },
            display_type = "full",
          },
          live_grep_args = {
            auto_quoting = true,
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("project")
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("cheat")
      telescope.load_extension("bookmarks")
      telescope.load_extension("lazy_plugins")
    end,
  },
}

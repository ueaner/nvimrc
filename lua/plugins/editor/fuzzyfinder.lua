local U = require("utils")

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
    },
    cmd = "Telescope",
    keys = {
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", "<cmd>Telescope live_grep_args<CR>", desc = "Grep (root dir)" },
      {
        "<leader>/",
        function()
          -- NOTE: There is an issue with the CJK character under the search cursor
          require("telescope-live-grep-args.shortcuts").grep_visual_selection({ postfix = false })
        end,
        desc = "Grep (root dir)",
        mode = { "v" },
      },
      {
        "<leader>sk",
        function()
          require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({ postfix = false })
        end,
        desc = "Grep keyword under cursor (root dir)",
        mode = { "n" },
      },

      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>Telescope<cr>", desc = "Telescope Builtin" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fB", "<cmd>Telescope bookmarks<cr>", desc = "Browser Bookmarks" },
      { "<leader>ff", U.telescope("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", U.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", U.telescope("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fp", "<cmd>Telescope project display_type=full<cr>", desc = "Find project" },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
      -- search
      { "<leader>si", "<cmd>Telescope cheat fd<cr>", desc = "Cheatsheets" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sg", U.telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", U.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sw", U.telescope("grep_string"), desc = "Word (root dir)" },
      { "<leader>sW", U.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      { "<leader>uC", U.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = function()
      local trouble = require("trouble.providers.telescope")
      local actions = require("telescope.actions")
      local layout = require("telescope.actions.layout")

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
              ["<C-x>"] = trouble.open_with_trouble,
              ["<A-x>"] = trouble.open_selected_with_trouble,
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
        extensions = {
          project = {
            base_dirs = {
              "~/projects",
            },
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
    end,
  },
}

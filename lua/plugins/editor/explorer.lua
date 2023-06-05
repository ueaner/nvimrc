return {
  -- file explorer
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   event = "VeryLazy",
  --   cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
  --   keys = {
  --     { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer", mode = { "n", "t" } },
  --   },
  --   -- :help nvim-tree-setup  view default options
  --   opts = {
  --     on_attach = function(bufnr)
  --       local api = require("nvim-tree.api")
  --       local function opts(desc)
  --         return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  --       end
  --       -- apply default mappings
  --       api.config.mappings.default_on_attach(bufnr)
  --       -- alternative default mappings
  --       vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  --     end,
  --     filters = {
  --       -- hotkeys:
  --       -- I: toggle_git_ignored
  --       -- H: toggle_dotfiles
  --       -- C: toggle_git_clean
  --       -- B: toggle_no_buffer
  --       -- U: toggle_custom
  --       custom = {
  --         "node_modules$",
  --         ".git$",
  --         "vendor$",
  --       },
  --     },
  --     filesystem_watchers = {
  --       enable = false,
  --     },
  --     git = {
  --       enable = false,
  --       ignore = true,
  --     },
  --     disable_netrw = true,
  --     hijack_cursor = true,
  --     update_focused_file = {
  --       enable = true,
  --       update_root = false,
  --     },
  --     view = {
  --       adaptive_size = false,
  --       side = "left",
  --       width = 40,
  --     },
  --     renderer = {
  --       root_folder_label = false,
  --       highlight_git = true,
  --       -- https://en.wikipedia.org/wiki/List_of_Unicode_characters
  --       -- https://www.nerdfonts.com/cheat-sheet
  --       -- https://raw.githubusercontent.com/microsoft/vscode-codicons/main/dist/codicon.csv
  --       icons = {
  --         git_placement = "signcolumn", -- after, before or signcolumn
  --         glyphs = {
  --           bookmark = "", -- 炙
  --           git = {
  --             unstaged = "✗", -- ✘
  --             staged = "✓", -- ✔
  --             unmerged = "",
  --             renamed = "→", -- ➜
  --             untracked = "*", -- 
  --             deleted = "☓", -- ⚊ 
  --             ignored = "◌",
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      -- stylua: ignore
      { "<leader>e", function() require("utils").fe().toggle() end, desc = "Toggle File Explorer", mode = { "n", "t" } },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["gy"] = function(state)
            local notify = require("lazy.core.util")
            local tree = state.tree
            local success, node = pcall(tree.get_node, tree)
            if node.type == "message" then
              return
            end
            if not (success and node) then
              notify.warn("Could not get node.")
              return
            end
            local path = node.path or node:get_id()
            vim.fn.setreg("+", path)
          end,

          ["<cr>"] = "open",
          ["o"] = "open",
          ["<esc>"] = "revert_preview",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "focus_preview",
          ["<space>"] = "close_node",
          ["z"] = "close_all_nodes",
          ["R"] = "refresh",
          ["a"] = {
            "add",
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = "none", -- "none", "relative", "absolute"
            },
          },
          ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
          ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
          ["e"] = "toggle_auto_expand_width",
          ["q"] = "close_window",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}

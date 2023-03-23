return {
  -- terminal
  {
    "NvChad/nvterm",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      -- `<Esc><Esc>` enter normal mode, then switch windows
      { "<leader>tt", function() require("nvterm.terminal").toggle("horizontal") end, desc = "toggle term", mode = { "n", "t" } },
    },
    config = function()
      require("nvterm").setup({
        terminals = {
          type_opts = {
            float = {
              border = "single",
              relative = "editor",
              row = 0.05,
              col = 0.05,
              width = 0.9,
              height = 0.82,
            },
          },
        },
      })
    end,
  },

  -- database explorer
  -- dependencies command line client: mysql-client, psql(postgresql client), sqlite3, redis-cli
  {
    "tpope/vim-dadbod",
    event = "VeryLazy",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
      },
    },
    cmd = { "DB" },
    keys = {
      -- stylua: ignore
      { "<leader>E", function() require("utils").db_explorer_toggle() end, desc = "Toggle Database Explorer", },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dbui"
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 40
      vim.g.db_ui_notification_width = 36
    end,
    config = function()
      require("utils").on_ft("dbui", function()
        -- 提示信息展示：只改变前景色和边框（如果支持边框的话，线条）
        vim.api.nvim_set_hl(0, "NotificationInfo", { link = "Normal" })
        vim.api.nvim_set_hl(0, "NotificationError", { link = "ErrorMsg" })
        vim.api.nvim_set_hl(0, "WarningMsg", { link = "WarningMsg" })
      end)
    end,
  },

  {
    "iberianpig/tig-explorer.vim",
    event = "VeryLazy",
    cmd = {
      "Tig",
      "TigOpenCurrentFile",
      "TigOpenProjectRootDir",
      "TigGrep",
      "TigBlame",
      "TigGrepResume",
      "TigStatus",
      "TigOpenFileWithCommit",
    },
    keys = {
      { "<leader>gt", "<cmd>Tig<cr>", desc = "Tig (git log)" },
    },
  },

  -- git diff view
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose", -- also can use :tabclose
      "DiffviewFileHistory",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (all modified files)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  },

  -- http client, treesitter: http, json
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- 最好可以和 neotest 兼容使用 ,tt 发起请求
      { "<leader>th", "<Plug>RestNvim", desc = "run http request" },
      { "<leader>tl", "<Plug>RestNvimLast", desc = "run last http request" },
      { "<leader>tc", "<Plug>RestNvimPreview", desc = "preview cURL command" },
    },
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 0,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
  },

  -- grpc client
  {
    "hudclark/grpc-nvim",
    ft = "grpc",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Grpc" },
    keys = {
      { "<leader>tg", "<cmd>Grpc<cr>", desc = "run grpc request" },
    },
  },

  -- browse and preview json files
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },

  {
    "tyru/open-browser.vim",
    cmd = {
      "OpenBrowser",
    },
  },

  -- table mode for markdown
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    cmd = {
      "TableModeToggle", -- automatic table formatter
      "Tableize", -- formatting existing content into a table
      "TableSort", -- sort by selected column
    },
    init = function()
      vim.g.table_mode_disable_mappings = 1
      vim.g.table_mode_disable_tableize_mappings = 1
      -- stylua: ignore
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>ut", "<cmd>TableModeToggle<cr>", { desc = "Toggle Table Mode", buffer = event.buf })
      end)
    end,
  },

  -- markdown preview in terminal
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    cmd = { "Glow" },
    init = function()
      -- stylua: ignore
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fv", "<cmd>Glow!<cr>", { desc = "Glow Preview (Markdown)", buffer = event.buf })
      end)
    end,
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
      })
    end,
  },

  -- markdown preview in browser
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    init = function()
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fo", function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end, { desc = "Live Preview (Markdown)", buffer = event.buf })
      end)
    end,
    opts = {
      theme = "light",
      app = "browser",
    },
  },

  -- mermaid syntax
  {
    "mracos/mermaid.vim",
    ft = { "mermaid", "markdown" },
  },

  -- plantuml syntax
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml", "markdown" },
  },

  -- plantuml preview in browser
  {
    "weirongxu/plantuml-previewer.vim",
    ft = "plantuml",
    cmd = {
      "PlantumlToggle",
      "PlantumlOpen",
      "PlantumlStart",
      "PlantumlStop",
      "PlantumlSave",
    },
    init = function()
      vim.g["plantuml_previewer#plantuml_jar_path"] = vim.env.XDG_LIB_HOME .. "/java/plantuml.jar"
      -- stylua: ignore
      require("utils").on_ft("plantuml", function(event)
        vim.keymap.set("n", "<leader>fo", "<cmd>PlantumlToggle<cr>", { desc = "Live Preview (Plantuml)", buffer = event.buf })
      end)
    end,
  },

  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    -- event = { "BufRead", "BufWinEnter", "BufNewFile" },
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftypes = { "*", "!prompt", "!nofile" },
      -- stylua: ignore
      user_default_options = {
        RGB      = true,  -- #RGB hex codes
        RRGGBB   = true,  -- #RRGGBB hex codes
        names    = false, -- "Name" codes like Blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        rgb_fn   = false, -- CSS rgb() and rgba() functions
        hsl_fn   = false, -- CSS hsl() and hsla() functions
        css      = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        tailwind = true,  -- Enable tailwind colors
        mode     = "background", -- Set the display mode.
      },
    },
  },
}

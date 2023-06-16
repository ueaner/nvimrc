return {
  -- code runner
  {
    "michaelb/sniprun",
    enabled = false,
    event = "VeryLazy",
    build = "bash ./install.sh",
    opts = {
      display = { "Terminal" },
      live_display = { "VirtualTextOk", "TerminalOk" },
    },
    config = function(_, opts)
      require("sniprun").setup(opts)
    end,
    --stylua: ignore
    keys = {
      { "<leader>ra", function() require("sniprun.api").run_range(1, vim.fn.line("$")) end, desc = "All" },
      { "<leader>rr", function() require("sniprun").run() end, desc = "Current" },
      { "<leader>rr", function() require("sniprun").run("v") end, mode = { "v" }, desc = "Selection" },
      {
        "<leader>rR",
        function()
          require("sniprun").clear_repl()
          require("sniprun.display").close_all()
          require("sniprun").reset()
        end,
        desc = "Reset & (Close UI, Clear REPL)",
      },
      { "<leader>ri", function() vim.cmd("e " .. os.getenv("XDG_CACHE_HOME") .. "/sniprun/infofile.txt") end, desc = "Info" },
      {
        "<leader>rI",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root .. "/sniprun/docs/sources/interpreters/",
          })
        end,
        desc = "Find interpreters",
      },
    },
  },
}

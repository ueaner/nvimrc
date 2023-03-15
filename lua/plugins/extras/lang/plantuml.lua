-- dnf install graphviz
return {
  {
    "aklt/plantuml-syntax",
    event = "VeryLazy",
    ft = "plantuml",
  },

  {
    "tyru/open-browser.vim",
    event = "VeryLazy",
    ft = "plantuml",
    cmd = {
      "OpenBrowser",
    },
  },

  {
    "weirongxu/plantuml-previewer.vim",
    event = "VeryLazy",
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
      require("utils").on_ft("markdown", function(event)
        vim.keymap.set("n", "<leader>fv", "<cmd>PlantumlToggle<cr>", { desc = "Live Preview (Plantuml)", buffer = event.buf })
      end)
    end,
  },
}

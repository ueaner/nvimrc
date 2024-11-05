return {
  -- plantuml syntax
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml", "markdown" },
  },

  -- plantuml preview in browser
  {
    "weirongxu/plantuml-previewer.vim",
    ft = "plantuml",
    dependencies = { "tyru/open-browser.vim" },
    cmd = {
      "PlantumlToggle",
      "PlantumlOpen",
      "PlantumlStart",
      "PlantumlStop",
      "PlantumlSave",
    },
    init = function()
      vim.g["plantuml_previewer#plantuml_jar_path"] = vim.env.XDG_BIN_HOME .. "/plantuml.jar"
    end,
  },
}

vim.env.XDG_BIN_HOME = vim.env.XDG_BIN_HOME or (vim.env.HOME .. "/.local/bin")

return {
  -- plantuml syntax
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
    init = function()
      vim.g["plantuml_set_makeprg"] = 0
      -- https://github.com/ueaner/dotfiles/blob/main/bin/plantuml
      vim.opt_local["makeprg"] = vim.env.HOME .. "/bin/plantuml %"
      vim.opt_local["errorformat"] = "Error line %l in file: %f,%Z%m"
    end,
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
      -- https://github.com/ueaner/dotfiles/blob/main/ansible/roles/tools/tasks/plantuml.yml
      vim.g["plantuml_previewer#plantuml_jar_path"] = vim.env.XDG_BIN_HOME .. "/plantuml.jar"
    end,
  },
}

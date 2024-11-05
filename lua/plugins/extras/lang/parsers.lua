vim.filetype.add({ pattern = { ["${XDG_CONFIG_HOME}/pnpm/rc"] = "npmrc" } })

return {
  -- npmrc, npm-debug-log syntax
  { "rhysd/npm-filetypes.vim" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "java",
        "groovy",
        "kotlin",
        "xml",
        "swift",
        "nginx",
      },
    },
  },
}

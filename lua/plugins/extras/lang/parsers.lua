vim.filetype.add({ pattern = { ["${XDG_CONFIG_HOME}/pnpm/rc"] = "npmrc" } })

return {
  -- npmrc, npm-debug-log syntax
  { "rhysd/npm-filetypes.vim" },

  {
    "nvim-treesitter/nvim-treesitter",
    -- Use a function to append: a plain table would replace the whole list during opts merge.
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "java",
        "groovy",
        "kotlin",
        "xml",
        "swift",
        "nginx",
      })
    end,
  },
}

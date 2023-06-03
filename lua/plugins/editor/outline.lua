return {
  -- outline
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    cmd = "AerialToggle",
    keys = { { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Outline" } },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 40 },
      show_guides = true,
      filter_kind = {
        "Module",
        "Package",
        "Namespace",
        "Interface",
        "Class",
        "Struct",
        -- "Object",
        "Constructor",
        "Method",
        "Function",
        "Enum",
        -- "Constant",
      },
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },
}

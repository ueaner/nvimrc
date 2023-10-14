return {
  -- hover
  {
    "lewis6991/hover.nvim",
    -- stylua: ignore
    keys = {
      { "K", function () require("hover").hover() end, desc = "hover.nvim" },
      { "K", function () require("hover").hover() end, desc = "hover.nvim (select)", mode = { "v" } },
    },
    init = function()
      -- Require providers
      require("hover.providers.lsp")
      require("hover.providers.man")
      require("hover.providers.dictionary")
      require("hover.providers.gh")
    end,
  },
}

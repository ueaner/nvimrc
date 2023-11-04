require("utils.debug").setup()
require("config.options")
require("config.lazy")

require("tokyonight").load()
-- vim.cmd.colorscheme("catppuccin")

if vim.fn.argc(-1) == 0 then
  local group = vim.api.nvim_create_augroup("nvimrc", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      require("config.autocmds")
      require("config.keymaps")
    end,
  })
else
  require("config.autocmds")
  require("config.keymaps")
end

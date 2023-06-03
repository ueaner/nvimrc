require("utils.debug").setup()
require("config.options")
require("config.lazy")

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("nvimrc", { clear = true }),
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

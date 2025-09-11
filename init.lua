if vim.g.vscode then
  require("config.options")
  return
end

require("util.debug").setup()

require("config.options")
require("config.lazy")

if vim.env.COLORTERM == "truecolor" then
  require("tokyonight").load()
else
  vim.cmd.colorscheme("habamax")
end

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

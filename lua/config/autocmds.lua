-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- autocmds
local autocmd = vim.api.nvim_create_autocmd

-- autoread
autocmd("FocusGained,BufEnter", {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Reopen files at last edit position, :help restore-cursor
--autocmd BufReadPost *
--  \ if line("'\"") > 1 && line("'\"") <= line("$") |
--  \   exe "normal! `\"" |
--  \ endif
autocmd("BufReadPost", {
  callback = function()
    vim.cmd([[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! `\"" | endif ]])
  end,
})

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.markdown_folding = 1

vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.linebreak = true
vim.opt.fillchars = { fold = " ", eob = " " }
vim.opt.whichwrap:append("<>[]")

-- Text is shown normally
vim.opt.conceallevel = 0

vim.opt.numberwidth = 2
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.scrolloff = 3

-- dont show mode since we have a statusline
vim.opt.showmode = false
vim.opt.laststatus = 3

-- s: don't give "search hit BOTTOM, continuing at TOP" ...
-- c: Pattern not found
vim.opt.shortmess:append({ s = true, c = true })

-- :help spell-cjk  exclude CJK characters form spell checking
vim.opt.spelllang = "en_us,cjk"
vim.opt.mouse = "nvi"

-- Indenting
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- vim.opt.timeoutlen = 300
-- vim.opt.updatetime = 300

-- highlighting matching pairs, $VIMRUNTIME/plugin/matchparen.vim
vim.opt.showmatch = true
vim.opt.matchtime = 3

vim.opt.foldenable = false
vim.opt.foldmethod = "indent"

-- Search for a filename and open the selected file :find somefile<TAB>
vim.opt.path:append("**")

-- Append the completion dictionary
if vim.fn.filereadable("/usr/share/dict/words") then
  vim.opt.dictionary:append("/usr/share/dict/words")
end

-- disable some extension providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

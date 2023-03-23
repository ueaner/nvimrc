-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- :help vim_diff     Differences between Nvim and Vim
-- :help map-listing  Listing mappings

-- stylua: ignore start

-- keymaps delete
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("v", "<")
vim.keymap.del("v", ">")
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

local map = vim.keymap.set

-- default mappings enhanced
map("n", "0", "^")
-- Disable Ex-Mode
map("n", "Q", "<NOP>")
map("n", "<BS>", "X")
-- tmux prefix key: <A-s>
map({ "i", "v", "n", "s" }, "<A-s>", "<NOP>")
-- prints the current file name with `full path` and the current `buffer number`
map("n", "<C-g>", "2<C-g>")

-- Readline-style keymap for normal mode
map("i", "<C-A>", "<Home>")
map("i", "<C-E>", "<ESC><S-A>")
-- <C-B> <C-F> also configured in ui/noise.nvim
map("i", "<C-B>", "<Left>")
map("i", "<C-F>", "<Right>")
-- :h i_CTRL-H
map("i", "<C-D>", "<Del>")
-- :help i_CTRL-W
-- :help i_CTRL-U
map("i", "<C-K>", "<C-O>D")
-- " :help i_CTRL-Y Insert the character which is above the cursor

-- Readline-style keymap for command-line mode
map("c", "<C-A>", "<Home>")
-- :help c_CTRL-E
map("c", "<C-B>", "<Left>")
map("c", "<C-F>", "<Right>")
-- :help i_CTRL-H
map("c", "<C-D>", "<Del>")
-- :help c_CTRL-W
-- :help c_CTRL-U
-- cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<cr>
-- :help c_CTRL-\_e Evaluate {expr} and replace the whole command line with the result.
map("c", "<C-K>", "<C-\\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<cr>")
-- :help c_CTRL-Y

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "dont copy replaced text", silent = true })

-- Visual mode pressing * or # searches for the current selection
map("x", "*", "<cmd>VisualSelection<cr>", { desc = "Search current selection", silent = true })
map("x", "#", "<cmd>VisualSelection<cr>", { desc = "Search current selection", silent = true })

-- set pastetoggle=<leader>p
map("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })
map("n", "<leader>ub", function() require("utils").clipboard_toggle() end, { desc = "Toggle ClipBoard" })

-- Remove Trailing Whitespace / ^M
map("n", "<leader>cc", "<cmd>Stripspace<cr>", { desc = "Code Clean" })

-- nnoremap <silent> <leader>k wb/\<<C-R><C-W>\>/e<cr>
map("n", "gw", "wb/<C-R><C-W>/e<cr>", { desc = "Highlighting word under cursor" })

-- Switch buffers with <c-p> <c-n>
map("n", "<C-p>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<C-n>", "<cmd>bnext<cr>", { desc = "Next buffer" })

map("n", "<leader>bD", function() require("utils.buf").close_others() end, { desc = "Delete Other Buffers" })
map({"n", "t"}, "<leader>bd", function() require("utils.buf").close() end, { desc = "Delete Buffer" })
map({"n", "t"}, "<leader>bi", function() require("utils.buf").info() end, { desc = "Buffer Info" })

-- translation
map("x", "<leader>tz", "<cmd>Translate ZH<cr>", { desc = "Translate from English to Chinese", silent = true })
map("x", "<leader>te", "<cmd>Translate EN<cr>", { desc = "Translate from Chinese to English", silent = true })

if vim.fn.executable("btm") then
  map("n", "<leader>ab", function() require("lazyvim.util").float_term({ "btm" }) end, { desc = "bottom" })
elseif vim.fn.executable("btop") then
  map("n", "<leader>ab", function() require("lazyvim.util").float_term({ "btop" }) end, { desc = "btop" })
end

-- stylua: ignore end

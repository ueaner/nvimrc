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

-- default mappings enhanced
vim.keymap.set("n", "0", "^")
-- Disable Ex-Mode
vim.keymap.set("n", "Q", "<NOP>")
vim.keymap.set("n", "<BS>", "X")
-- tmux prefix key: <A-s>
vim.keymap.set({ "i", "v", "n", "s" }, "<A-s>", "<NOP>")
-- prints the current file name with `full path` and the current `buffer number`
vim.keymap.set("n", "<C-g>", "2<C-g>")

-- Readline-style keymap for command-line mode
vim.keymap.set("c", "<C-A>", "<Home>")
-- :help c_CTRL-E
vim.keymap.set("c", "<C-B>", "<Left>")
vim.keymap.set("c", "<C-F>", "<Right>")
-- :help i_CTRL-H
vim.keymap.set("c", "<C-D>", "<Del>")
-- :help c_CTRL-W
-- :help c_CTRL-U
-- cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<cr>
-- :help c_CTRL-\_e Evaluate {expr} and replace the whole command line with the result.
vim.keymap.set("c", "<C-K>", "<C-\\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<cr>")
-- :help c_CTRL-Y

-- set pastetoggle=<leader>p
vim.keymap.set("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })
vim.keymap.set("n", "<leader>ub", function() require("utils").toggle.clipboard() end, { desc = "Toggle ClipBoard" })
--vim.keymap.set("n", "<leader>z", "<cmd>ZoomToggle<cr>", { desc = "Toggle Zoom" })

-- Remove Trailing Whitespace / ^M
vim.keymap.set("n", "<leader>cc", "<cmd>Stripspace<cr>", { desc = "Code Clean" })

-- nnoremap <silent> <leader>k wb/\<<C-R><C-W>\>/e<cr>
vim.keymap.set("n", "gw", "wb/<C-R><C-W>/e<cr>", { desc = "Highlighting word under cursor" })

-- Switch buffers with <c-p> <c-n>
vim.keymap.set("n", "<C-p>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<C-n>", "<cmd>bnext<cr>", { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bD", function() require("utils").buf.close_others() end, { desc = "Delete Other Buffers" })
vim.keymap.set({"n", "t"}, "<leader>bd", function() require("utils").buf.close() end, { desc = "Delete Buffer" })

if vim.fn.executable("btm") then
  vim.keymap.set("n", "<leader>ab", function() require("lazyvim.util").float_term({ "btm" }) end, { desc = "bottom" })
elseif vim.fn.executable("btop") then
  vim.keymap.set("n", "<leader>ab", function() require("lazyvim.util").float_term({ "btop" }) end, { desc = "btop" })
end

-- stylua: ignore end

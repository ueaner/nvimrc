-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- :help vim_diff     Differences between Nvim and Vim
-- :help map-listing  Listing mappings

-- stylua: ignore start

local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })


-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w\\", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>\\", "<C-W>s", { desc = "Split window below" })
map("n", '<leader>|', "<C-W>v", { desc = "Split window right" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- force formatting
map({ "n", "v" }, "<leader>cf", function() U.format({ force = true }) end, { desc = "Format" })

-- toggle options
map("n", "<leader>uf", function() U.format.toggle() end, { desc = "Toggle auto format (global)" })
map("n", "<leader>uF", function() U.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
map("n", "<leader>us", function() U.toggler.option("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>ud", U.toggler.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>uc", U.toggler.toggle_conceallevel, { desc = "Toggle Conceal" })
map("n", "<leader>ub", U.toggler.toggle_clipboard, { desc = "Toggle ClipBoard" })
map("n", "<leader>up", "<cmd>set paste!<cr>", { desc = "Toggle Paste" })

if vim.lsp.inlay_hint and type(vim.lsp.inlay_hint) == "table" then
  map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })
end

map("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
map("n", "<leader>uB", function() U.toggler.option("background", false, {"light", "dark"}) end, { desc = "Toggle Background" })

-- lazy
map("n", "<leader>mz", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>mf", "<cmd>LazyFormatInfo<cr>", { desc = "Lazy Format Info" })

-- default mappings improved
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
map("c", "<C-Y>", '<C-R>"')

-- Remove Trailing Whitespace / ^M
map("n", "<leader>cc", "<cmd>Stripspace<cr>", { desc = "Code Clean" })

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "dont copy replaced text", silent = true })

-- Visual mode pressing * or # searches for the current selection
map("x", "*", "<cmd>VisualSelection<cr>", { desc = "Search current selection", silent = true })
map("x", "#", "<cmd>VisualSelection<cr>", { desc = "Search current selection", silent = true })

-- nnoremap <silent> <leader>k wb/\<<C-R><C-W>\>/e<cr>
map("n", "gw", "wb/<C-R><C-W>/e<cr>", { desc = "Highlighting word under cursor" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map( "n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Switch buffers with <c-p> <c-n>
map("n", "<C-p>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<C-n>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Last Tab" })
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Tab" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Tab" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>bD", function() U.ui.close_others() end, { desc = "Delete Other Buffers" })
map({"n", "t"}, "<leader>bd", function() U.ui.close() end, { desc = "Delete Buffer" })
map({"n", "t"}, "<leader>mb", function() U.ui.info() end, { desc = "Buffer Info" })

-- floating terminal
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

map("n", "<leader>D", function() vim.log.set_level(vim.log.levels.DEBUG) end, { desc = "Neovim log set to DEBUG level" })

-- lazygit
map("n", "<leader>gg", function() U.terminal({ "lazygit" }, { cwd = U.root.git(), esc_esc = false }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() U.terminal({ "lazygit" }, { esc_esc = false }) end, { desc = "Lazygit (cwd)" })

-- tig
map("n", "<leader>gt", function() U.terminal({ "tig" }, { cwd = U.root.git(), esc_esc = false, border = "rounded" }) end, { desc = "Tig (root dir)" })
map("n", "<leader>gT", function() U.terminal({ "tig" }, { esc_esc = false, border = "rounded" }) end, { desc = "Tig (cwd)" })

if vim.fn.executable("btm") == 1 then
  map("n", "<leader>ab", function() U.terminal({ "btm" }) end, { desc = "bottom" })
elseif vim.fn.executable("btop") == 1 then
  map("n", "<leader>ab", function() U.terminal({ "btop" }) end, { desc = "btop" })
end

if vim.g.neovide then
  vim.keymap.set('n', '<C-s>', ':w<CR>') -- Save
  -- system clipboard
  vim.keymap.set('n', '<C-c>', '"+y')    -- Copy normal mode
  vim.keymap.set('v', '<C-c>', '"+y')    -- Copy visual mode
  vim.keymap.set('n', '<C-v>', '"+p')    -- Paste normal mode
  vim.keymap.set('v', '<C-v>', '"+p')    -- Paste visual mode
  vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<C-v>', '<C-R>+') -- Paste insert mode
end

-- stylua: ignore end

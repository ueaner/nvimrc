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
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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
U.toggle.map("<leader>uf", U.toggle.format())
U.toggle.map("<leader>uF", U.toggle.format(true))
U.toggle.map("<leader>us", U.toggle("spell", { name = "Spelling" })) -- bool, set spell!
U.toggle.map("<leader>up", U.toggle("paste", { name = "Paste" })) -- bool, set paste!
U.toggle.map("<leader>ud", U.toggle.diagnostics)
U.toggle.map("<leader>uc", U.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } }))
U.toggle.map("<leader>ub", U.toggle("clipboard", { values = { "", "unnamedplus" } }))
U.toggle.map("<leader>uT", U.toggle.treesitter)
U.toggle.map("<leader>uB", U.toggle("background", { values = { "light", "dark" }, name = "Background" }))
U.toggle.map("<leader>uh", U.toggle.inlay_hints)

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
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map( "n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- buffers
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New File" })
-- Switch buffers with <c-p> <c-n>
map("n", "<C-p>", "[b", { desc = "Previous Buffer", remap = true })
map("n", "<C-n>", "]b", { desc = "Next Buffer", remap = true })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bo", function() U.ui.bufremove_others() end, { desc = "Delete Other Buffers" })
map({"n", "t"}, "<leader>bd", function() U.ui.bufremove() end, { desc = "Delete Buffer" })
map({"n", "t"}, "<leader>mb", function() U.ui.bufinfo() end, { desc = "Buffer Info" })

-- tabs
map("n", "<leader><tab><tab>", "<cmd>tabs<cr>", { desc = "List Tabs" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- native snippets. only needed on < 0.11, as 0.11 creates these by default
if vim.fn.has("nvim-0.11") == 0 then
  map("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  map({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end

-- floating terminal
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

map("n", "<leader>D", function() vim.log.set_level(vim.log.levels.DEBUG) end, { desc = "Neovim log set to DEBUG level" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() U.terminal({ "lazygit" }, { cwd = U.root.git(), esc_esc = false }) end, { desc = "Lazygit (root dir)" })
  map("n", "<leader>gG", function() U.terminal({ "lazygit" }, { esc_esc = false }) end, { desc = "Lazygit (cwd)" })
end

-- tig
map("n", "<leader>gt", function() U.terminal({ "tig" }, { cwd = U.root.git(), esc_esc = false, border = "rounded" }) end, { desc = "Tig (root dir)" })
map("n", "<leader>gT", function() U.terminal({ "tig" }, { esc_esc = false, border = "rounded" }) end, { desc = "Tig (cwd)" })

if vim.fn.executable("btm") == 1 then
  map("n", "<leader>ab", function() U.terminal({ "btm" }) end, { desc = "bottom" })
elseif vim.fn.executable("btop") == 1 then
  map("n", "<leader>ab", function() U.terminal({ "btop" }) end, { desc = "btop" })
end

if vim.fn.executable("glow") == 1 then
  map("n", "<leader>ag", function() U.terminal(
    { "glow", vim.api.nvim_buf_get_name(0) },
    { interactive = false, size = { width = 0.75, height = 0.85 } }
  ) end, { desc = "glow" })
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

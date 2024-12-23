-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Hide deprecation warnings
vim.g.deprecation_warnings = false
if vim.g.deprecation_warnings == false then
  vim.deprecate = function() end
end

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.markdown_folding = 1
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Enable auto format
vim.g.autoformat = true

-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

local opt = vim.opt

opt.termguicolors = true -- True color support
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.splitkeep = "screen"
opt.spell = true
opt.spelllang = "en_us,cjk" -- :help spell-cjk  exclude CJK characters form spell checking
opt.mouse = "nvi" -- Enable mouse mode
opt.shortmess:append({ W = true, I = true, c = true, C = true, s = true })

opt.autowrite = true -- Enable auto write
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 1000
opt.timeoutlen = 300
opt.updatetime = 200
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
opt.hidden = true

-- Allow cursor to move where there is no text in visual block mode
-- opt.virtualedit = "block"

opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.formatoptions = "jcroqlnt" -- tcqj
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

opt.conceallevel = 0 -- Text is shown normally
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.inccommand = "nosplit" -- preview incremental substitute

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

opt.wrap = false -- Disable line wrap
opt.linebreak = true
opt.whichwrap:append("<>[]")
opt.fillchars = { fold = " ", eob = " " }
opt.list = true -- Show some invisible characters (tabs...
opt.number = true -- Print line number
opt.numberwidth = 2
opt.relativenumber = false
opt.cursorline = true
opt.cursorlineopt = "number"
opt.scrolloff = 3 -- Lines of context
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.laststatus = 3

opt.breakindent = true
opt.autoindent = true
opt.smartindent = true -- Insert indents automatically
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent

opt.foldenable = false
opt.foldmethod = "indent"

-- highlighting matching pairs, $VIMRUNTIME/plugin/matchparen.vim
opt.showmatch = true
opt.matchtime = 3

-- in $VIMRUNTIME/plugin/osc52.lua
--    - require('vim.termcap').query('Ms', cb)
--      - TermResponse event not triggered
-- So, force Nvim to use the OSC 52 provider in ssh, :help clipboard-osc52
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
-- and clipboard option must be set
opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Search for a filename and open the selected file :find somefile<TAB>
opt.path:append("**")

-- Append the completion dictionary
if vim.fn.filereadable("/usr/share/dict/words") then
  opt.dictionary:append("/usr/share/dict/words")
end

-- disable some extension providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

if vim.g.neovide then
  vim.env.TERM = "xterm-256color"

  -- default configuration, see: https://github.com/neovide/neovide/blob/main/src/window/settings.rs
  vim.g.neovide_fullscreen = true

  -- Error: Font can't be updated ...
  -- Set Chinese fonts in the `~/.config/neovide/config.toml`.
  -- See: https://github.com/ueaner/dotfiles/blob/main/.config/neovide/config.toml
  -- vim.opt.guifont = "SauceCodePro Nerd Font,Noto Sans Mono CJK SC:h12"
end

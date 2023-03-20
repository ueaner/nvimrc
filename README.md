# Nvim configuration

![nvim-preview](https://user-images.githubusercontent.com/318253/217737517-ded6c47a-e692-475e-a71d-eda0897c2dad.png)

## 🚀 Getting Started

- Make a backup of your current Neovim files:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

- Clone nvimrc

```sh
git clone https://github.com/ueaner/nvimrc ~/.config/nvim
```

- Remove the `.git` folder, so you can add it to your own repo later

```sh
rm -rf ~/.config/nvim/.git
```

- Start Neovim!

```sh
nvim
```

## ⌨️ Keymaps

See [keymaps.md](docs/keymaps.md).

## ✨ Features

- [LazyVim] for Neovim setup powered by [💤 lazy.nvim] plugin management
- Package management with [mason.nvim]
- Syntax Highlighting with [Treesitter]
- Language Server Protocol with [Native LSP]
- Formatting and Linting with [null-ls.nvim]
- Debug Adapter Protocol with [nvim-dap]
- Tests with [neotest]
- Auto Completion with [nvim-cmp]
- Snippets with [LuaSnip] and [friendly-snippets]
- Fuzzy Finding with [telescope.nvim]
- File Explorer with [nvim-tree.lua]
- Code Outline with [aerial.nvim]
- Live prompt for keymaps with [which-key.nvim]
- Statusline with [lualine.nvim]
- Tabline with [bufferline.nvim]
- Floating Winbar with [incline.nvim]
- Git integration with [gitsigns.nvim]
- Terminal with [nvterm]
- Database Explorer with [vim-dadbod]
- Http Client with [rest.nvim]
- gRPC Client with [grpc-nvim]

## 📁 File Structure

<!-- prettier-ignore -->
```
lua
├── config
│   ├── lazy.lua         -- import LazyVim
│   ├── autocmds.lua
│   ├── keymaps.lua
│   └── options.lua
├── plugins
│   ├── ui.lua           -- UI Appearance
│   ├── editor.lua       -- Editor Features
│   ├── coding.lua       -- Coding Features
│   ├── terminal.lua
│   ├── git.lua
│   ├── db.lua
│   ├── lsp.lua
│   ├── dap.lua
│   ├── test.lua
│   ├── treesitter.lua
│   └── extras
│       └── lang         -- language specific extension modules
│           ├── markdown.lua
│           ├── plantuml.lua
│           ├── go.lua
│           +-- spec.lua
└── utils.lua
```

Contents of ui, editor and coding:

- `UI Appearance`: statusline, tabline, winbar, scrollbar, indent, icons, colorizer, notify, messages, cmdline, popupmenu, etc.
- `Editor Features`: which-key, fuzzy finder, file explorer, outline, jump, git signs, todo comments, auto-resize windows, better xxx, etc.
- `Coding Features`: auto completion, snippets, text-objects, refactoring, rename, surround, auto pairs, etc.

[LazyVim]: https://github.com/LazyVim/LazyVim
[💤 lazy.nvim]: https://github.com/folke/lazy.nvim
[mason.nvim]: https://github.com/williamboman/mason.nvim
[Treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Native LSP]: https://github.com/neovim/nvim-lspconfig
[null-ls.nvim]: https://github.com/jose-elias-alvarez/null-ls.nvim
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[neotest]: https://github.com/nvim-neotest/neotest
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[LuaSnip]: https://github.com/L3MON4D3/LuaSnip
[friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[nvim-tree.lua]: https://github.com/nvim-tree/nvim-tree.lua
[aerial.nvim]: https://github.com/stevearc/aerial.nvim
[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[nvterm]: https://github.com/NvChad/nvterm
[which-key.nvim]: https://github.com/folke/which-key.nvim
[lualine.nvim]: https://github.com/nvim-lualine/lualine.nvim
[bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[incline.nvim]: https://github.com/b0o/incline.nvim
[vim-dadbod]: https://github.com/tpope/vim-dadbod
[rest.nvim]: https://github.com/rest-nvim/rest.nvim
[grpc-nvim]: https://github.com/hudclark/grpc-nvim

# Nvim configuration

![nvim-preview](https://github.com/ueaner/nvimrc/assets/318253/df1004d3-8419-4c9f-9bea-5e2bf10c83f5)

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

## ⚡️ Requirements

- Neovim **nightly** or **latest** version. See [here](https://github.com/neovim/neovim/releases/tag/nightly) and [here](https://github.com/neovim/neovim/releases/tag/stable)
- a [Nerd Font](https://www.nerdfonts.com/) **_(optional)_**. See [here](https://github.com/ueaner/dotfiles/blob/main/ansible/roles/fonts/tasks/main.yml)
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)

## ⌨️ Keymaps

See [keymaps.md](docs/keymaps.md).

## ✨ Features

- [LazyVim] for Neovim setup powered by [💤 lazy.nvim] plugin management
- Package management with [mason.nvim]
- Syntax Highlighting with [Treesitter]
- Language Server Protocol with [Native LSP]
- Debug Adapter Protocol with [nvim-dap]
- Tests with [neotest]
- Formatting with [conform.nvim]
- Linting with [nvim-lint]
- Code Actions with [null-ls.nvim]
- Auto Completion with [nvim-cmp]
- Snippets with [nvim-snippets] and [friendly-snippets]
- Fuzzy Finding with [telescope.nvim]
- File Explorer with [neo-tree.nvim]
- Code Outline with [aerial.nvim] and [outline.nvim]
- Live prompt for keymaps with [which-key.nvim]
- Quickly Jump with [flash.nvim] and [nvim-treehopper]
- Colorscheme with [tokyonight.nvim] and [catppuccin]
- Statusline with [lualine.nvim]
- Tabline with [bufferline.nvim]
- Floating Winbar with [incline.nvim]
- Scrollbar with [satellite.nvim]
- Indent guides with [indent-blankline.nvim]
- Git integration with [gitsigns.nvim]
- Terminal with [nvterm]
- Database Explorer with [vim-dadbod]
- Http Client with [kulala.nvim]
- gRPC Client with [grpc-nvim]
- icons with [mini.icons] and [vscode-codicons]

Supported Programming Languages:

- [Go]
- [Rust]
- [Python]
- [PHP]
- [TypeScript/JavaScript]
- [Bash/Zsh Script]
- etc.

## 📁 File Structure

<!-- prettier-ignore -->
```
lua
├── config
│   ├── init.lua         -- configure of icons, close_with_q list, etc.
│   ├── lazy.lua         -- configure lazy.nvim
│   ├── autocmds.lua
│   ├── keymaps.lua
│   └── options.lua
├── plugins
│   ├── ui.lua           -- UI Appearance
│   ├── editor.lua       -- Editor Features
│   ├── coding.lua       -- Coding Features
│   ├── lsp.lua
│   ├── dap.lua
│   ├── test.lua
│   ├── treesitter.lua
│   └── extras
│       ├── tools
│       │   ├── database.lua
│       │   ├── plantuml.lua
│       │   ├── rest.lua
│       │   └── ...
│       └── lang         -- language specific extension modules
│           ├── yaml.lua
│           ├── python.lua
│           ├── go.lua
│           ├── ...
│           +-- spec.lua
└── util.lua
```

Contents of ui, editor and coding:

- `UI Appearance`: statusline, tabline, winbar, scrollbar, indent, icons, notify, messages, cmdline, popupmenu, etc.
- `Editor Features`: which-key, fuzzy finder, file explorer, outline, jump, git signs, todo comments, auto-resize windows, etc.
- `Coding Features`: auto completion, snippets, comments, refactoring, auto pairs, etc.

[LazyVim]: https://github.com/LazyVim/LazyVim/tree/7a36e2989c3d62e8dbaf4036f5c4551929c565a5
[💤 lazy.nvim]: https://github.com/folke/lazy.nvim
[mason.nvim]: https://github.com/williamboman/mason.nvim
[Treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Native LSP]: https://github.com/neovim/nvim-lspconfig
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[neotest]: https://github.com/nvim-neotest/neotest
[null-ls.nvim]: https://github.com/nvimtools/none-ls.nvim
[conform.nvim]: https://github.com/stevearc/conform.nvim
[nvim-lint]: https://github.com/mfussenegger/nvim-lint
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[nvim-snippets]: https://github.com/garymjr/nvim-snippets
[friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[aerial.nvim]: https://github.com/stevearc/aerial.nvim
[outline.nvim]: https://github.com/hedyhli/outline.nvim
[gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[nvterm]: https://github.com/NvChad/nvterm
[which-key.nvim]: https://github.com/folke/which-key.nvim
[flash.nvim]: https://github.com/folke/flash.nvim
[nvim-treehopper]: https://github.com/mfussenegger/nvim-treehopper
[tokyonight.nvim]: https://github.com/folke/flash.nvim
[catppuccin]: https://github.com/folke/flash.nvim
[lualine.nvim]: https://github.com/nvim-lualine/lualine.nvim
[bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[incline.nvim]: https://github.com/b0o/incline.nvim
[satellite.nvim]: https://github.com/lewis6991/satellite.nvim
[indent-blankline.nvim]: https://github.com/lukas-reineke/indent-blankline.nvim
[vim-dadbod]: https://github.com/tpope/vim-dadbod
[kulala.nvim]: https://github.com/mistweaverco/kulala.nvim
[grpc-nvim]: https://github.com/hudclark/grpc-nvim
[mini.icons]: https://github.com/echasnovski/mini.icons
[vscode-codicons]: https://github.com/microsoft/vscode-codicons/blob/main/dist/codicon.csv
[Go]: lua/plugins/extras/lang/go.lua
[Rust]: lua/plugins/extras/lang/rust.lua
[Python]: lua/plugins/extras/lang/python.lua
[PHP]: lua/plugins/extras/lang/php.lua
[TypeScript/JavaScript]: lua/plugins/extras/lang/typescript.lua
[Bash/Zsh Script]: lua/plugins/extras/lang/bash.lua

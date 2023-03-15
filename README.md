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

## Keymaps

See [keymaps.md](docs/keymaps.md).

## What's in the stack

- [LazyVim] for Neovim setup powered by [💤 lazy.nvim]
- [mason.nvim] for manage external editor tools, such as LSP servers, DAP servers, linters, and formatters
- [nvim-treesitter] for `Nvim Treesitter` configuration
- [nvim-lspconfig] for `Nvim LSP client` configuration
- [null-ls.nvim] for `formatters` and `linters` configuration
- [nvim-dap] for `DAP client` setup, supports adapters
- [neotest] for `tests` setup, supports adapters
- which-key, fuzzy finder, file explorer, outline, auto completion, snippets, etc.
- terminal, git, database explorer, http client, grpc client, etc.

## File Structure

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
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[null-ls.nvim]: https://github.com/jose-elias-alvarez/null-ls.nvim
[neotest]: https://github.com/nvim-neotest/neotest

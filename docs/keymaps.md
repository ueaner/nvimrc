# ⌨️ Keymaps

Uses [which-key.nvim] to live prompt for keymaps.
Just press any key like `,` will displays a popup with all possible keymaps starting with `,`.

![which-key]

## Modes

References:

- `:help map-overview`
- `:help map-table`
- `:help vim-modes`
- `:help mode-switching`

Switch from normal mode to another mode, and then switch back to normal mode:

```help
           TO mode                Command                   Operator
                |    Insert    |   line     |   Visual   |  pending   |  Terminal  |
                +--------------+------------+------------+------------+------------+
   FROM Normal  | i,a,o,c,etc. |     :      | v,V,<C-v>  |  v,c,d,y   |    i,a     |
BACK TO Normal  |    <Esc>     |   <Esc>    |   <Esc>    |   <Esc>    | <Esc><Esc> |

FROM Normal TO Insert mode commands: `i, I, a, A, o, O, c, C, gi`
FROM Terminal TO Normal mode keyset: `tmap <Esc><Esc> <C-\><C-n>`
```

## General

| Key          | Description                  | Mode | Provider |
| ------------ | ---------------------------- | ---- | -------- |
| `<esc>`      | Escape and clear hlsearch    | all  | esc      |
| `<esc><esc>` | Terminal mode to normal mode | t    | terminal |

## Basic editing

| Key             | Description                        | Mode    | Provider       |
| --------------- | ---------------------------------- | ------- | -------------- |
| `y`             | Yank selected                      | v       | register       |
| `p`             | Put the text after the cursor      | n, v    | register       |
| `P`             | Put the text before the cursor     | n, v    | register       |
| `x`             | Delete char, same as `dl`          | n, v    | register       |
| `X`             | Delete char, same as `dh`          | n, v    | register       |
| `cc`            | Editing line                       | n -> i  | register       |
| `dd`            | Delete line                        | n       | register       |
| `yy`            | Yank line                          | n       | register       |
| `C`             | Delete to end of line              | n -> i  | register       |
| `D`             | Delete to end of line              | n, v    | register       |
| `Y`             | Yank to end of line                | n, v    | register       |
| `<A-j>`         | Move line/block down               | n, i, v | move           |
| `<A-k>`         | Move line/block up                 | n, i, v | move           |
| `u`             | Undo                               | n       | undo           |
| `<C-r>`         | Redo                               | n       | redo           |
| `o`             | Insert line below                  | n       | Insert-mode    |
| `O`             | Insert line above                  | n       | Insert-mode    |
| `%`             | Jump to matching bracket           | n       | motion         |
| `>>`            | Indent line                        | n       | motion         |
| `<<`            | Outdent line                       | n       | motion         |
| `>`             | Indent line                        | v       | motion         |
| `<`             | Outdent line                       | v       | motion         |
| `^`             | Go to beginning of line            | n, v    | motion         |
| `$`             | Go to end of line                  | n, v    | motion         |
| `j`             | Move cursor down                   | n, v    | motion         |
| `k`             | Move cursor up                     | n, v    | motion         |
| `H`             | To Header (top) line of window     | n, v    | motion         |
| `M`             | To Middle line of window           | n, v    | motion         |
| `L`             | To Last (bottom) line of window    | n, v    | motion         |
| `<C-f>`         | Scroll page down                   | n, v    | scrolling      |
| `<C-b>`         | Scroll page up                     | n, v    | scrolling      |
| `zz`            | Scroll cursor to center screen     | n, v    | scrolling      |
| `za`            | Toggle fold under cursor           | n       | fold           |
| `zA`            | Toggle all folds under cursor      | n       | fold           |
| `<leader>uw`    | Toggle word wrap                   | n       | options        |
| `gcc`           | Toggle line comment                | n       | [mini.comment] |
| `gc`            | Toggle selected comment            | v       | [mini.comment] |
| `f{char}`       | Enhanced f/t motions               | n       | [flit.nvim]    |
| `s{char}{char}` | Jump by 2-character search pattern | n       | [leap.nvim]    |

Command-line mode uses readline-style keymaps.

## Rich languages editing

- prefix: `<leader>c` for code

| Key          | Description            | Mode | Provider   |
| ------------ | ---------------------- | ---- | ---------- |
|              | auto completion        | i    | [nvim-cmp] |
| `K`          | Hover                  | n    | LSP        |
| `gK`         | Trigger Signature Help | n    | LSP        |
| `<c-k>`      | Trigger Signature Help | i    | LSP        |
| `<leader>cf` | Format Document        | n    | LSP        |
| `<leader>cf` | Format Range           | v    | LSP        |
| `ge`         | Goto D[e]claration     | n    | LSP        |
| `gd`         | Goto Definition        | n    | LSP        |
| `gD`         | Goto Type Definition   | n    | LSP        |
| `gI`         | Goto Implementation    | n    | LSP        |
| `gr`         | Find References        | n    | LSP        |
| `<leader>cr` | Rename                 | n    | LSP        |
| `<leader>ca` | Code Action            | n, v | LSP        |
| `<leader>cc` | Code Clean             | n    | LSP        |

## Multi-cursor and selection

Select first `{Visual}`, then operate `{motion}`. eg: `v -> c d y p i`.

See `:help text-objects`, command usage rules `[command] [text object | motion]` based on `[mode]`. eg: `vi<x ciw da" ya{`.

| Key       | Description                                     | Mode | Provider          |
| --------- | ----------------------------------------------- | ---- | ----------------- |
| `v`       | (Visual charwise) Select char                   | n    | Visual-mode       |
| `V`       | (Visual linewise) Select current line           | n    | Visual-mode       |
| `<C-v>`   | (Visual blockwise) Select current column        | n    | Visual-mode       |
| `gv`      | Select last selected contents                   | n    | Visual-mode       |
| `v <C-f>` | Select page down                                | n    | Visual-mode       |
| `v <C-b`  | Select page up                                  | n    | Visual-mode       |
| `V H`     | Select to top line of window                    | n    | Visual-mode       |
| `V L`     | Select to bottom line of window                 | n    | Visual-mode       |
| `<C-v> j` | Select line below                               | n    | Visual-mode       |
| `<C-v> k` | Select line above                               | n    | Visual-mode       |
| `I`       | Insert cursor at before of each selected column | v    | Insert-mode       |
| `A`       | Insert cursor at after of each selected column  | v    | Insert-mode       |
| `m`       | Visually select/change/delete/yank              | o    | [nvim-treehopper] |

## Display

- prefix: `<leader>g` for git
- prefix: `<leader>D` for db
- prefix: `<leader>a` for `a` tool
- prefix: `<leader>u` for ui

| Key          | Description              | Mode | Provider                 |
| ------------ | ------------------------ | ---- | ------------------------ |
| `<leader>z`  | Zoom                     | n, t | [windows.nvim]           |
| `<leader>Z`  | Zen Mode                 | n, t | [zen-mode.nvim]          |
| `<C-=>`      | Zoom in                  | n, t | system                   |
| `<C-->`      | Zoom out                 | n, t | system                   |
| `<leader>e`  | Toggle File Explorer     | n, t | [nvim-tree.lua]          |
| `<leader>E`  | Toggle Database Explorer | n    | [vim-dadbod]             |
| `<leader>co` | Toggle Outline           | n    | [aerial.nvim]            |
| `<leader>tt` | Toggle Terminal          | n, t | [nvterm]                 |
| `<leader>l`  | Lazy                     | n    | [lazy.nvim]              |
| `<leader>cm` | Mason                    | n    | [mason.nvim]             |
| `<leader>cl` | Lsp Info                 | n    | [nvim-lspconfig]         |
| `<leader>gg` | Lazygit                  | n    | [lazygit]                |
| `<leader>dr` | Show DAP configurations  | n    | [nvim-dap]               |
|              | Show Output Panel        | n    |                          |
| `<leader>fv` | Live Preview (Markdown)  | n    | [glow.nvim]              |
| `<leader>fv` | Live Preview (Plantuml)  | n    | [plantuml-previewer.vim] |

## Search and replace

| Key          | Description                | Mode    | Provider         |
| ------------ | -------------------------- | ------- | ---------------- |
| `<leader>sr` | Replace in files (Spectre) | n       | [nvim-spectre]   |
| `<leader>/`  | Find in files (grep)       | n       | [telescope.nvim] |
| `*`          | Search forward             | n, v    | pattern          |
| `#`          | Search backward            | n, v    | pattern          |
| `n`          | Find next                  | n, x, o | pattern          |
| `N`          | Find previous              | n, x, o | pattern          |

## Navigation

- prefix: `<leader>x` for diagnostics/quickfix

| Key          | Description                     | Mode | Provider             |
| ------------ | ------------------------------- | ---- | -------------------- |
| `:{number}`  | Go to Line                      | n    | cmdline              |
| `<leader>ff` | Go to File                      | n    | [telescope.nvim]     |
| `<leader>ss` | Find Symbols                    | n    | [telescope.nvim]     |
| `]t`         | Next todo comment               | n    | [todo-comments.nvim] |
| `[t`         | Previous todo comment           | n    | [todo-comments.nvim] |
| `<leader>xt` | Todo (Trouble)                  | n    | [todo-comments.nvim] |
| `<leader>xT` | Todo/Fix/Fixme (Trouble)        | n    | [todo-comments.nvim] |
| `<leader>st` | Todo                            | n    | [todo-comments.nvim] |
| `<leader>xx` | Document Diagnostics (Trouble)  | n    | [trouble.nvim]       |
| `<leader>xX` | Workspace Diagnostics (Trouble) | n    | [trouble.nvim]       |
| `<leader>xL` | Location List (Trouble)         | n    | [trouble.nvim]       |
| `<leader>xQ` | Quickfix List (Trouble)         | n    | [trouble.nvim]       |
| `<C-i>`      | Go forward                      | n    | jumplist             |
| `<C-o>`      | Go backward                     | n    | jumplist             |
| `]d`         | Next Diagnostic                 | n    | LSP                  |
| `[d`         | Prev Diagnostic                 | n    | LSP                  |
| `]e`         | Next Error                      | n    | LSP                  |
| `[e`         | Prev Error                      | n    | LSP                  |
| `]w`         | Next Warning                    | n    | LSP                  |
| `[w`         | Prev Warning                    | n    | LSP                  |
| `]]`         | Next Reference                  | n    | [vim-illuminate]     |
| `[[`         | Prev Reference                  | n    | [vim-illuminate]     |
| `` `{A-Z} `` | Jump to the mark {a-zA-Z}       | n    | marks                |
| `m{a-zA-Z'}` | Set mark {a-zA-Z}               | n    | marks                |

## Buffers

- prefix: `<leader><tab>` for tabpage
- prefix: `<leader>w` for windows
- prefix: `<leader>b` for buffers

| Key                  | Description               | Mode    | Provider          |
| -------------------- | ------------------------- | ------- | ----------------- |
| **tabpage**          |                           |         | tabpage           |
| `<leader><tab>l`     | Last Tab                  | n       |                   |
| `<leader><tab>f`     | First Tab                 | n       |                   |
| `<leader><tab><tab>` | New Tab                   | n       |                   |
| `<leader><tab>]`     | Next Tab                  | n       |                   |
| `<leader><tab>d`     | Close Tab                 | n       |                   |
| `<leader><tab>[`     | Previous Tab              | n       |                   |
| **windows**          |                           |         | windows           |
| `<C-h>`              | Go to left window         | n       |                   |
| `<C-j>`              | Go to lower window        | n       |                   |
| `<C-k>`              | Go to upper window        | n       |                   |
| `<C-l>`              | Go to right window        | n       |                   |
| `<C-Up>`             | Increase window height    | n       |                   |
| `<C-Down>`           | Decrease window height    | n       |                   |
| `<C-Left>`           | Decrease window width     | n       |                   |
| `<C-Right>`          | Increase window width     | n       |                   |
| `<leader>w-`         | Split window below        | n       |                   |
| `<leader>w\|`        | Split window right        | n       |                   |
| `<leader>-`          | Split window below        | n       |                   |
| `<leader>\|`         | Split window right        | n       |                   |
| `<leader>ww`         | Switch to Other window    | n       |                   |
| `<leader>wd`         | Delete window             | n       |                   |
| **buffers**          |                           |         | buffers           |
| `<C-p>`              | Prev buffer               | n       |                   |
| `<C-n>`              | Next buffer               | n       |                   |
| `[b`                 | Prev buffer               | n       | [bufferline.nvim] |
| `]b`                 | Next buffer               | n       | [bufferline.nvim] |
| `<leader>bb`         | Switch to Other Buffer    | n       | editing           |
| `<leader>bp`         | Toggle pin buffer         | n       | [bufferline.nvim] |
| `<leader>bP`         | Delete non-pinned buffers | n       | [bufferline.nvim] |
| `<leader>bd`         | Delete Buffer             | n       | [utils.lua]       |
| `<leader>bD`         | Delete Other Buffers      | n       | [utils.lua]       |
| **file**             |                           |         |                   |
| `<C-s>`              | Save file                 | n, i, v | editing           |
| `<leader>fn`         | New File                  | n       | editing           |
| `<leader>qq`         | Quit all                  | n       | editing           |

## Fuzzy finder

- prefix: `<leader>f` for file/find
- prefix: `<leader>s` for search more kinds

| Key               | Description              | Mode | Provider         |
| ----------------- | ------------------------ | ---- | ---------------- |
| `<leader>,`       | Switch Buffer            | n    | [telescope.nvim] |
| `<leader>/`       | Find in Files (Grep)     | n    | [telescope.nvim] |
| `<leader>:`       | Command History          | n    | [telescope.nvim] |
| `<leader><space>` | Find Files (root dir)    | n    | [telescope.nvim] |
| `<leader>fb`      | Buffers                  | n    | [telescope.nvim] |
| `<leader>ff`      | Find Files (root dir)    | n    | [telescope.nvim] |
| `<leader>fF`      | Find Files (cwd)         | n    | [telescope.nvim] |
| `<leader>fr`      | Recent                   | n    | [telescope.nvim] |
| `<leader>gc`      | commits                  | n    | [telescope.nvim] |
| `<leader>gs`      | status                   | n    | [telescope.nvim] |
| `<leader>sa`      | Auto Commands            | n    | [telescope.nvim] |
| `<leader>sb`      | Buffer                   | n    | [telescope.nvim] |
| `<leader>sc`      | Command History          | n    | [telescope.nvim] |
| `<leader>sC`      | Commands                 | n    | [telescope.nvim] |
| `<leader>sd`      | Diagnostics              | n    | [telescope.nvim] |
| `<leader>sg`      | Grep (root dir)          | n    | [telescope.nvim] |
| `<leader>sG`      | Grep (cwd)               | n    | [telescope.nvim] |
| `<leader>sh`      | Help Pages               | n    | [telescope.nvim] |
| `<leader>sH`      | Search Highlight Groups  | n    | [telescope.nvim] |
| `<leader>sk`      | Key Maps                 | n    | [telescope.nvim] |
| `<leader>sM`      | Man Pages                | n    | [telescope.nvim] |
| `<leader>sm`      | Jump to Mark             | n    | [telescope.nvim] |
| `<leader>so`      | Options                  | n    | [telescope.nvim] |
| `<leader>sw`      | Word (root dir)          | n    | [telescope.nvim] |
| `<leader>sW`      | Word (cwd)               | n    | [telescope.nvim] |
| `<leader>uC`      | Colorscheme with preview | n    | [telescope.nvim] |
| `<leader>ss`      | Goto Symbol              | n    | [telescope.nvim] |

## Debug

- prefix: `<leader>d` for debug

| Key          | Description            | Mode | Provider      |
| ------------ | ---------------------- | ---- | ------------- |
| `<leader>db` | Toggle breakpoint      | n    | [nvim-dap]    |
| `<leader>dc` | Start / Continue       | n    | [nvim-dap]    |
| `<leader>di` | Step into              | n    | [nvim-dap]    |
| `<leader>do` | Step out               | n    | [nvim-dap]    |
| `<leader>dn` | Step over              | n    | [nvim-dap]    |
| `<leader>dh` | step to here(cursor)   | n    | [nvim-dap]    |
| `<leader>dq` | Stop                   | n    | [nvim-dap]    |
| `<leader>dk` | Show hover             | n, v | [nvim-dap]    |
| `<leader>dl` | Run last               | n    | [nvim-dap]    |
| `<leader>dR` | Restart                | n    | [nvim-dap]    |
| `<leader>da` | Show all breakpoints   | n    | [nvim-dap]    |
| `<leader>dx` | Remove all breakpoints | n    | [nvim-dap]    |
| `<leader>dB` | Conditional breakpoint | n    | [nvim-dap]    |
| `<leader>dL` | Logpoint               | n    | [nvim-dap]    |
| `<leader>du` | Toggle dapui           | n    | [nvim-dap-ui] |
| `<leader>dt` | Debug test             | n    | [nvim-dap-go] |
| `<leader>dT` | Debug last test        | n    | [nvim-dap-go] |

## Tests

- prefix: `<leader>t` for tests

| Key          | Description           | Mode | Provider    |
| ------------ | --------------------- | ---- | ----------- |
| `<leader>ta` | Attach                | n    | [neotest]   |
| `<leader>tr` | Run Nearest           | n    | [neotest]   |
| `<leader>tl` | Run Last              | n    | [neotest]   |
| `<leader>tf` | Run File              | n    | [neotest]   |
| `<leader>to` | Output                | n    | [neotest]   |
| `<leader>tq` | Stop                  | n    | [neotest]   |
| `<leader>ts` | Summary               | n    | [neotest]   |
| `<leader>th` | run http request      | n    | [rest.nvim] |
| `<leader>tl` | run last http request | n    | [rest.nvim] |
| `<leader>tc` | preview cURL command  | n    | [rest.nvim] |
| `<leader>tg` | run gRPC request      | n    | [grpc-nvim] |

## Run

- prefix: `<leader>r` for run

| Key          | Description                    | Mode | Provider  |
| ------------ | ------------------------------ | ---- | --------- |
| `<leader>ra` | Run All                        | n    | [sniprun] |
| `<leader>rr` | Run Current                    | n, v | [sniprun] |
| `<leader>rR` | Reset & (Close UI, Clear REPL) | n    | [sniprun] |
| `<leader>ri` | Run Info                       | n    | [sniprun] |
| `<leader>rI` | Find Interpreters              | n    | [sniprun] |

[which-key.nvim]: https://github.com/folke/which-key.nvim
[bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[nvim-spectre]: https://github.com/windwp/nvim-spectre
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[trouble.nvim]: https://github.com/folke/trouble.nvim
[nvim-treehopper]: https://github.com/mfussenegger/nvim-treehopper
[flit.nvim]: https://github.com/ggandor/flit.nvim
[leap.nvim]: https://github.com/ggandor/leap.nvim
[vim-illuminate]: https://github.com/RRethy/vim-illuminate
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[nvim-dap-ui]: https://github.com/rcarriga/nvim-dap-ui
[nvim-dap-go]: https://github.com/leoluz/nvim-dap-go
[neotest]: https://github.com/nvim-neotest/neotest
[sniprun]: https://github.com/michaelb/sniprun
[rest.nvim]: https://github.com/rest-nvim/rest.nvim
[grpc-nvim]: https://github.com/hudclark/grpc-nvim
[lazygit]: https://github.com/jesseduffield/lazygit
[mini.comment]: https://github.com/echasnovski/mini.comment
[windows.nvim]: https://github.com/anuvyklack/windows.nvim
[zen-mode.nvim]: https://github.com/folke/zen-mode.nvim
[nvim-tree.lua]: https://github.com/nvim-tree/nvim-tree.lua
[vim-dadbod]: https://github.com/tpope/vim-dadbod
[aerial.nvim]: https://github.com/stevearc/aerial.nvim
[nvterm]: https://github.com/NvChad/nvterm
[lazy.nvim]: https://github.com/folke/lazy.nvim
[mason.nvim]: https://github.com/williamboman/mason.nvim
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[glow.nvim]: https://github.com/ellisonleao/glow.nvim
[plantuml-previewer.vim]: https://github.com/weirongxu/plantuml-previewer.vim
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[utils.lua]: lua/utils.lua
[which-key]: https://user-images.githubusercontent.com/318253/232319921-57f1dbf4-a755-459f-8e52-66a410e96151.png "which key"

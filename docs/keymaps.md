# ⌨️ Keymaps

Uses [which-key.nvim] to live prompt for keymaps.
Just press any key like `,` will displays a popup with all possible keymaps starting with `,`.

![which-key]

# Table of contents

1.  [Modes](#modes)
2.  [General](#general)
3.  [Basic editing](#basic-editing)
4.  [Rich languages editing](#rich-languages-editing)
5.  [Multi-cursor and selection](#multi-cursor-and-selection)
6.  [Display](#display)
7.  [Find and replace](#find-and-replace)
8.  [Navigation](#navigation)
9.  [Buffers](#buffers)
10. [Fuzzy finder](#fuzzy-finder)
11. [Debug](#debug)
12. [Tests](#tests)
13. [Run/REPL](#run/repl)
14. [More](#more)

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

| Key             | Description                        | Mode    | Provider     |
| --------------- | ---------------------------------- | ------- | ------------ |
| `y`             | Yank selected                      | v       | register     |
| `p`             | Put the text after the cursor      | n, v    | register     |
| `P`             | Put the text before the cursor     | n, v    | register     |
| `x`             | Delete char, same as `dl`          | n, v    | register     |
| `X`             | Delete char, same as `dh`          | n, v    | register     |
| `cc`            | Editing line                       | n -> i  | register     |
| `dd`            | Delete line                        | n       | register     |
| `yy`            | Yank line                          | n       | register     |
| `C`             | Delete to end of line              | n -> i  | register     |
| `D`             | Delete to end of line              | n, v    | register     |
| `Y`             | Yank to end of line                | n, v    | register     |
| `<A-j>`         | Move line/block down               | n, i, v | move         |
| `<A-k>`         | Move line/block up                 | n, i, v | move         |
| `u`             | Undo                               | n       | undo         |
| `<C-r>`         | Redo                               | n       | redo         |
| `o`             | Insert line below                  | n       | Insert-mode  |
| `O`             | Insert line above                  | n       | Insert-mode  |
| `%`             | Jump to matching bracket           | n       | motion       |
| `>>`            | Indent line                        | n       | motion       |
| `<<`            | Outdent line                       | n       | motion       |
| `>`             | Indent line                        | v       | motion       |
| `<`             | Outdent line                       | v       | motion       |
| `^`             | Go to beginning of line            | n, v    | motion       |
| `$`             | Go to end of line                  | n, v    | motion       |
| `gg`            | Go to first line                   | n, v    | motion       |
| `G`             | Go to last line                    | n, v    | motion       |
| `j`             | Move cursor down                   | n, v    | motion       |
| `k`             | Move cursor up                     | n, v    | motion       |
| `H`             | To Header (top) line of window     | n, v    | motion       |
| `M`             | To Middle line of window           | n, v    | motion       |
| `L`             | To Last (bottom) line of window    | n, v    | motion       |
| `<C-f>`         | Scroll page down                   | n, v    | scrolling    |
| `<C-b>`         | Scroll page up                     | n, v    | scrolling    |
| `<C-d>`         | Scroll page down (half a screen)   | n, v    | scrolling    |
| `<C-u>`         | Scroll page up (half a screen)     | n, v    | scrolling    |
| `zz`            | Scroll cursor to center screen     | n, v    | scrolling    |
| `za`            | Toggle fold under cursor           | n       | fold         |
| `zA`            | Toggle all folds under cursor      | n       | fold         |
| `gcc`           | Toggle line comment                | n       | various      |
| `gc`            | Toggle selected comment            | v       | various      |
| `dgc`           | Delete comment                     | v       | various      |
| `f{char}`       | Enhanced f/t motions               | n       | [flash.nvim] |
| `s{char}{char}` | Jump by 2-character search pattern | n       | [flash.nvim] |

Command-line mode uses readline-style keymaps.

## Rich languages editing

- prefix: `<leader>c` for code

| Key          | Description                       | Mode | Provider   |
| ------------ | --------------------------------- | ---- | ---------- |
|              | auto completion                   | i    | [nvim-cmp] |
| `K`          | Hover                             | n    | LSP        |
| `gK`         | Trigger Signature Help            | n    | LSP        |
| `<c-k>`      | Trigger Signature Help            | i    | LSP        |
| `<leader>cf` | Format Document                   | n    | LSP        |
| `<leader>cf` | Format Range                      | v    | LSP        |
| `ge`         | Goto D[e]claration                | n    | LSP        |
| `gd`         | Goto Definition                   | n    | LSP        |
| `gD`         | Goto Type Definition              | n    | LSP        |
| `gI`         | Goto Implementation               | n    | LSP        |
| `gr`         | Find References                   | n    | LSP        |
| `<leader>cn` | Rename                            | n    | LSP        |
| `<leader>ca` | Code Action                       | n, v | LSP        |
| `<leader>cl` | Code Lens                         | n, v | LSP        |
| `<leader>cr` | Refactor                          | n, v | LSP        |
| `<leader>cc` | Code Clean                        | n    | LSP        |
| `gf`         | Goto File                         | n, v | editing    |
| `gi`         | Move to last insertion and INSERT | n    | insert     |
| `gw`         | Highlighting word under cursor    | n    | keymaps    |
| `z=`         | Spelling suggestions              | n    | spell      |

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
- prefix: `<leader>m` for manager/info
- prefix: `<leader>u` for ui
- prefix: `<leader>v` for tool

| Key          | Description             | Mode | Provider                 |
| ------------ | ----------------------- | ---- | ------------------------ |
| `gz`         | Zen Mode                | n, t | [zen-mode.nvim]          |
| `<C-=>`      | Zoom in                 | n, t | system                   |
| `<C-->`      | Zoom out                | n, t | system                   |
| `<leader>e`  | File Explorer           | n, t | [neo-tree.nvim]          |
| `<leader>E`  | Database Explorer       | n    | [vim-dadbod]             |
| `ge`         | Git Explorer            | n    | [neo-tree.nvim]          |
| `<leader>o`  | Outline                 | n    | [aerial.nvim]            |
| `<leader>tt` | Terminal                | n, t | [nvterm]                 |
| `<leader>gg` | Lazygit                 | n    | [lazygit]                |
| `<leader>gt` | Tig                     | n    | [tig]                    |
| `<leader>mz` | Lazy                    | n    | [lazy.nvim]              |
| `<leader>mm` | Mason                   | n    | [mason.nvim]             |
| `<leader>ml` | Lsp Info                | n    | [nvim-lspconfig]         |
| `<leader>mt` | Treesitter Config Info  | n    | [nvim-treesitter]        |
| `<leader>md` | Dap Show Log            | n    | [nvim-dap]               |
| `<leader>mc` | Conform Info            | n    | [conform.nvim]           |
| `<leader>mf` | Lazy Format Info        | n    | LazyFormatInfo           |
| `<leader>mb` | Buffer Info             | n    | [util.ui]                |
| `<leader>mk` | Which Key               | n    | [which-key.nvim]         |
| `<leader>mn` | Noice History           | n    | [noice.nvim]             |
| `<leader>dd` | Show DAP configurations | n    | [nvim-dap]               |
|              | Show Output Panel       | n    |                          |
| `<leader>cp` | Preview (markdown)      | n    | [glow.nvim]              |
| `<leader>cp` | Live Preview (markdown) | n    | [peek.nvim]              |
| `<leader>cp` | Live Preview (plantuml) | n    | [plantuml-previewer.vim] |

## Find and replace

| Key          | Description                | Mode    | Provider         |
| ------------ | -------------------------- | ------- | ---------------- |
| `<leader>fr` | Replace in files (Spectre) | n       | [nvim-spectre]   |
| `<leader>/`  | Find in files (grep)       | n       | [telescope.nvim] |
| `*`          | Search forward             | n, v    | pattern          |
| `#`          | Search backward            | n, v    | pattern          |
| `n`          | Find next                  | n, x, o | pattern          |
| `N`          | Find previous              | n, x, o | pattern          |

## Navigation

- prefix: `<leader>x` for diagnostics/quickfix

| Key          | Description                    | Mode | Provider             |
| ------------ | ------------------------------ | ---- | -------------------- |
| `:{number}`  | Go to Line                     | n    | cmdline              |
| `<leader>ff` | Go to File                     | n    | [telescope.nvim]     |
| `<leader>fs` | Find Symbols                   | n    | [telescope.nvim]     |
| `]t`         | Next todo comment              | n    | [todo-comments.nvim] |
| `[t`         | Previous todo comment          | n    | [todo-comments.nvim] |
| `<leader>xt` | Todo (Trouble)                 | n    | [todo-comments.nvim] |
| `<leader>xT` | Todo                           | n    | [todo-comments.nvim] |
| `<leader>xx` | Diagnostics (Trouble)          | n    | [trouble.nvim]       |
| `<leader>xX` | Document Diagnostics (Trouble) | n    | [trouble.nvim]       |
| `<leader>xl` | Location List                  | n    | quickfix             |
| `<leader>xl` | Location List (Trouble)        | n    | [trouble.nvim]       |
| `<leader>xq` | Quickfix List                  | n    | quickfix             |
| `<leader>xq` | Quickfix List (Trouble)        | n    | [trouble.nvim]       |
| `<C-i>`      | Go forward                     | n    | jumplist             |
| `<C-o>`      | Go backward                    | n    | jumplist             |
| `]d`         | Next Diagnostic                | n    | LSP                  |
| `[d`         | Prev Diagnostic                | n    | LSP                  |
| `]e`         | Next Error                     | n    | LSP                  |
| `[e`         | Prev Error                     | n    | LSP                  |
| `]w`         | Next Warning                   | n    | LSP                  |
| `[w`         | Prev Warning                   | n    | LSP                  |
| `]]`         | Next Reference                 | n    | LSP                  |
| `[[`         | Prev Reference                 | n    | LSP                  |
| `` `{A-Z} `` | Jump to the mark {a-zA-Z}      | n    | marks                |
| `m{a-zA-Z'}` | Set mark {a-zA-Z}              | n    | marks                |

## Buffers

- prefix: `<leader><tab>` for tabpage
- prefix: `<leader>w` for windows
- prefix: `<leader>b` for buffers

| Key           | Description                        | Mode    | Provider          |
| ------------- | ---------------------------------- | ------- | ----------------- |
| **tabpage**   |                                    |         | tabpage           |
|               | Last Tab                           | n       |                   |
|               | First Tab                          | n       |                   |
|               | New Tab                            | n       |                   |
|               | Next Tab                           | n       |                   |
|               | Close Tab                          | n       |                   |
|               | Previous Tab                       | n       |                   |
| **windows**   |                                    |         | windows           |
| `<C-h>`       | Go to left window                  | n       |                   |
| `<C-j>`       | Go to lower window                 | n       |                   |
| `<C-k>`       | Go to upper window                 | n       |                   |
| `<C-l>`       | Go to right window                 | n       |                   |
| `<A-Up>`      | Increase window height             | n       |                   |
| `<A-Down>`    | Decrease window height             | n       |                   |
| `<A-Left>`    | Decrease window width              | n       |                   |
| `<A-Right>`   | Increase window width              | n       |                   |
| `<leader>w-`  | Split window below                 | n       |                   |
| `<leader>w\|` | Split window right                 | n       |                   |
| `<leader>-`   | Split window below                 | n       |                   |
| `<leader>\|`  | Split window right                 | n       |                   |
| `<leader>ww`  | Switch to Other window             | n       |                   |
| `<leader>wd`  | Delete window                      | n       |                   |
| **buffers**   |                                    |         | buffers           |
| `<leader>bn`  | New File                           | n       | editing           |
| `<C-s>`       | Save file                          | n, i, v | editing           |
| `<C-p>`       | Prev buffer                        | n       |                   |
| `<C-n>`       | Next buffer                        | n       |                   |
| `[b`          | Prev buffer                        | n       | [bufferline.nvim] |
| `]b`          | Next buffer                        | n       | [bufferline.nvim] |
| `[B`          | Move Buffer Prev                   | n       | [bufferline.nvim] |
| `]B`          | Move Buffer Next                   | n       | [bufferline.nvim] |
| `<leader>bb`  | Switch to Other Buffer             | n       | editing           |
| `<leader>bd`  | Delete Buffer                      | n       | [util.ui]         |
| `<leader>bo`  | Delete Other Buffers (Buffer Only) | n       | [util.ui]         |
| `<leader>bp`  | Toggle Pin Buffer                  | n       | [bufferline.nvim] |
| `<leader>bP`  | Delete Non-Pinned Buffers          | n       | [bufferline.nvim] |

## Fuzzy finder

- prefix: `<leader>f` for file/find

| Key               | Description               | Mode | Provider         |
| ----------------- | ------------------------- | ---- | ---------------- |
| `<leader><space>` | Telescope Builtin         | n    | [telescope.nvim] |
| `<leader>fa`      | same as `<leader><space>` | n    | [telescope.nvim] |
| `<leader>,`       | Switch Buffer             | n    | [telescope.nvim] |
| `<leader>/`       | Find in Files (Grep)      | n    | [telescope.nvim] |
| `<leader>/`       | Find in Files (Grep)      | v    | [telescope.nvim] |
| `<leader>:`       | Command History           | n    | [telescope.nvim] |
| `<leader>fc`      | Cheatsheets               | n    | [telescope.nvim] |
| `<leader>fk`      | Keymaps                   | n    | [telescope.nvim] |
| `<leader>fs`      | Go to Symbol              | n    | [telescope.nvim] |
| `<leader>ff`      | Find Files                | n    | [telescope.nvim] |
| `<leader>fg`      | Find Git Files            | n    | [telescope.nvim] |
| `<leader>fR`      | Recent                    | n    | [telescope.nvim] |
| `<leader>fp`      | Find Project              | n    | [telescope.nvim] |
| `<leader>fx`      | Find Plugin Config        | n    | [telescope.nvim] |
| `<leader>fz`      | Find Plugin File          | n    | [telescope.nvim] |

## Debug

- prefix: `<leader>d` for debug

| Key           | Description                  | Mode | Provider          |
| ------------- | ---------------------------- | ---- | ----------------- |
| `<leader>da`  | All Commands                 | n    | [telescope.nvim]  |
| `<leader>db`  | Toggle Breakpoint            | n    | [nvim-dap]        |
| `<leader>dc`  | Start / Continue             | n    | [nvim-dap]        |
| `<leader>di`  | Step Into                    | n    | [nvim-dap]        |
| `<leader>do`  | Step Out                     | n    | [nvim-dap]        |
| `<leader>dn`  | Step Over (Next)             | n    | [nvim-dap]        |
| `<leader>dh`  | Step to Cursor (Here)        | n    | [nvim-dap]        |
| `<A-e>`       | evel                         | n, v | [nvim-dap-ui]     |
| `<leader>de`  | Show Hover (expression)      | n, v | [nvim-dap-ui]     |
| `<leader>d.`  | Run Last                     | n    | [nvim-dap]        |
| `<leader>dk`  | Up (stacktrace)              | n    | [nvim-dap]        |
| `<leader>dj`  | Down (stacktrace)            | n    | [nvim-dap]        |
| `<leader>dq`  | Stop                         | n    | [nvim-dap]        |
| `<leader>dd`  | Show DAP configurations      | n    | [telescope.nvim]  |
| `<leader>dr`  | Start / Continue             | n    | [nvim-dap]        |
| `<leader>dR`  | Restart                      | n    | [nvim-dap]        |
| `<leader>dx`  | Show All Breakpoints         | n    | [telescope.nvim]  |
| `<leader>dX`  | Remove All Breakpoints       | n    | [nvim-dap]        |
| `<leader>dB`  | Conditional Breakpoint       | n    | [nvim-dap]        |
| `<leader>du`  | Dap UI                       | n    | [nvim-dap-ui]     |
| `<leader>dwe` | Show Eval (float window)     | n    | [nvim-dap]        |
| `<leader>dws` | Show Sessions (float window) | n    | [nvim-dap]        |
| `<leader>dt`  | Debug test                   | n    | [nvim-dap-go]     |
| `<leader>dT`  | Debug last test              | n    | [nvim-dap-go]     |
| `<leader>dC`  | Debug Class                  | n    | [nvim-dap-python] |
| `<leader>dM`  | Debug Method                 | n    | [nvim-dap-python] |
| `<leader>dS`  | Debug Selection              | n    | [nvim-dap-python] |
| `<leader>D`   | Neovim log set to            |

## Tests

- prefix: `<leader>t` for tests

| Key          | Description       | Mode | Provider  |
| ------------ | ----------------- | ---- | --------- |
| `<leader>ta` | Attach            | n    | [neotest] |
| `<leader>tr` | Run Nearest       | n    | [neotest] |
| `<leader>t.` | Run Last          | n    | [neotest] |
| `<leader>tf` | Run File          | n    | [neotest] |
| `<leader>tq` | Stop              | n    | [neotest] |
| `<leader>to` | Show Output       | n    | [neotest] |
| `<leader>ts` | Show Summary      | n    | [neotest] |
| `<leader>td` | Debug Nearest     | n    | [neotest] |
| `<leader>tO` | Show Output Panel | n    | [neotest] |

## Run/REPL

- prefix: `<leader>r` for run/REPL

| Key             | Description           | Mode | Provider      |
| --------------- | --------------------- | ---- | ------------- |
| **REPL**        |                       |      | REPL          |
| `<leader>rr`    | Run code block        | n, v | [iron.nvim]   |
| `<leader>rl`    | Run cursor line       | n    | [iron.nvim]   |
| `<leader>rf`    | Run file              | n    | [iron.nvim]   |
| `<leader>r<cr>` | Send `return` to repl | n    | [iron.nvim]   |
| `<leader>ri`    | Interrupt (`<C-c>`)   | n    | [iron.nvim]   |
| `<leader>rq`    | Quit                  | n    | [iron.nvim]   |
| `<leader>rx`    | Clear                 | n    | [iron.nvim]   |
| `<leader>ru`    | Repl UI Toggle        | n    | [iron.nvim]   |
| `<leader>rR`    | Repl Restart          | n    | [iron.nvim]   |
| `<leader>rF`    | Repl Focus            | n    | [iron.nvim]   |
| **Others**      |                       |      | Clients       |
| `<leader>rr`    | Run gRPC request      | n    | [grpc-nvim]   |
| `<leader>rr`    | Run http request      | n    | [kulala.nvim] |
| `<leader>r.`    | Run Last Http Request | n    | [kulala.nvim] |
| `<leader>rc`    | Copy as cURL          | n    | [kulala.nvim] |
| `<leader>rp`    | Paste from curl       | n    | [kulala.nvim] |
| `<leader>rs`    | Show stats            | n    | [kulala.nvim] |

## More

| Key              | Description                      | Mode | Provider         |
| ---------------- | -------------------------------- | ---- | ---------------- |
| **Fuzzy Finder** | Keymaps for `Telescope`          |      | Telescope        |
| `<C-/>`          | Show mappings for picker actions | i    | [telescope.nvim] |
| `?`              | Show mappings for picker actions | n    | [telescope.nvim] |
| `j/k`            | Next/previous                    | n    | [telescope.nvim] |
| `H/M/L`          | Select High/Middle/Low           | n    | [telescope.nvim] |
| `gg/G`           | Select the first/last item       | n    | [telescope.nvim] |
| `<CR>`           | Confirm selection                | n    | [telescope.nvim] |
| `<Esc><Esc>`     | Close telescope                  | i, n | [telescope.nvim] |
| `<Tab>`          | Select/Deselect                  | i, n | [telescope.nvim] |
| `<C-Down>`       | Next search prompt in history    | i    | [telescope.nvim] |
| `<C-Up>`         | Prev search prompt in history    | i    | [telescope.nvim] |
| `<C-n>`          | Next like `j`                    | i, n | [telescope.nvim] |
| `<C-p>`          | Prev like `k`                    | i, n | [telescope.nvim] |
| `<C-f>`          | Scroll the preview window down   | i    | [telescope.nvim] |
| `<C-b>`          | Scroll the preview window up     | i    | [telescope.nvim] |
| `<C-d>`          | Scroll the preview window down   | i    | [telescope.nvim] |
| `<C-u>`          | Scroll the preview window up     | i    | [telescope.nvim] |
| `<C-x>`          | Show all results in trouble      | i    | [telescope.nvim] |
| `<A-x>`          | Show selected results in Trouble | i    | [telescope.nvim] |
| `<A-p>`          | Toggle preview                   | i, n | [telescope.nvim] |
| **Database**     | Keymaps for `vim-dadbod-ui`      |      | vim-dadbod-ui    |
| `<leader-S>`     | Execute Query                    | i, v | [vim-dadbod-ui]  |

[which-key.nvim]: https://github.com/folke/which-key.nvim
[noice.nvim]: https://github.com/folke/noice.nvim
[bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[nvim-spectre]: https://github.com/windwp/nvim-spectre
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[trouble.nvim]: https://github.com/folke/trouble.nvim
[nvim-treehopper]: https://github.com/mfussenegger/nvim-treehopper
[flash.nvim]: https://github.com/folke/flash.nvim
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[nvim-dap-ui]: https://github.com/rcarriga/nvim-dap-ui
[nvim-dap-go]: https://github.com/leoluz/nvim-dap-go
[nvim-dap-python]: https://github.com/mfussenegger/nvim-dap-python
[neotest]: https://github.com/nvim-neotest/neotest
[sniprun]: https://github.com/michaelb/sniprun
[iron.nvim]: https://github.com/ueaner/iron.nvim
[kulala.nvim]: https://github.com/mistweaverco/kulala.nvim
[grpc-nvim]: https://github.com/hudclark/grpc-nvim
[lazygit]: https://github.com/jesseduffield/lazygit
[tig]: https://github.com/jonas/tig
[zen-mode.nvim]: https://github.com/folke/zen-mode.nvim
[neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[vim-dadbod]: https://github.com/tpope/vim-dadbod
[vim-dadbod-ui]: https://github.com/kristijanhusak/vim-dadbod-ui
[aerial.nvim]: https://github.com/stevearc/aerial.nvim
[nvterm]: https://github.com/NvChad/nvterm
[lazy.nvim]: https://github.com/folke/lazy.nvim
[mason.nvim]: https://github.com/mason-org/mason.nvim
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[glow.nvim]: https://github.com/ellisonleao/glow.nvim
[peek.nvim]: https://github.com/toppair/peek.nvim
[plantuml-previewer.vim]: https://github.com/weirongxu/plantuml-previewer.vim
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[conform.nvim]: https://github.com/stevearc/conform.nvim
[nvim-lint]: https://github.com/mfussenegger/nvim-lint
[util.ui]: lua/util/ui.lua
[which-key]: https://github.com/ueaner/nvimrc/assets/318253/ae311950-0104-4d72-a368-a1234b5ba6ab "which key"

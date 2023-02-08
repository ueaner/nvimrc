![截图](https://i.imgur.com/ScFMDYe.png)

[Nvchad](https://hugo.jiahongw.com/zh/posts/efficient/nvchad%E4%BD%BF%E7%94%A8/) 看起来不错
[各种 Unicode 图标](https://unicode-table.com/)

当前配置适用于 neovim 的最新版本。global statusline nvim0.7+, winbar nvim0.8+
mouse click support with the %@ item for 'statusline' and 'winbar'. https://github.com/neovim/neovim/pull/18650

winbar 就像 0.7 版本前的 statusline，每个打开的窗口都一个 winbar，使用 floatwin
做一个全局的展示信息的东西可能会好点，如果 clipboard 状态。

有的是用来操作的如 fzf，有的是用来展示可以一眼就看得见的如 tree line bar 等

nerdtree 展示各个文件的全局信息
tabline/bufline 左侧展示已打开文件的各个状态信息（如是否被更改，未保存，是否有LSP错误等），右侧展 global option 的配置信息（如clipborad等开关信息）
statusline 展示当前文件的信息，bufnumber，文件全名，文件类型，文件编码，光标信息等
winbar 可点击的话可展示调试按钮


vim8.2+

需要从 coc 转到 nvim-lspconfig，在社区生态上，官方支持 nvim-lspconfig，社区更多的资源在围绕 nvim-lspconfig
的生态上，如在查找 tailwindcss 在 neovim 的支持上，找到的 coc-tailwindcss 已经两年没有更新了

https://elijahmanor.com/blog/neovim-tailwindcss

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'hrsh7th/nvim-cmp'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/trouble.nvim'

## 为什么 Neovim 嵌入 lua 代替 vimscript

https://github.com/neovim/neovim/wiki/FAQ#why-embed-lua-instead-of-x

nvim lua 开发：
https://github.com/neovim/neovim/wiki/FAQ#develop

## 整体布局理论基础

### general options

### 高亮

- tree-sitter
- ctags

### LSP

- coc.nvim: https://fann.im/blog/2021/08/01/thoughts-on-coc.nvim/
    - node-based LSP client + handler + extensions host + auto completion engine + UI
    - 基于 js 更多是要把 vscode 的生态资源整合进来
- neovim builtin lsp
    - lsp

lua require('lspfuzzy').setup {}

### DAP

### Fuzzy Finder

### Linter

### Formater

### User Interface

### startup

$ go install github.com/rhysd/vim-startuptime@latest
$ vim-startuptime -vimpath nvim

针对性的对某个的执行情况进行 profile
$ vim --cmd 'profile start profile.log' --cmd 'profile! file /path/to/slow_script.vim' -c quit


## 具体实践

intent 缩进的设置，应该由 editconfig 管理，vim 中不设置相关 tabstop shiftwidth sts 等选项.
这样实际项目中的缩进就有规则可循。

```javascript
let text = await fileUtil.readText(filePath);
var tabSize = 4;
var reg ;
if ( /\n(  )[\w\<\.\(\{"']/.test(text) ) {
    tabSize =2 ;
    reg = /\n(  )+/g ;
} else if ( /\n(    )[\w\<\.\(\{"']/.test( text ) ) {
    tabSize = 4 ;
    reg =  /\n(    )+/g ;
} else {
    return;
}
```

### tabnine

https://github.com/neoclide/coc-tabnine
AI 自动补全

## 文档参考

### vim 文档
:h quickref
:h

:help index 以字母顺序排列的命令索引，包含各个模式下所有命令的一个完整列表
:help reference_toc

### 参考

https://github.com/junegunn/dotfiles/blob/master/vimrc

## 使用

macOS/Linux:

    git clone https://github.com/ueaner/vimrc.git ~/.vim

windows cmd.exe:

    git clone https://github.com/ueaner/vimrc.git %USERPROFILE%\vimfiles

`7.4 之前的版本`需要做个软链:

    macOS/Linux: ln -s ~/.vim/vimrc ~/.vimrc

    windows: 创建快捷方式：%USERPROFILE%\_vimrc

## 自定义本地配置

通过编辑 `~/.vim/vimrc.local` 文件自定义本地配置，编辑之后在 vim 命令行中执行
`:source ~/.vim/vimrc.local` ，或者重新打开 vim 使配置生效。

support 目录下提供了一个正在使用的自定义 [vimrc.local] 配置，可以直接做软链使用：

```sh
ln -sf ~/.vim/support/vimrc.local ~/.vim/vimrc.local
```

## 插件管理

这里以 [vim-plug] 插件管理器为例:

首先下载 vim-plug 插件管理器：

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

编辑 `~/.vim/vimrc.local` 文件，添加以下内容：

```vim
" 插件存储路径
call plug#begin($HOME . "/.cache/vim-bundle")

" 插件列表
Plug 'ap/vim-buftabline'
Plug 'scrooloose/nerdtree'
Plug 'ueaner/molokai'

" ...

call plug#end()

" 插件自定义配置 ...
```

Vim 命令行执行安装:

    :PlugInstall

等待少许时间, 配置的插件就安装完成了。

## 快捷键

整体上归类，才清楚都有什么东西；但是在操作上能打平的就打平，只要符合操作思维思路即可。

VSCode User Interface: https://code.visualstudio.com/docs/getstarted/userinterface
- Basic Layout
    - Activity Bar
    - Side Bar
    - Status Bar: 当前已打开的项目和正在编辑的文件信息
    - Editor Groups: 编辑文件的主要区域
    - Panel: quickfix, 输出或调试信息、错误和警告，或集成终端
- Breadcrumbs -> Code Navigation, 文件函数路径
- Explorer: The Explorer is used to browse, open, and manage all of the files and folders in your project.
    - ,e: File Explorer
    - ,j: 跳转到当前打开的文件
- Outline
    - ,o: Outline
    - ,s: symbols
- Command Palette: 是否可以像 VSCode 一样 Command + Shift + P 打开命令面板


? 通常用于帮助信息、preview（如 fzf preview）、搜索（vim 向上搜索）
/ 和 ? 也通常用于内容搜索

两套列表选择方式：
CTRL-N / CTRL-P 补全菜单的上一项、下一项
`Command + <` / `Command + >` 上一个下一个标签页

CTRL-T / Command + T 打开一个新标签页，相当于开启了一个新的线程
Command + N 打开一个新窗口，相当于开启了一个新的进程
Command + W 关闭窗口

插入模式的移动走 Readline 风格，NORMAL 模式走 Vim 风格

复制、粘贴：剪切板、粘贴模式
编辑：Readline 风格、提示补全
查看：zoom, fold，outline
高亮：语法、即时 keyword highlight
单文件：
多文件：导航查看、文件切换、关联跳转
内容搜索，文件模糊搜索，

Find Action: ,a
Search Everywhere: <S-S> Double ⇧, [All Types Symbols Actions Git]
nmap <C-P> :Files<CR>   在轮换 buffer
nmap <C-E> :Buffers<CR>

editing, navigation, refactoring, debugging, and other tasks

- a, e, i, j, u, w, y
- t 拿出来做 vimrc.local 映射用

```
|-----------|----------|--------------|-----------------------------------|
| Section   | map mode | Key bindings | Description                       |
|-----------|----------|--------------|-----------------------------------|
| Explorer  |    n     | ,e           | file [n]avigation                 |
|           |    n     | ,l           | [l]ocate / select opened file     |
|-----------|----------|--------------|-----------------------------------|
| Outline   |    n     | ,o           | [o]utline toggle                  |
|           |    n     | ,O           | symb[O]ls toggle                  |
|           |    n     | go           | outline interactive               |
|           |    n     | gO           | symbols interactive               |
|-----------|----------|--------------|-----------------------------------|
| Fold      |    n     | ,<space>     | fold toggle in file, :help z      |
|           |    n     | <space>      | fold toggle under cursor          |
|-----------|----------|--------------|-----------------------------------|
| Marks     |    n     | ,m           | [m]arks                           |
|-----------|----------|--------------|-----------------------------------|
| Content   |    n     | ,k           | highlight [k]eywords under cursor |
|           |    n     | ,/           | finding in files, :help /         |
|           |    n     | ,h           | v:[h]lsearch toggle               |
|           |    n     | ,H           | :History                          |
|           |    n     | K            | show documentation under cursor   |
|-----------|----------|--------------|-----------------------------------|
| Spell     |    n     | ,s           | [s]pell check Toggle              |
|-----------|----------|--------------|-----------------------------------|
| Clipboard |    n     | ,c           | [c]lipboard toggle                |
|-----------|----------|--------------|-----------------------------------|
| Paste     |    n     | ,p           | [p]aste toggle                    |
|-----------|----------|--------------|-----------------------------------|
| TODO      |    n     | ,x           | todo list                         |
|-----------|----------|--------------|-----------------------------------|
| Buffers   |    n     | ,,           | switching between [two] files     |
|           |    n     | ,b           | [b]uffers                         |
|           |    n     | ,e           | MRU                               |
|           |    n     | ,f           | [f]iles                           |
|           |    n     | ,q           | CloseSplitOrDeleteBuffer          |
|           |    n     | ,Q           | CloseOtherBuffers                 |
|           |    n     | <C-N>        | [n]ext buffer                     |
|           |    n     | <C-P>        | [p]revious buffer                 |
|-----------|----------|--------------|-----------------------------------|
| Windows   |          |              | :help CTRL-W, :help window-resize |
|           |    n     | ,z           | zoom toggle                       |
|           |    n     | |            | :only                             |
|           |    n     | +            | :resize +3                        |
|           |    n     | _            | :resize -3                        |
|-----------|----------|--------------|-----------------------------------|
| Git       |    n     | ,gk          | signify-prev-hunk                 |
|           |    n     | ,gj          | signify-next-hunk                 |
|           |    n     | ,gK          | 9999,gk                           |
|           |    n     | ,gJ          | 9999,gj                           |
|           |    n     | ,gb          | tig [b]lame                       |
|-----------|----------|--------------|-----------------------------------|
| g         |    n     | gd           | goto local [d]eclaration          |
|           |    n     | gD           | goto global [D]eclaration         |
|           |    n     | gf           | goto [f]ile                       |
|           |    n     | gF           | goto [F]ile.c:20                  |
|           |    n     | gy           | goto t[y]pe definition            |
|           |    n     | gi           | goto [i]mplementation             |
|           |    n     | gr           | goto [r]eferences                 |
|-----------|----------|--------------|-----------------------------------|
| Debug     |    n     | ,de          | [e]xec                            |
|           |    n     | ,dt          | [t]est                            |
|           |    n     | ,dc          | [c]ontinue                        |
|           |    n     | ,ds          | [s]tep over                       |
|           |    n     | ,di          | step [i]nto                       |
|           |    n     | ,do          | step [o]ut                        |
|           |    n     | ,db          | [b]reakpoint toggle               |
|           |    n     | ,dB          | [B]reakpoint condition            |
|           |    n     | ,dr          | [r]epl(Read-Eval-Print Loop)      |
|           |    n     | ,dl          | debug [l]og                       |
|-----------|----------|--------------|-----------------------------------|
| Edit      |    n     | ,M           | remove trailing [^M]              |
|           |    n     | ,W           | remove trailing [W]hitespace      |
|           |    n     | ,vv          | edit $MYVIMRC                     |
|           |    n     | ,va          | edit alacritty.yml                |
|           |    n     | ,vt          | edit tmux.conf                    |
|           |    n, i  | <C-S>        | :update                           |
|-----------|----------|--------------|-----------------------------------|
| Readline  |    i, c  |              | [readline shortcut]               |
|-----------|----------|--------------|-----------------------------------|
| Register  |    i     | <C-N>        | show registers on the sidebar     |
|           |    n     | " or @       | show registers on the sidebar     |
|-----------|----------|--------------|-----------------------------------|
| Align     |    n     | ,|           | :EasyAlign*|<CR>                  |
|           |    n     | ,\           | Ditto                             |
|-----------|----------|--------------|-----------------------------------|
| Terminal  |    n     | ,T           | :FloatermToggle<CR>               |
|           |    t     | ,T           | <C-\><C-n>:FloatermToggle<CR>     |
|-----------|----------|--------------|-----------------------------------|
| Intent    |    n     | ,i2          | [2] spaces indentation            |
|           |    n     | ,i4          | [4] spaces indentation            |
|-----------|----------|--------------|-----------------------------------|
| Misc      |    n     | ,ir           | HTTPClientDoRequest              |
|-----------|----------|--------------|-----------------------------------|
```

增强
- v  *           * :call VisualSelection()<CR>
- v  #           * :call VisualSelection()<CR>
- n  0           * ^
- n  Q           * <Nop>
- n  Y           * y$
-    j           * gj
-    k           * gk
- v  p           * <SNR>2_Repl()
- n  <BS>        * X
- fzf 相关的好多命令： Maps, Snippets, Commits, GFiles 等等


多窗口切换: CTRL-H/J/K/L


- Fold description {{{1 -


textobj:
[[ 反向小节，markdown 中跳转 header，编程语言中跳转 function
[[ 正向小节，markdown 中跳转 header，编程语言中跳转 function
```
)	N  )		向前 N 个句子
(	N  (		向后 N 个句子
}	N  }		向前 N 个段落
{	N  {		向后 N 个段落
]]	N  ]]		向前 N 个小节，置于小节的开始
[[	N  [[		向后 N 个小节，置于小节的开始
][	N  ][		向前 N 个小节，置于小节的末尾
[]	N  []		向后 N 个小节，置于小节的末尾
```

## 词典，拼写建议

- macOS / FreeBSD 下默认存在
- sudo yum install words
- sudo apt-get install wamerican

- spell

## runtimepath

~/.vim
~/.cache/nvim/bundle/vim-startify
/usr/local/opt/fzf
~/.cache/nvim/bundle/fzf.vim
~/.cache/nvim/bundle/molokai
~/.cache/nvim/bundle/vim-buftabline
~/.cache/nvim/bundle/nerdtree
~/.cache/nvim/bundle/nerdtree-git-plugin
~/.cache/nvim/bundle/vim-easy-align
~/.cache/nvim/bundle/ultisnips
~/.cache/nvim/bundle/vim-snippets
~/.cache/nvim/bundle/editorconfig-vim
~/.cache/nvim/bundle/tig-explorer.vim
~/.cache/nvim/bundle/vim-signify
~/.cache/nvim/bundle/vim-fugitive
~/.cache/nvim/bundle/coc.nvim
~/.cache/nvim/bundle/jsonc.vim
~/.cache/nvim/bundle/vim-markdown
~/.cache/nvim/bundle/vim-markdown-toc
~/.cache/nvim/bundle/plantuml-syntax
~/.cache/nvim/bundle/vim-toml
~/.cache/nvim/bundle/nginx.vim
~/.cache/nvim/bundle/vim-caddyfile
~/.cache/nvim/bundle/vim-javascript
~/.cache/nvim/bundle/typescript-vim
~/.cache/nvim/bundle/vim-jsx-typescript
~/.cache/nvim/bundle/vim-styled-components
~/.cache/nvim/bundle/vim-graphql
~/.cache/nvim/bundle/vimcdoc
~/.cache/nvim/bundle/vim-http-client
~/.cache/nvim/bundle/gotests-vim
~/.cache/nvim/bundle/vimux
~/.cache/nvim/bundle/nvim-treesitter
~/.cache/nvim/bundle/nvim-dap
~/.cache/nvim/bundle/nvim-dap-virtual-text
~/.cache/nvim/bundle/nvim-dap-ui
~/.config/nvim
/etc/xdg/nvim
~/.local/share/nvim/site
/usr/local/share/nvim/site
/usr/share/nvim/site
/usr/local/Cellar/neovim/0.6.1/share/nvim/runtime
/usr/local/Cellar/neovim/0.6.1/share/nvim/runtime/pack/dist/opt/matchit
/usr/local/Cellar/neovim/0.6.1/lib/nvim
/usr/share/nvim/site/after
/usr/local/share/nvim/site/after
~/.local/share/nvim/site/after
/etc/xdg/nvim/after
~/.config/nvim/after
~/.cache/nvim/bundle/nerdtree-git-plugin/after
~/.cache/nvim/bundle/ultisnips/after
~/.cache/nvim/bundle/vim-markdown/after
~/.cache/nvim/bundle/vim-javascript/after
~/.cache/nvim/bundle/vim-jsx-typescript/after
~/.cache/nvim/bundle/vim-styled-components/after
~/.cache/nvim/bundle/vim-graphql/after
~/.cache/nvim/bundle/nvim-treesitter/after
~/.vim/after

## 寄存器

"0p 将寄存器中 "0 对应的内容粘贴到当前位置
插入模式下 <CTRL-R> 列出寄存器内容，输入寄存器标记即可插入相应的内容

## 小技巧

### 选中小技巧

- 正常我们使用 gf 就打开光标下的文件路径，如果文件路径中包含特殊字符或空格，需要先选中，再使用 gf 打开文件路径。
- 再编辑 vim 文件时，使用 K 打开光标下内容的相关帮助文档，同样如果光标下包含特殊字符或空格，如 i_CTRL-R，需要先选中，再使用 K 开发帮助文档。

## 注意事项

### map

" :silent some_executable 静默执行，不显示执行过程中的输出内容
" :help map-arguments
" :help map-<silent> 静默执行键映射，不在命令行显示执行的内容
" :help map-<expr> 计算给定的表达式，将结果作为右值，
"     注意 <expr> 会检查光标之前的文本，有时光标位置会变动

" 使用 :autocmd BufNewFile *.go 查看已定的 event 响应

## treesitter

目前看还有很多问题，等 neovim 发布 1.0 版本可以尝试下
" 内置的 $VIMRUNTIME/lua/vim/treesitter
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


## 插件开发

" 这个插件对于使用三方语言开发 vim 插件是一个很好的例子
"Plug 'ueaner/vim-http-client'
" 显示中文原始文本 todo 请求时中文会提示 latin-1 Python 编码问题
let g:http_client_json_escape_utf = 0
let g:http_client_focus_output_window = 0

## vimL

" function 后面的感叹号则是避免引入相同函数名时报错
" E122: 函数 Foo 已存在，请加 ! 强制替换
"
" lsp 部分后期待官方成熟可以换为官方的 $VIMRUNTIME/lua/vim/lsp + github.com/neovim/nvim-lspconfig


### 变量作用域

:help variable-scope

## Vim 与 Tmux 使用系统剪切板

以下版本 macOS 下亲测可用，其他版本和桌面系统未测试，推荐使用最新版本：

1. vim 8.1.2100
2. tmux 2.9a (即便是远程运行的 tmux 复制的内容也可以到本地系统剪切板)

编辑 `~/.vim/vimrc.local` 文件，添加以下配置：

```vim
set clipboard^=unnamed
set clipboard^=unnamedplus
```

编辑 `~/.tmux.conf` 添加以下配置：

```tmux
# vim keybindings
setw -g mode-keys vi

bind Escape copy-mode

# vim copy selection
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle \; send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
```

重新打开 tmux 和 vim 即可。

点击查看详细 [.tmux.conf] 配置。

[vim-plug]: https://github.com/junegunn/vim-plug
[.tmux.conf]: https://github.com/ueaner/dotfiles/blob/master/.tmux.conf
[vimrc.local]: https://github.com/ueaner/vimrc/blob/master/support/vimrc.local
[readline shortcut]: https://github.com/chzyer/readline/blob/master/doc/shortcut.md

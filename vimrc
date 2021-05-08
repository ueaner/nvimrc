" {{{
"
" Author ueaner <ueaner#gmail.com>
"
" 目录结构:
" ~
" ├── .vim
" │   ├── README.md
" │   ├── after
" │   │   └── ftplugin       针对文件类型的配置
" │   ├── autoload
" │   │   └── plug.vim       vim-plug 插件管理工具
" │   ├── gvimrc             gvim/macvim 配置
" │   ├── support            支持性的脚本及文件
" │   ├── vimrc              主配置文件
" │   └── vimrc.local        自定义本地配置，会自动加载
" ├── .cache
" │   ├── vim-bundle         插件存储目录
" │   └── vim-undofile       undo 文件目录
" └── .config
"     ├── coc
"     │   ├── coc-settings.json
"     │   └── ...
"     └── nvim
"         └── init.vim
"
" }}}
" ==================== general options ==================== {{{

let mapleader = ','
let g:mapleader = ','

" truecolor
" echo $TERM_PROGRAM  Apple_Terminal  iTerm.app
if has('termguicolors') && $COLORTERM == 'truecolor'
    set termguicolors
endif

" vim 内部编码(buffer,菜单文本[gvim],消息文本等), :help ++enc
set encoding=utf-8
" utf-8 编码, 去除 BOM
if &modifiable | set fileencoding=utf-8 nobomb | endif
" 换行符格式, Line Endings, :help ++ff
set fileformats=unix,dos,mac
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
set updatetime=300
" 文件改变自动读入，就像协作一样
set autoread
autocmd FocusGained,BufEnter * checktime

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden
" 重用已打开的 buffer
set switchbuf=useopen
" 新窗口在下右方打开
set splitbelow splitright

" 垂直窗口分割字符, 和折叠填充字符
set fillchars=vert:\ ,fold:\ ,diff:-
" 显示状态栏，配合 statusline 使用
set laststatus=2
" 在屏幕右下角显示未完成的指令输入
set showcmd
" 显示当前模式
set showmode
" 显示行号
set number
" 光标滚动时始终保持在中间行, 属于非 H M L 和 zz zt zb 的另一种操作习惯
"let &scrolloff=&lines
" 光标滚动时屏幕上下保留 3 行
set scrolloff=3

" 括号匹配，依赖 $VIMRUNTIME/plugin/matchparen.vim
set showmatch
" 跳转到匹配括号的停留时间 0.3s
set matchtime=3
" 突出显示当前行
"set cursorline
" 行尾单词整体换行，不截断单词
set linebreak
" 滚屏时光标保持在同一列
set nostartofline
" FOOBAR=~/<CTRL-X><CTRL-F>
" file.c:10 光标在 file.c 上，按下 gF 将跳转到 file.c 文件且跳转到第 10 行
set isfname-==
set isfname-=:


" 1 个 TAB 占 4 个位置
set tabstop=4
set softtabstop=4
set shiftwidth=4
" 使用空格代替 tab
set expandtab
set smarttab
" 智能缩进
set autoindent smartindent
" 回退
set backspace=indent,eol,start

" 不自动折叠
set foldlevel=10
set foldmethod=indent
" 左侧添加一列, 指示折叠的打开和关闭
"silent! set foldcolumn=1
" Merge signcolumn with number line (if supported)
if has("patch-8.1.1564")
    set signcolumn=number
else
    set signcolumn=no
endif

" auto complete
" 自动完成的最大条数
set pumheight=10
" :help completeopt@en
"set complete=.,w,b,u,t
set complete-=i
set completeopt=longest,menuone,noinsert
" Suggestion: show info for completion candidates in a popup menu
if has("patch-8.1.1904")
    set completeopt+=popup
    set completepopup=align:menu,border:off,highlight:Pmenu
endif

" nvim 下命令行补全忽略文件名大小写
set wildignorecase
" 命令行列出所有的补全可能性, 配合 <C-N>, <C-P> 使用
if !has('nvim')
    set wildmode=longest,list
    " vim8.2 screen-256color 会丢失颜色
    set term=xterm-256color
endif

" 实时显示搜索结果
set incsearch
" 忽略大小写, 如果输入搜索模式下含有大写字母则不启用忽略大小写
set ignorecase smartcase
" 高亮搜索结果
set hlsearch

set shortmess+=c

" 去除提示音
set noerrorbells
" 关闭可视响铃和鸣叫
set visualbell t_vb=
" timeout
set notimeout
set ttimeout
set ttimeoutlen=10

" undo
if has('persistent_undo')
    set undofile
    set undolevels=400
    set undodir=$HOME/.cache/vim-undofile
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" 合并注释行时自动删除注释标志
silent! set formatoptions+=j

" 切换粘贴模式
set pastetoggle=<leader>z

" statusline
let &statusline=" %{HasPaste()} %<%f%m %#WarningMsg#%{StatusDiagnostic()}%* %= %{HasClipboard()} %{&filetype}  %{&fileformat} | %(%{(&fenc!=''?&fenc:&enc)} %) LN %4l/%-4.L COL %-3.c "

" }}}
" ==================== mappings ==================== {{{

vnoremap <silent> <expr> p <sid>Repl()

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection()<CR>
vnoremap <silent> # :call VisualSelection()<CR>

" 去除高亮
nnoremap <leader><space> :nohlsearch<CR>

" 搜索当前光标下的单词，但是不跳转下一个, :help gd
nnoremap <leader>k wb/\<<C-R><C-W>\>/e<CR>

" 使用空格关闭／打开折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>

" 对较长行自动换行时，可以作为多行上下移动
noremap j gj
noremap k gk

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" 最大化, 另一个调整窗口大小的命令 :resize
nnoremap + :only<CR>

" Save
inoremap <C-s>     <C-O>:update<CR>
nnoremap <C-s>     :update<CR>
nnoremap <leader>w :update<CR>

" 标签跳转：一个匹配，直接跳转；多个匹配，选择跳转。 :h g_CTRL-]
"nnoremap <C-]> g<C-]>

" Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" 插入模式下 Emacs 风格键映射
" 移动: 行首/行尾
inoremap <C-A> <Home>
inoremap <C-E> <ESC><S-A>
" 移动: 向左/右一个字符
inoremap <C-B> <Left>
inoremap <C-F> <Right>
" 删除光标前/后一个字符
" <C-H>  :h i_CTRL-H
inoremap <C-D> <Del>
" 删除光标前一个单词
" <C-W>  :h i_CTRL-W
" 删除光标前/后所有字符
" <C-U>  :h i_CTRL-U
inoremap <C-K> <C-O>D

" 命令行模式下 Emacs 风格键映射
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>

" 切换 buffer，也可映射为 gB/gb 类似 tab 的 gT/gt 操作
nnoremap <expr> <C-N> &buftype == "" ? ":bnext\<CR>" : ''
nnoremap <expr> <C-P> &buftype == "" ? ":bprev\<CR>" : ''
" 切换到上一个打开的 buffer, 同 CTRL-^
nnoremap <expr> <leader><leader> &buftype == "" ? ":e#\<CR>" : ''

" 关闭当前 buffer 或关闭 window
nnoremap <leader>q :call CloseSplitOrDeleteBuffer()<CR>

" 关闭除当前 buffer 以外的其他 buffers
nnoremap <leader>Q :call CloseOtherBuffers()<CR>

" :b <pattern> <TAB> 「如果匹配到多个，使用 <C-N>/<C-P> 选择」
nnoremap <leader>b :ls<CR>:b<space>

" 快速编辑当前加载的 vimrc 配置文件
nnoremap <leader>x :e $MYVIMRC<CR>

" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 去除尾部 ^M
nnoremap <leader>M :%s/\r/<CR>

" 有补全菜单进行补全，否则插入回车
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" 插入模式下重新映射 <TAB> 键到 InsertTabWrapper
inoremap <silent> <TAB> <C-R>=<SID>InsertTabWrapper()<CR>

" 保存无权限文件, :h E174
command! W w !sudo tee % > /dev/null

" toggle clipboard
nnoremap <silent> <expr> <leader>tc <sid>ClipboardToggle()

" }}}
" ==================== vimrc.local ==================== {{{

exec 'silent! source ' . expand('<sfile>:p:h') . '/vimrc.local'

" 为特定的文件类型载入相应的插件
filetype plugin indent on
" 打开语法高亮
syntax on

" }}}
" ==================== functions ==================== {{{

func HasPaste()
    if &paste
        return 'PASTE '
    endif
    return 'BUF #' . bufnr('%')
endfunc

func HasClipboard()
    if strridx(&clipboard, "unnamed") > -1
        return 'clipboard |'
    endif
    return ''
endfunc

func StatusDiagnostic() abort
    if !exists('g:did_coc_loaded')
        return
    endif

  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, '✖' . info['error'])
  endif
  "if get(info, 'warning', 0)
  "  call add(msgs, '⚠️' . info['warning'])
  "endif
  return join(msgs, ' ')
endfunc

" https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim#L295
" Make sure pasting in visual mode doesn't replace paste buffer
func RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunc
func s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunc

" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
func VisualSelection() range
    let l:saved_reg = @"
    exec "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

" http://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
func CloseSplitOrDeleteBuffer()
    let curNr = winnr()
    let curBuf = bufnr('%')
    wincmd w                    " try to move on next split
    if winnr() == curNr         " there is no split
        exec 'bdelete'
    elseif curBuf != bufnr('%') " there is split with another buffer
        wincmd W                " move back
        exec 'bdelete'
    else                        " there is split with same buffer
        wincmd W
        wincmd c
    endif
endfunc

" 关闭除当前 buffer 以外的其他 buffers
" nerdtree 和未保存的文件不会被关闭
func CloseOtherBuffers(...)
    let range = a:0 > 0 ? a:1 : 'other'
    " 获取 buffer number 列表，不包含未保存的 buffer
    let bufNums = filter(range(1, bufnr('$')), 'buflisted(v:val) && !getbufvar(v:val, "&modified")')
    let curBufNum = bufnr('%')
    for bufNum in bufNums
        if range ==# 'other'    " 关闭其他 buffer
            if bufNum != curBufNum
                exec 'bdelete ' . bufNum
            endif
        elseif range ==# 'left'  " 关闭左侧 buffer
            if bufNum < curBufNum
                exec 'bdelete ' . bufNum
            endif
        elseif range ==# 'right' " 关闭右侧 buffer
            if bufNum > curBufNum
                exec 'bdelete ' . bufNum
            endif
        endif
    endfor
endfunc

" 使用 tab 键自动补全或尝试自动补全: 补全 'complete' 选项的词
" :help i_CTRL-N and :help 'complete'
func s:InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<TAB>"
    elseif pumvisible()
        return "\<C-N>"
    else
        " 首次弹出补全菜单自动选中
        return "\<C-N>\<Down>"
    endif
endfunc

" Vim 使用系统剪切板开关
func s:ClipboardToggle()
    if strridx(&clipboard, "unnamed") > -1
        set clipboard-=unnamed
        set clipboard-=unnamedplus
    else
        set clipboard^=unnamed
        set clipboard^=unnamedplus
    endif
endfunc

" }}}

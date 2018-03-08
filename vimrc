" {{{
"
" Author ueaner <ueaner#gmail.com>
"
" 目录结构:
"
" .vim
" ├── after
" │   └── ftplugin           针对文件类型的配置
" ├── dict                   用户函数的自动完成
" │   └── php.dict
" ├── local
" │   ├── undodir
" │   ├── local.bundles.vim  本地插件配置，会自动加载
" │   └── local.vimrc        本地 vimrc 配置，会自动加载
" ├── support                一些支持性的脚本及文件
" ├── vimrc                  主配置文件
" └── gvimrc                 gvim/macvim 配置
"
" }}}
" ==================== GLOBAL ==================== {{{

" 关闭兼容模式
set nocompatible

set ttyfast
set lazyredraw

let mapleader = ','
let g:mapleader = ','

" }}}
" ==================== $VIMHOME ==================== {{{

if has('win32') || has('win64')
    let $VIMHOME = $HOME . "/vimfiles"
else
    " 对于 :! 命令, 默认使用 bash shell 环境
    set shell=bash
    " sudo -s, 使用 $SUDO_USER 的插件配置
    if exists('$SUDO_USER') && !has('mac')
        " 不处理当前用户 $HOME/.vim 下的插件配置
        set rtp-=$HOME/.vim
        set rtp-=$HOME/.vim/after

        let $VIMHOME = "/home/" . $SUDO_USER . "/.vim"
    else
        let $VIMHOME = $HOME . "/.vim"
    endif
endif

" }}}
" ==================== 加载本地插件管理配置文件 ==================== {{{

" 引入插件管理配置文件
if &loadplugins
    silent! source $VIMHOME/local/local.bundles.vim
endif

" 为特定的文件类型载入相应的插件
filetype plugin indent on

" }}}
" ==================== 外观 ==================== {{{

" 垂直窗口分割字符, 和折叠填充字符
set fillchars=vert:\ ,fold:-
" 光标滚动时始终保持在中间行, 属于非 H M L 和 zz zt zb 的另一种操作习惯
"let &scrolloff=&lines
" 光标滚动时屏幕上下保留 3 行
set scrolloff=3
" 显示状态栏
set laststatus=2
" 状态栏/右下角显示行号和列号
set ruler
" 显示命令字符
set showcmd
" 显示当前模式
set showmode
" 显示行号
set number
" 打开语法高亮
syntax on
" 准确的语法高亮和屏幕刷新速度的折衷
syntax sync minlines=256
" 文件高亮的最大列数, 超出此列数后续行不一定能正确高亮
set synmaxcol=200
" 括号匹配，依赖 $VIMRUNTIME/plugin/matchparen.vim
set showmatch
" 跳转到匹配括号的停留时间 0.3s
set matchtime=3
" 突出显示当前行
"set cursorline

" truecolor
if has('termguicolors')
    set termguicolors
endif

" }}}
" ==================== 命令行 ==================== {{{

" 命令行列出所有的补全可能性, 配合 <C-N>, <C-P> 使用
set wildmode=longest,list
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>

" }}}
" ==================== 缩进与折叠 ==================== {{{

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
silent! set foldlevel=10
" 左侧添加一列, 指示折叠的打开和关闭
"silent! set foldcolumn=1

" 使用空格关闭／打开折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>

" }}}
" ==================== 文件编码与备份 ==================== {{{

" vim 内部编码(buffer,菜单文本[gvim],消息文本等), :help ++enc
set encoding=utf-8
" utf-8 编码, 去除 BOM
set fileencoding=utf-8 nobomb
" 换行符格式, Line Endings, :help ++ff
set fileformats=unix,dos,mac
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
" 文件改变自动读入
set autoread

" }}}
" ==================== 搜索 ==================== {{{

" 实时显示搜索结果
set incsearch
" 忽略大小写, 如果输入搜索模式下含有大写字母则不启用忽略大小写
set ignorecase smartcase
" 高亮搜索结果
set hlsearch

" }}}
" ==================== 其他支持 ==================== {{{

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
    set undodir=$VIMHOME/local/undodir
    set undofile
    set undolevels=400
endif

" 合并注释行时自动删除注释标志
silent! set formatoptions+=j

" 切换粘贴模式
set pastetoggle=<leader>z

" https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim#L295
" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" @see https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim#L209
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>

function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" }}}
" ==================== 键映射 ==================== {{{

" 去除高亮
nnoremap <leader><space> :nohlsearch<CR>
" 搜索当前光标下的单词，但是不跳转下一个, :help gd
nnoremap <leader>k wb/\<<C-R><C-W>\>/e<CR>

" 对较长行自动换行时，可以作为多行上下移动
map j gj
map k gk

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" 保存无权限文件, :h E174
command! W w !sudo tee % > /dev/null

" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 去除尾部 ^M
nnoremap <leader>M :%s/\r/<CR>

" 快速插入日期
nnoremap <leader>d "=strftime("%Y-%m-%d %H:%M:%S")<CR>P
inoremap <leader>d <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" Window navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" 快速编辑当前加载的 vimrc 配置文件
nnoremap <leader>x :e $MYVIMRC<CR>

" 标签跳转：一个匹配，直接跳转；多个匹配，选择跳转。 :h g_CTRL-]
nnoremap <C-]> g<C-]>

" }}}
" ==================== 插入模式下 readline 命令行风格键映射 ==================== {{{

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

" }}}
" ==================== buffer 操作 ==================== {{{

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden
" 重用已打开的 buffer
set switchbuf=useopen
" 新窗口在下右方打开
set splitbelow splitright

" 切换 buffer, 也可以映射为 gb/gB 类似 tab 的 gt/gT 操作
nnoremap <expr> <TAB> &buftype == "" ? ":bn\<CR>" : ''
nnoremap <expr> <S-TAB> &buftype == "" ? ":bp\<CR>" : ''
" 切换到上一个打开的 buffer, 同 CTRL-^
nnoremap <expr> <leader><leader> &buftype == "" ? ":e#\<CR>" : ''

" http://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
function! CloseSplitOrDeleteBuffer()
    let curNr = winnr()
    let curBuf = bufnr('%')
    wincmd w                    " try to move on next split
    if winnr() == curNr         " there is no split
        exe 'bdelete'
    elseif curBuf != bufnr('%') " there is split with another buffer
        wincmd W                " move back
        exe 'bdelete'
    else                        " there is split with same buffer"
        wincmd W
        wincmd c
    endif
endfunction

" 关闭除当前 buffer 以外的其他 buffers
" nerdtree 和未保存的文件不会被关闭
function! CloseOtherBuffers(...)
    let range = a:0 > 0 ? a:1 : 'others'
    " 获取 buffer number 列表，不包含未保存的 buffer
    let bufNums = filter(range(1, bufnr('$')), 'buflisted(v:val) && !getbufvar(v:val, "&modified")')
    let curBufNum = bufnr('%')
    for bufNum in bufNums
        if range ==# 'others'    " 关闭其他 buffer
            if bufNum != curBufNum
                exe 'bdelete ' . bufNum
            endif
        elseif range ==# 'left'  " 关闭左侧 buffer
            if bufNum < curBufNum
                exe 'bdelete ' . bufNum
            endif
        elseif range ==# 'right' " 关闭右侧 buffer
            if bufNum > curBufNum
                exe 'bdelete ' . bufNum
            endif
        endif
    endfor
endfunction

" 关闭当前 buffer 或关闭 window
nnoremap <leader>q :call CloseSplitOrDeleteBuffer()<CR>

" 关闭除当前 buffer 以外的其他 buffers
nnoremap <leader>Q :call CloseOtherBuffers()<CR>

" 最大化, 另一个调整窗口大小的命令 :resize
nnoremap + :only<CR>

" :b <pattern> <TAB> 「如果匹配到多个，使用 <C-N>/<C-P> 选择」
nnoremap <leader>l :ls<CR>:b<space>

" }}}
" ==================== statusline ==================== {{{

function! HasPaste()
    if &paste
        return 'PASTE '
    endif
    return 'BUF #' . bufnr('%')
endfunction

if has('statusline')
    let &statusline=" %{HasPaste()} %<%F%m %= %( %{&filetype} %) %{&fileformat} | %(%{(&fenc!=''?&fenc:&enc)} %) LN %4l/%-4.L COL %-3.c "
endif

" }}}
" ==================== auto-complete ==================== {{{

" 自动完成的最大条数
set pumheight=10

" Better Completion, :help completeopt@en
set complete=.,w,b,u,t
set completeopt=longest,menuone

" 有补全菜单进行补全，否则插入回车
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" 在没有使用第三方补全插件的情况下，使用以下自定义的 tab 补全方法
if !mapcheck("<TAB>", "i")
    " 使用 tab 键自动补全或尝试自动补全: 补全 'complete' 选项的词
    " :help i_CTRL-N and :help 'complete'
    function! s:InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col-1] !~ '\k'
            return "\<TAB>"
        elseif pumvisible()
            return "\<C-N>"
        else
            " 首次弹出补全菜单自动选中
            return "\<C-N>\<Down>"
        endif
    endfunction

    " 重新映射 tab 键到 InsertTabWrapper 函数
    inoremap <silent> <TAB> <C-R>=<SID>InsertTabWrapper()<CR>
endif

" }}}
" ==================== 加载本地配置 ==================== {{{

silent! source $VIMHOME/local/local.vimrc

" }}}

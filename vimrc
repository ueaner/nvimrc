" {{{
"
" Author ueaner <ueaner#gmail.com>
"
" 目录结构:
"
" .vim
" ├── bundle/       第三方插件存储目录
" ├── bundles.vim   第三方插件配置文件
" ├── support/      一些支持性的脚本及文件
" ├── dict          用户函数的自动完成
" │   └── php.dict
" ├── runtime
" │   ├── undodir
" │   └── viewdir
" ├── vimrc         主配置文件, Vim 7.4 之前的版本请做 $HOME/.vimrc 的软链
" └── gvimrc        gvim/macvim 配置
"
" }}}
" ==================== GLOBAL ==================== {{{

" 关闭兼容模式, 尽量在靠前的位置
set nocompatible             " be iMproved, required

" ttyfast
set ttyfast
" lazyredraw
set lazyredraw

" leader
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
" ==================== 引入插件管理配置文件 ==================== {{{

" 引入插件管理配置文件
if &loadplugins
    silent! source $VIMHOME/bundles.vim
endif

" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required

" }}}
" ==================== 外观 ==================== {{{

"  垂直窗口分割字符, 和折叠填充字符
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
" tab 转为空格 :%ret! 4
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
    set undodir=$VIMHOME/runtime/undodir
    set undofile
    set undolevels=400
endif

" 记录视图的缓存目录
set viewdir=$VIMHOME/runtime/viewdir
set viewoptions=cursor,folds

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

" 保存无权限文件, :h E174
command! W w !sudo tee % > /dev/null

" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 去除尾部 ^M
nnoremap <leader>M :%s/\r/<CR>

" Window navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" 快速编辑当前加载的 vimrc 配置文件
nnoremap <leader>x :e $MYVIMRC<CR>

" }}}
" ==================== buffer 操作 ==================== {{{

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden
" 重用已打开的 buffer
set switchbuf=useopen

" :help <TAB>, :help keycodes 发现 <TAB> 和 CTRL-I 用了一样的 keycode
" 如果重新定义了 <TAB>, CTRL-I 也会跟着被重新定义. 为了解放 <TAB>
" 并且保证跳转表的操作是完整的，于是我们：
" 使用 C-P/C-N 接收跳转表的操作
nnoremap <C-P> <C-O>
nnoremap <C-N> <C-I>

" 切换 buffer, 也可以映射为 gb/gB 类似 tab 的 gt/gT 操作
nnoremap <expr> <TAB> &buftype == "" ? ":bn\<CR>" : ''
nnoremap <expr> <S-TAB> &buftype == "" ? ":bp\<CR>" : ''
" 切换到上一个打开的 buffer, 同 CTRL-^
" 对于 help 文件跳转点较多，C-P / C-N / K 组合应该更适合
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

" 关闭 buffer 或关闭 window
nnoremap <leader>q :call CloseSplitOrDeleteBuffer()<CR>

" 快速保存文件
nnoremap <leader>w :w!<CR>

" :b <pattern>
nnoremap <leader>l :ls<CR>:b<space>

" }}}
" ==================== Omni-complete ==================== {{{

" Enable omni completion. :help ins-completion, hotkey: <C-X><C-O>, <C-X><C-F>, <C-N>, <C-P>
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" Better Completion, :help completeopt@en
set complete=.,w,b,u,t
set completeopt=longest,menuone

" }}}
" ==================== filetypes ==================== {{{

augroup FTS
    autocmd!
    "autocmd! bufwritepost $VIMHOME/vimrc source %

    autocmd FileType vim,help setlocal keywordprg=:help
    " 折叠方式：foldmarker 标记
    autocmd FileType vim setlocal foldmethod=marker

    autocmd FileType text,markdown setlocal textwidth=78
augroup END

" }}}
" ==================== PHP ==================== {{{

augroup PHP
    autocmd!
    set rtp+=$VIMHOME/phpmanual
    "词典文件
    autocmd FileType php setlocal dictionary=$VIMHOME/dict/php.dict
    " @link http://www.laruence.com/2010/08/18/1718.html
    autocmd FileType php setlocal keywordprg=:help
    "nnoremap K :help <C-R><C-W><CR>
    " 折叠方式：缩进
    autocmd FileType php setlocal foldmethod=indent

    " 记录折叠视图，及最后一次关闭文件时的光标所在位置。:help :mkview
    au BufWinLeave *.php silent! mkview
    au BufWinEnter *.php silent! loadview

    let php_html_load = 0
    let php_sql_heredoc = 0
augroup END

" tags 在 Vim 工作目录下, <C-]> 跳转，<C-T> 跳回
" 有新的 tags 生成时，执行 :NeoCompleteBufferMakeCache 刷新自动补全缓存
command! CTags !ctags -f tags --languages=PHP --PHP-kinds=+cf -R

" }}}
" ==================== statusline ==================== {{{

function! HasPaste()
    if &paste
        return 'PASTE'
    endif
    return 'BUF #' . bufnr('%')
endfunction

if has('statusline')
    let &statusline=" %{HasPaste()} %<%F%m %= %( %{&filetype} %) %{&fileformat} | %(%{(&fenc!=''?&fenc:&enc)} %) LN %4l/%-4.L %03p%% COL %-3.c "
endif

" }}}
" ==================== 自定义tab补全 ==================== {{{

" 有补全菜单进行补全，否则插入回车
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

if !mapcheck("<TAB>", "i")

    " 扫描 'dictionary' 选项给出的文件
    autocmd FileType php setlocal complete-=k complete+=k

    " 使用 tab 键自动补全或尝试自动补全: 补全 'complete' 选项的词
    " :help i_CTRL-N and :help 'complete'
    function! s:InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col-1] !~ '\k'
            return "\<TAB>"
        elseif pumvisible()
            return "\<C-N>"
        else
            return "\<C-N>\<Down>" " 首次弹出补全菜单自动选中
        endif
    endfunction

    " 重新映射 tab 键到 InsertTabWrapper 函数
    inoremap <silent> <TAB> <C-R>=<SID>InsertTabWrapper()<CR>
endif

" }}}
" ==================== 加载本地配置 ==================== {{{

silent! source $VIMHOME/local/vimrc.local

" }}}

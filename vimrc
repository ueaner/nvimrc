" {{{
"
" Author ueaner <ueaner#gmail.com>
" less is more
"
" :help option-list   可用选项列表，或 :help options
" :help 'someoption'  查看具体某选项的帮助，加引号
" :echo &someoption   查看某选项的设定值，加地址符
" :echo g:option l:option s:option 全局变量、本地变量等的设定值, 不加地址符
"
" :help  查看简介及帮助目录(view doc/help.cnx)
" :only  使当前窗口成为屏幕上唯一的窗口。其它窗口都关闭。
" :h abando
" :h K
" :help quickref  快速参考指南
"
" vim --startuptime <logfile> <somefile>  测试 Vim 的加载速度
" :scriptnames 查看已载入的脚本文件列表
" vim -V 2>verbose 记录 Vim 的启动过程
" view ~/.vim/doc/starting.cnx
"
" 对于非当前用户使用此配置，在相应用户 ~/.bashrc 中加入:
" alias e='vim -u /home/<myusername>/.vim/vimrc --noplugin'
"
" 目录结构:
"
" .vim
" ├── bundles.vim   插件配置文件
" ├── bundle        第三方插件存储目录
" ├── dict          用户函数的自动完成
" │   └── php.dict
" ├── runtime
" │   ├── undodir
" │   └── viewdir
" ├── extend.vim    扩展功能
" └── vimrc         7.4之前的版本请在 HOME 目录下做 .vimrc 的软链
"
"
" }}}
" ==================== $VIMHOME ==================== {{{
if has('win32') || has('win64')
    let $VIMHOME = $HOME . "/vimfiles"
else
    " 对于 ! 和 :! 命令, 默认使用 bash shell 环境
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
" ==================== GLOBAL ==================== {{{

" ttyfast
set ttyfast
" lazyredraw
set lazyredraw
" 关闭兼容模式
set nocompatible             " be iMproved, required

" leader
let mapleader = ','
let g:mapleader = ','

" }}}
" ==================== 引入插件管理配置文件 ==================== {{{

" 引入插件管理配置文件
if &loadplugins
    silent! source $VIMHOME/bundles.vim
    silent! source $VIMHOME/extend.vim
endif

" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required

" }}}
" ==================== 外观 ==================== {{{

"  垂直窗口分割字符, 和折叠填充字符
set fillchars+=vert:\ ,fold:-
" 滚动时会使光标永远保持在中间行, 属于非 H M L 和 zz zt zb 的另一种操作习惯
let &scrolloff=&lines
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
" 括号匹配，依赖 matchparen.vim
set showmatch
if !exists("g:loaded_matchparen")
    silent! source $VIMRUNTIME/plugin/matchparen.vim
endif
" 跳转到匹配括号的停留时间 100ms
set matchtime=1
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

" 使用空格代替 tab, 启用此选项 listchars 中的 tab 参数会失效, 必需用插件代替
set expandtab
set smarttab
" 1 个 TAB 占 4 个位置
set tabstop=4
set shiftwidth=4
" tab 转为空格 :%ret! 4
" 智能缩进
set autoindent smartindent
" 回退
set backspace=indent,eol,start
" 不自动折叠
silent! set foldlevel=10
" 左侧添加一列, 指示折叠的打开和关闭
"silent! set foldcolumn=1

augroup FoldToggle
    autocmd!
    if exists("*FoldToggle")
        autocmd FileType php,vim nnoremap <leader>f :call FoldToggle()<CR>
    endif
augroup END

" 使用空格关闭／打开折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>

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
" 忽略大小写
set ignorecase
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
try
    set undodir=$VIMHOME/runtime/undodir
    set undofile
    set undolevels=400
catch
endtry

" 记录视图的缓存目录
set viewdir=$VIMHOME/runtime/viewdir
set viewoptions-=options

" 合并注释行时自动删除注释标志
set formatoptions+=j

" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
"set clipboard^=unnamed
"set clipboard^=unnamedplus

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
" 开启搜索当前光标下的单词，但是不跳转下一个, :help gd
nnoremap <leader><leader> *N

" 自动换行时，可以在一行内上下移动
map j gj
map k gk

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" 保存无权限文件, :h E174
command! W w !sudo tee % > /dev/null

" }}}
" ==================== buffer 操作 ==================== {{{

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden

" buffer 操作
nnoremap <TAB> :bn<CR>
nnoremap <leader><TAB> :bp<CR>
" 切换到上一个打开的 buffer, 同 CTRL-^
nnoremap <leader>g :e#<CR>
" :bl :blast  最后一个
" :bf :bfirst 第一个
" :bd :bdelete 关闭当前 buffer

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
" ==================== VIM ==================== {{{

augroup VIM
    autocmd!
    "autocmd! bufwritepost $VIMHOME/vimrc source %

    autocmd FileType vim setlocal keywordprg=:help
    " 折叠方式：foldmarker 标记
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}
" ==================== PHP ==================== {{{

augroup PHP
    autocmd!
    " setlocal 对于 rtp 不起作用?
    autocmd FileType php setlocal rtp+=$VIMHOME/phpmanual
    "词典文件
    autocmd FileType php setlocal dictionary=$VIMHOME/dict/php.dict
    " @link http://www.laruence.com/2010/08/18/1718.html
    autocmd FileType php setlocal keywordprg=:help
    " 折叠方式：缩进
    autocmd FileType php setlocal foldmethod=indent

    " 记录折叠视图，及最后一次关闭文件时的光标所在位置。:help :mkview
    au BufWinLeave *.php silent! mkview
    au BufWinEnter *.php silent! loadview
augroup END

" .tags 在 Vim 工作目录下, <C-]> 跳转，<C-t> 跳回
set tags+=.tags
" 有新的 tags 生成时，执行 :NeoCompleteBufferMakeCache 刷新自动补全缓存
command! CTags !ctags -f .tags --languages=PHP --PHP-kinds=+cf -R

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

if !mapcheck("<TAB>", "i")

    " 扫描 'dictionary' 选项给出的文件
    autocmd FileType php setlocal complete-=k complete+=k

    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        " For no inserting <CR> key.
        return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction

    " 使用 tab 键自动补全或尝试自动补全: 补全 'complete' 选项的词
    " :help i_CTRL-N and :help 'complete'
    function! InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col-1] !~ '\k'
            return "\<TAB>"
        else
            return "\<C-N>"
        endif
    endfunction

    " 重新映射 tab 键到 InsertTabWrapper 函数
    inoremap <TAB> <C-R>=InsertTabWrapper()<CR>
endif

" }}}
" ==================== 加载 buftabline ==================== {{{

"if &loadplugins == 0
    silent! source $VIMHOME/bundle/vim-buftabline/plugin/buftabline.vim
"endif

" }}}

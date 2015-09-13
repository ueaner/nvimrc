" {{{
"
" Author ueaner <ueaner at gmail.com>
"
" :help option-list   可用选项列表，或 :help options
" :help 'someoption'  查看具体某选项的帮助，加引号
" :echo &someoption   查看某选项在的设定值，加地址符
" :echo g:option l:option s:option 全局变量、本地变量等的设定值, 不加地址符
"
" :help  查看简介及帮助目录(view doc/help.cnx)
" :only	 使当前窗口成为屏幕上唯一的窗口。其它窗口都关闭。
" :h abando
" :h K
" :help quickref  快速参考指南
"
" vim --startuptime <logfile> <somefile>  测试 Vim 的加载速度
" 查看已载入的脚本文件列表 :scriptnames
" less is more
"
" }}}

" ttyfast
set ttyfast
" lazyredraw
set lazyredraw
" 关闭兼容模式
set nocompatible             " be iMproved, required
" 默认使用 bash shell, 用于 ! 和 :! 命令的外壳名
set shell=bash

" leader
let mapleader = ','
let g:mapleader = ','

" 引入插件管理配置文件
if has('win32')
    silent! source ~/vimfiles/bundles.vim
    set rtp+=~/vimfiles/phpmanual
else
    silent! source ~/.vim/bundles.vim
    set rtp+=~/.vim/phpmanual
    "autocmd! bufwritepost ~/.vim/vimrc source %
endif

" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required

function! ShellRCFile()
  return "~/." . strpart($SHELL, strridx($SHELL, "/") + 1) . "rc"
endfunction

" 快速编辑 vimrc 文件
command! Ev e ~/.vim/vimrc
" command! Ez e ~/.zshrc
command! Ez :execute "e " . ShellRCFile()
command! Et e ~/.tmux.conf

" ==================== filetype & autocmd ==================== {{{

au BufRead,BufNewFile *.{conf,cnf,ini} setf dosini
au BufRead,BufNewFile *.{twig,volt} set filetype=twig
" @link http://www.laruence.com/2010/08/18/1718.html
autocmd FileType vim,php set keywordprg="help"
" 折叠方式：缩进
autocmd FileType php,nginx set foldmethod=indent
" 折叠方式：foldmarker 标记
autocmd FileType vim set foldmethod=marker

" 记录折叠视图, 可以方便定位到上次打开的位置
" 开启视图会使部分vimrc配置不能及时生效, 如果需要调试配置，建议先关闭视图
set viewdir=~/.vim/runtime/view
au BufWinLeave vimrc,*.php silent! mkview
au BufWinEnter vimrc,*.php silent! loadview

let php_sql_query = 1

" }}}
" ==================== 外观 ==================== {{{

" 配色方案
if &t_Co == 256
  let g:rehash256 = 1
endif
silent! colorscheme molokai
"  垂直窗口分割字符, 和折叠填充字符
set fillchars+=vert:\ ,fold:-
" 屏幕上下保留 3 行(光标滚动过程中)
set scrolloff=3
" 显示状态栏
set laststatus=2
" 状态栏/右下角显示行号和列号
set ruler
" 显示命令字符
set showcmd
" 显示当前模式
set showmode

" 显示相对行号,当前行使用绝对行号
set number
"silent! set relativenumber
" 打开语法高亮
syntax on
" 准确的语法高亮和屏幕刷新速度的折衷
syntax sync minlines=256
" 文件高亮的最大列数, 超出此列数后续行不一定能正确高亮
set synmaxcol=200
" 括号匹配
set showmatch
" 跳转到匹配括号的停留时间 100ms
set matchtime=1
" 突出显示当前行
set cursorline

" }}}
" ==================== 命令行 ==================== {{{

" 命令行列出所有的补全可能性, 配合 <C-N>, <C-P> 使用
set wildmode=longest,list
" 命令行补全忽略
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.DS_Store

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

" 针对 class 文件的函数折叠 ,f 只显示函数名, 再次 ,f 显示函数全部内容
function! FoldToggle()
  "let &foldlevel = &foldlevel == 1 ? 10 : 1
  if &foldlevel == 10
    if &filetype == 'vim'
      silent! setlocal foldlevel=0
    else
      silent! setlocal foldlevel=1
    endif
  else
    silent! setlocal foldlevel=10
  endif
endfunction
autocmd FileType php,vim nnoremap <leader>f :call FoldToggle()<CR>

" 使用空格关闭／打开折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" }}}
" ==================== 文件编码与拼写 ==================== {{{

" vim 内部编码(buffer,菜单文本[gvim],消息文本等), :help ++enc
set encoding=utf-8
" 拼写检查，7.4+
if has('spell') && v:version >= 704 && has('patch092')
    " 中日韩字符不进行检查，7.4.092+，:help spell-cjk
    set spelllang=en_us,cjk
    " 10 条最佳拼写建议, 使用 z= 列出拼写建议
    set spellsuggest=best,10
    " markdown, php 类型文件自动进行拼写检查
    "autocmd FileType markdown,php set spell
    " 快捷键 ,s
    nnoremap <leader>s :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif
" utf-8 编码, 去除 BOM
set fileencoding=utf-8 nobomb
" 换行符格式, Line Endings, :help ++ff
set fileformats=unix,dos,mac
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
" 关闭时记住上次打开的文件信息
"set viminfo^=%
" .tags 在 Vim 工作目录下, <C-]> 跳转，<C-t> 跳回
set tags+=.tags
command! CTags !ctags -f .tags --languages=PHP --PHP-kinds=+cf -R

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

" 使用鼠标
if has('mouse')
    "set mouse=a
endif
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus
" 去除提示音
set noerrorbells
" 关闭可视响铃和鸣叫
set visualbell t_vb=
" timeout
set notimeout
set ttimeout
set ttimeoutlen=10

" 正则 magic
set magic

" undo
try
    set undodir=~/.vim/runtime/undodir
    set undofile
    set undolevels=400
catch
endtry

" 不显示欢迎页
" set shortmess+=I

" 默认使用中文帮助，默认优先获取 ~/.vim/doc 中的帮助
"set helplang=cn

" }}}
" ==================== 插入模式 readline 命令行风格键映射 ==================== {{{

" 移动: 行首/行尾
inoremap <C-A> <Home>
inoremap <C-E> <End>
" 移动: 向左/右一个字符
inoremap <C-B> <Left>
inoremap <C-F> <Right>
" 删除一个字符
" <C-H>  :h i_CTRL-H
inoremap <C-D> <Del>
" 删除光标前一个单词
" <C-W>  :h i_CTRL-U
" 删除光标前/后所有字符
" <C-U>  :h i_CTRL-U
inoremap <C-K> <C-O>D

" 直接进入可视模式
inoremap <C-V> <Esc>lv
" <C-o> 插入模式下进入 临时插入模式 可以执行一条命令后再次进入插入模式

" }}}
" ==================== 键映射 ==================== {{{

" 去除高亮
nnoremap <leader><space> :nohlsearch<CR>
" 开启搜索当前光标下的单词，但是不跳转下一个, :help gd
nnoremap <leader><leader> *N
" 输入模式下键入jj映射到<ESC>
imap jj <ESC>
" <C-c> = <ESC>

" 自动换行时，可以在一行内上下移动
map j gj
map k gk

" % 映射到 ;;
"nnoremap ;; %

" highlight last inserted text
nnoremap gV `[v`]

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 去除尾部 ^M
nnoremap <leader>M :%s/\r/<CR>
" 粘贴模式 ,p
nnoremap <leader>p :set paste<CR>p :set nopaste<CR>
" 快速插入日期
nnoremap <leader>d "=strftime("%Y-%m-%d %H:%M:%S")<CR>P
inoremap <leader>d <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" 编辑一个 table 文件时可以直接将一个 table 文件内容格式化
"map <leader>? :%!column -t
" align =, 但是 = 等号会被干掉?
":'<'>! column -ts=

" 格式化JSON命令
com! JSONFormat %!python -m json.tool

" }}}
" ==================== 文件保存/关闭/切换 ==================== {{{

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden

" 快速保存文件
nmap <leader>w :w!<CR>
" 保存无权限文件,:h E174
command! W w !sudo tee % > /dev/null

" buffer 操作
nnoremap <TAB> :bn<CR>
nnoremap <leader><TAB> :bp<CR>
nnoremap <leader>l :CtrlPBuffer<CR>
" 切换到上一个打开的 buffer, 同 CTRL-^
nnoremap <Leader>g :e#<CR>
" :bl :blast  最后一个
" :bf :bfirst 第一个

" http://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
function! CloseSplitOrDeleteBuffer()
  let curNr = winnr()
  let curBuf = bufnr('%')
  wincmd w                    " try to move on next split
  if winnr() == curNr         " there is no split
    exe 'bdelete'
  elseif curBuf != bufnr('%') " there is split with another buffer
    wincmd W                  " move back
    exe 'bdelete'
  else                        " there is split with same buffer"
    wincmd W
    wincmd c
  endif
endfunction
" 关闭 buffer 或关闭 window
nnoremap <leader>q :call CloseSplitOrDeleteBuffer()<CR>
nnoremap <leader>Q :qa<CR>

" 最大化
nnoremap + :on<CR>
" 关闭, 最小化 ,g 唤出刚关闭的 buffer
nnoremap - :call CloseSplitOrDeleteBuffer()<CR>

" Window navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" }}}
" ==================== Omni-complete ==================== {{{

" Enable omni completion. :help ins-completion hotkey: <C-X><C-O>, <C-X><C-F>, <C-N>, <C-P>
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP dictionary=~/.vim/phpmanual/php.dict
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone
" auto select
"set completeopt-=noinsert completeopt+=noselect
" :help preview-window
"set completeopt+=preview

" }}}

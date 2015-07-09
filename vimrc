"
" Author ueaner <ueaner at gmail.com>
"
" :help option-list   可用选项列表，或 :help options
" :help 'someoption'  查看具体某选项的帮助，加引号
" :echo &someoption   查看某选项在的设定值，加地址符
"
" :help  查看简介及帮助目录(view doc/help.cnx)
" :only	 使当前窗口成为屏幕上唯一的窗口。其它窗口都关闭。
" :h abando
" :h K
" :help quickref  快速参考指南
"
" vim --startuptime <logfile>  测试 Vim 的加载速度
" less is more
"

" ttyfast
set ttyfast
" lazyredraw
set lazyredraw
" 关闭兼容模式
set nocompatible             " be iMproved, required
" 默认使用 bash shell, 用于 ! 和 :! 命令的外壳名
set shell=bash

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

" 快速编辑 vimrc 文件
command! Vimrc e ~/.vim/vimrc

" leader
let mapleader = ','
let g:mapleader = ','

" ==================== 外观 ==================== {{{

" 颜色数目
set t_Co=256
" 背景透明
hi Normal ctermfg=252 ctermbg=none
" 配色方案
silent! colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
"  垂直窗口分割字符, 和折叠填充字符
set fillchars+=vert:\ ,fold:-
" 屏幕上下保留 3 行(光标滚动过程中)
set scrolloff=3
" 显示状态栏
set laststatus=2
" 动态显示标题
set title
" 状态栏/右下角显示行号和列号
set ruler
" 显示命令字符
set showcmd
" 显示当前模式
set showmode

" }}}
" ==================== 命令行补全 ==================== {{{

" 命令行列出所有的补全可能性
set wildmode=longest,list
" 命令行补全忽略
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.DS_Store

" }}}
" ==================== 编辑区外观 ==================== {{{

" 显示相对行号,当前行使用绝对行号
set number
silent! set relativenumber
" 打开语法高亮
syntax on
" 准确的语法高亮和屏幕刷新速度的折衷. v个别复杂文件显示不友好v
"syntax sync minlines=256
" 搜索语法文件的最大列数. ^暂时注释掉,如出现性能问题,再回头看^
"set synmaxcol=128
" 括号匹配
set showmatch
" 跳转到匹配括号的停留时间 100ms
set matchtime=1
" 突出显示当前行
set cursorline
" 突出显示当前列
"set cursorcolumn
" 设置行宽
"silent! set colorcolumn=78
" 不自动换行(超出窗口)
"set nowrap
" 显示空白字符
" set list
" 空白字符显示格式(:help listchars)
"set listchars=tab:▸\ ,trail:-
" tab 转为空格 :%ret! 4

" }}}
" ==================== 缩进和折叠 ==================== {{{

" 使用空格代替 tab, 启用此选项 listchars 中的 tab 参数会失效, 必需用插件代替
set expandtab
set smarttab
" 1 个 TAB 占 4 个位置
set tabstop=4
set shiftwidth=4
" 智能缩进
set autoindent smartindent
" 回退
set backspace=indent,eol,start
" 不自动折叠
silent! set foldlevel=100
" 左侧添加一列, 指示折叠的打开和关闭
silent! set foldcolumn=1

" }}}
" ==================== 文件 ==================== {{{

" vim 内部编码(buffer,菜单文本[gvim],消息文本等)
set encoding=utf-8
" 拼写检查，7.4+
if has('spell') && v:version >= 704 && has('patch092')
    " 中日韩字符不进行检查，7.4.092+，:help spell-cjk
    set spelllang=en_us,cjk
    " 10 条最佳拼写建议
    set spellsuggest=best,10
    " markdown, vim 类型文件自动进行拼写检查
    "autocmd FileType markdown,vim set spell
    " 快捷键 ,s
    nnoremap <leader>s :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif
" utf-8 编码, 去除 BOM
set fileencoding=utf-8 nobomb
" 换行符格式
set fileformats=unix,mac,dos
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
" 当前编辑文件被外部编译器修改过，自动加载
set autoread
" 自动保存切换标签前
set autowriteall
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
" 智能搜索
set smartcase
" 高亮搜索结果
set hlsearch

" }}}
" ==================== filetype & autocmd ==================== {{{

au BufRead,BufNewFile *etc/nginx/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile *.{conf,cnf,ini} setf dosini
autocmd BufNewFile,Bufread *.{inc,php} setf php
" markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{twig,volt} set filetype=twig
" @link http://www.laruence.com/2010/08/18/1718.html
autocmd FileType vim,php set keywordprg="help"
" 折叠方式：缩进
autocmd FileType php,nginx set foldmethod=indent
" 折叠方式：foldmarker 标记
autocmd FileType vim set foldmethod=marker

" }}}
" ==================== 其他支持 ==================== {{{

" 使用鼠标
if has('mouse')
    set mouse=a
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
" 选择缺省正则表达式引擎, :help new-regexp-engine
if exists('&regexpengine')
    set regexpengine=1
endif

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
" 开启搜索当前光标下的单词，但是不跳转下一个
nnoremap <leader><leader> *N
" 输入模式下键入jj映射到<ESC>
imap jj <ESC>
" <C-c> = <ESC>

" undo & redo
" noremal 模式下: u & <C-R>
" 使用空格关闭／打开折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" 插入空行
nnoremap <leader>o o<Esc>
" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 去除尾部 ^M
nnoremap <leader>M :%s/\r/<CR>
" 粘贴模式 ,p
nnoremap <leader>p :set paste<CR>p :set nopaste<CR>

" 快速保存文件
nmap <leader>w :w!<CR>
" 保存无权限文件,:h E174
command! W w !sudo tee % > /dev/null

" buffer 操作
nnoremap <TAB> :bnext<CR>
nnoremap <leader><TAB> :bprevious<CR>
nnoremap <leader>l :ls<CR>
" 多插件抢这个快捷键
"nnoremap <Leader>f :bp<CR>
"nnoremap <Leader>b :bn<CR>
" 切换到上一个打开的 buffer
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

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

" 格式化JSON命令
com! JSONFormat %!python -m json.tool

"}}}
" ==================== Omni-complete ==================== {{{

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone
" :help preview-window
"set completeopt+=preview

"}}}
" ==================== netrw-browse ==================== {{{

" ,e 打开目录浏览，回车打开文件或目录
nnoremap <leader>e :Explore<CR>
" 打开文件关闭 Explore
let g:netrw_browse_split = 0
" 不显示横幅
let g:netrw_banner = 0
" 树形浏览
let g:netrw_liststyle = 3
" 隐藏 . 开头的文件
let g:netrw_list_hide = '^\..*'
" 目录在前文件在后
let g:netrw_sort_sequence = '[\/]$,*'

"}}}

" 引入相关插件配置, 放在 plugin 目录下会被自动加载

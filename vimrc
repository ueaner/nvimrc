"
" Author ueaner <ueaner at gmail.com>
"
" 查看某个配置选项的值或默认值，使用 :echo &<option>
" 如 :echo &fileencoding 可查看文件编码
" 输入 :help vimrc-intro 查看一些基本配置和目录结构信息
" :help user-manual ...
" :help options 查看所有可选配置, 使用 :help 'someoption' 加引号,查看具体某项的帮助
" vim --startuptime <logfile> 测试配置修改后的加载速度

" ttyfast
set ttyfast
" lazyredraw
set lazyredraw
" 关闭兼容模式
set nocompatible             " be iMproved, required

" 引入插件管理配置文件
silent! source ~/.vim/bundles.vim

" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required

" leader
let mapleader = ','
let g:mapleader = ','

" phpmanual
set rtp+=~/.vim/phpmanual

" ==================== 外观 ==================== {{{

" 颜色数目
set t_Co=256
" 配色方案
let g:molokai_original = 1
let g:rehash256 = 1
silent! colorscheme molokai
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
" 显示命令行栏
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
" 准确的语法高亮和屏幕刷新速度的折衷
syntax sync minlines=256
" 搜索语法文件的最大列数
set synmaxcol=128
" 括号匹配
set showmatch
" 跳转到匹配括号的停留时间 100ms
set matchtime=1
" 突出显示当前行
"set cursorline
" 设置行宽
"silent! set colorcolumn=78
" 不自动换行(超出窗口)
"set nowrap
" 显示空白字符
" set list
" 空白字符显示格式(:help listchars)
"set listchars=tab:▸\ ,trail:-

" }}}
" ==================== 缩进和折叠 ==================== {{{

" 使用空格代替 tab
set expandtab
set smarttab
" 1 个 TAB 占 4 个位置
set tabstop=4
set shiftwidth=4
" 智能缩进
set autoindent smartindent
" 回退
set backspace=indent,eol,start
" 不自动折叠(zR 展开所有折叠, zM 关闭所有折叠, zA 循环展开或关闭当前光标下的所有折叠)
silent! set foldlevel=100

" }}}
" ==================== 文件 ==================== {{{

" vim 内部编码(buffer,菜单文本[gvim],消息文本等)
set encoding=utf-8
" 拼写检查，7.4+
if has('spell')
	" 中日韩字符不进行检查，7.4.092+，:help spell-cjk
	set spelllang=en_us,cjk
	" 10 条最佳拼写建议
	set spellsuggest=best,10
	" markdown, vim 类型文件自动进行拼写检查
	autocmd FileType markdown,vim set spell
	" 快捷键 ,s
	nnoremap <leader>s :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif
" 当前编辑的文件的编码
set fileencoding=utf-8
" 换行符格式
set fileformats=unix,mac,dos
" 去除 utf-8 BOM
set nobomb
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
" 当前编辑文件被外部编译器修改过，自动加载
set autoread
" 自动保存切换标签前
set autowrite
" 关闭时记住上次打开的文件信息
"set viminfo^=%

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

au BufRead,BufNewFile */nginx*/etc/*,*/nginx*/etc/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */nginx*/*,*/nginx*/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */php-fpm.conf,*/my.cnf*,*.ini* setf dosini
autocmd BufNewFile,Bufread *.{inc,php} setf php
" markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
" @link http://www.laruence.com/2010/08/18/1718.html
autocmd FileType php set fdm=indent keywordprg="help"
" 使用  foldmarker 标记,作为折叠的开始和结束标记
autocmd FileType vim set noet ts=2 sw=2 sts=2 fdm=marker keywordprg="help"

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
" 使用 可视响铃代替鸣叫
set novisualbell t_vb=
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
set shortmess+=I

" 默认使用中文帮助，默认优先获取 ~/.vim/doc 中的帮助
"set helplang=cn

" }}}
" ==================== 键映射 ==================== {{{

" 去除高亮
nnoremap <leader><space> :nohlsearch<CR>
" 开启搜索当前光标下的单词，但是不跳转下一个
nnoremap <leader>f *N
" 输入模式下键入jj映射到<ESC>
imap jj <ESC>

" 插入模式行内移动操作：使用 readline 命令行风格
inoremap <C-B> <Left>
inoremap <C-F> <Right>
inoremap <C-A> <Home>
inoremap <C-E> <End>
" <C-W> 删除前一个单词

" undo & redo
" noremal 模式下: u & <C-R>
" 跳转至屏幕中间
nnoremap <space> zz

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" 插入空行
nnoremap <leader>o o<Esc>
" 去除尾部空字符
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>
" 粘贴模式 ,p
nnoremap <leader>p :set paste<CR>p :set nopaste<CR>

" 快速保存文件
nmap <leader>w :w!<CR>
" 保存无权限文件
command W w !sudo tee % > /dev/null

" buffer 操作
nnoremap <TAB> :bnext<CR>
nnoremap <leader><TAB> :bprevious<CR>
nnoremap <leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
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

" 格式化JSON命令
com! JSONFormat %!python -m json.tool

" 设置 gvim/macvim 字体
if has("gui_running")
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
endif

" 引入相关插件配置, 放在 plugin 目录下会被自动加载

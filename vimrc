"
" Author ueaner <ueaner at gmail.com>
"

" 目录：
" 界面主题
" 插件管理
" 文件备份
" buffers & windows
" 文本和缩进
" 状态条
" 键映射
" 杂项
" 辅助函数
"
" 查看某个配置选项的值或默认值，使用 :echo &<option>
" 如 :echo &fileencoding 可查看文件编码

" ttyfast
set ttyfast

" 自动加载 .vimrc 文件
au BufWritePost .vimrc so ~/.vim/vimrc

" 引入插件管理配置文件
source ~/.vim/bundles.vim

" ############# 颜色主题 #############
" 颜色数目
set t_Co=256
" 配色方案
colorscheme molokai

" leader
let mapleader = ','
let g:mapleader = ','

" ############# 文件/编码/备份 #############
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
" 编辑的文件的编码
set fileencoding=utf-8
" 去除 utf-8 BOM
set nobomb
" 为特定的文件类型载入相应的插件, 已在 bundles.php 中开启
"filetype plugin on
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowb
set noswapfile
" 关闭时记住上次打开的文件信息
"set viminfo^=%
" 当前编辑文件被外部编译器修改过，自动加载
set autoread
" 自动保存切换标签前
set autowrite

set fileformats=unix,mac,dos

" ############# 文本和缩进 #############
" 窗口分割字符
set fillchars+=vert:\ " 最后边是一个空格
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
set showmode
" 命令行列出所有的补全可能性(不进行补全)
"set wildmode=list:longest
set wildmode=list:full
" 命令行补全忽略
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.DS_Store

" 设置行宽
"set cc=78

" 显示行号
set nu
" 显示相对行号(relativenumber)
set rnu
" 突出显示当前行
"set cursorline
" 显示匹配括号
set magic
set lazyredraw
" 不自动换行(超出窗口)
" set nowrap
" 显示空白字符
" set list
" 空白字符显示格式(:help listchars)
"set listchars=tab:▸\ ,trail:-
" 使用空格代替 tab
set expandtab
set smarttab
" 1 个 TAB 占 4 个位置
set tabstop=4
set shiftwidth=4
" 回退
set backspace=indent,eol,start
" 自动缩进
set autoindent
" 智能缩进
set smartindent
" 使用 C 语言风格缩进
"set cindent
" 打开语法高亮
syntax on
" 代码折叠
set foldmethod=indent
" 不自动折叠(zR 展开所有折叠航, l 可展开当前光标下的折叠)
set foldlevel=100
" 使用鼠标
set mouse=a
" timeout
set notimeout
set ttimeout
set ttimeoutlen=10

" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

syntax sync minlines=256
set synmaxcol=128
set re=1

" ############# 搜索/帮助 #############
" 实时显示搜索结果
set incsearch
" 忽略大小写
set ignorecase
" 智能搜索
set smartcase
" 高亮搜索结果
set hlsearch
" 搜索结果结束显示指示灯闪烁
set showmatch
" 倒数第二个开始闪烁
set mat=2

" 去除提示音
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" 默认使用中文帮助，默认优先获取 ~/.vim/doc 中的帮助
"set helplang=cn

" ==================== 键映射 ====================
" 去除高亮
nnoremap <leader><space> :nohlsearch<CR>
" 开启搜索当前光标下的单词，但是不跳转下一个
nnoremap <leader>f *N
" 输入模式下键入jj映射到<ESC>
imap jj <ESC>

" 插入模式上下行移动操作
inoremap <C-J> <Down>   " 向下一行
inoremap <C-K> <Up>     " 向上一行
" 插入模式行内移动操作：使用 readline 命令行风格
inoremap <C-B> <Left>   " 向左一个字符
inoremap <C-F> <Right>  " 向右一个字符
inoremap <C-A> <Home>   " 行首
inoremap <C-E> <End>    " 行尾
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

" buffer 操作
nnoremap <TAB> :bnext<CR>
nnoremap <leader><TAB> :bprevious<CR>
nnoremap <leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR> " 切换到上一个打开的 buffer
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
" 快速保存文件
nmap <leader>w :w!<CR>

" 格式化JSON命令
com! JSONFormat %!python -m json.tool

" 设置 gvim/macvim 字体
if has("gui_running")
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
endif

" 引入相关插件配置
" 插件配置文件现放在名为 plugin 的文件夹下可被自动加载，不再另作引入操作
"source ~/.vim/vim_plugin_config.vim
" source ~/.vim/filetype.vim " 自动加载

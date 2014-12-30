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

" 关闭兼容模式(nocompatible)
set nocompatible              " be iMproved, required
" ttyfast
set ttyfast
" 自动加载 .vimrc 文件
au BufWritePost .vimrc so ~/.vimrc

" -------------- 插件管理开始 --------------------
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" 主题
"Plugin 'tomasr/molokai'
Plugin 'fatih/molokai'
"Plugin 'zenorocha/dracula-theme'
" 状态条 & buffers tabline & tagbar & ctrlp ...
Plugin 'bling/vim-airline'
" 目录管理
"Plugin 'scrooloose/nerdtree'

" 快捷查找
Plugin 'kien/ctrlp.vim'
" 自动完成
Plugin 'shougo/neocomplete.vim'
" 括号匹配
Plugin 'tpope/vim-surround'
" sign
Plugin 'mhinz/vim-signify'
" mothon: as a minimalist [Lokaltog/vim-easymotion]
Plugin 'justinmk/vim-sneak'
" grep
Plugin 'easygrep'
" snippets
Bundle 'Shougo/neosnippet'
Bundle 'Shougo/neosnippet-snippets'
" marks, 高亮 mark
Plugin 'zhisheng/visualmark.vim'
" marks, 快捷键帮助:help showmarks-mappings
"Plugin 'juanpabloaj/ShowMarks'

" 语法检查
Plugin 'scrooloose/syntastic'
" tags outline
Plugin 'majutsushi/tagbar'
" php tags
"Plugin 'vim-php/tagbar-phpctags.vim'
" PHP 5.3+ 语法
Plugin 'stanangeloff/php.vim'
" 对齐线
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdcommenter'
" markdown
Plugin 'tpope/vim-markdown'
" emmet, html & css
Plugin 'mattn/emmet-vim'
" json
Plugin 'elzr/vim-json'
" twig
Plugin 'evidens/vim-twig'
" 16 进制高亮
"Plugin 'hexHighlight.vim'
" 添加注释
"Plugin 'DoxygenToolkit.vim'
" css color 加载太慢
"Plugin 'skammer/vim-css-color'

" git mirror, 需要 python 支持
Plugin 'sjl/gundo.vim'
" git
Plugin 'tpope/vim-fugitive'
" git 使用 NERDTree 时此插件无法使用，应该多练习下 ctrlp 的使用
"Plugin 'airblade/vim-gitgutter'

" 从浏览器打开链接
Plugin 'tyru/open-browser.vim'
" 画图
"Plugin 'drawit'

" nginx
Plugin 'evanmiller/nginx-vim-syntax'

call vundle#end()            " required
" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required
" -------------- 插件管理结束 --------------------

" ############# 颜色主题 #############
" 颜色数目
set t_Co=256
" 配色方案
colorscheme molokai

" ############# 文件/编码/备份 #############
" vim 内部编码(buffer,菜单文本[gvim],消息文本等)
set encoding=utf-8
" 编辑的文件的编码
set fileencoding=utf-8
" 去除 utf-8 BOM
set nobomb
" 为特定的文件类型载入相应的插件
"filetype plugin on
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowb
set noswapfile
" 关闭时记住上次打开的文件信息
set viminfo^=%
" 当前编辑文件被外部编译器修改过，自动加载
set autoread

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
" 命令行列出所有的补全可能性(不进行补全)
set wildmode=list:longest
" 设置行宽
"set cc=78

" 显示行号
set nu
" 显示相对行号(relativenumber)
set rnu
" 突出显示当前行
set cursorline
" 不自动折叠(zR 展开所有折叠航)
set foldlevel=100
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
" set smartindent
" 使用 C 语言风格缩进
"set cindent
" 打开语法高亮
syntax on
" 代码折叠
set foldmethod=indent
set foldlevel=99
" 使用鼠标
"set mouse=a
" timeout
set ttimeoutlen=50

" ############# 搜索/帮助 #############
" 实时显示搜索结果
" set incsearch
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

" 默认使用中文帮助
"set helplang=cn

" ############# 键映射 #############
" 开启 ALT 键映射(默认调用菜单) #不好使
" set winaltkeys=no
" leader
let mapleader = ','
" 输入模式下键入jj映射到<ESC>
inoremap jj <Esc>
" 插入模式 hjkl 移动, 左右键与 neocomplete 冲突, " 删除下面 neocomplete 的 <C-h> 和 <C-l> 键映射
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-B> <Left>
inoremap <C-F> <Right>
inoremap <C-A> <Home>
inoremap <C-E> <End>
" <C-W> 删除前一个单词

" undo & redo
" noremal 模式下: u & <C-R>

" 插入空行
nnoremap <leader>a o<Esc>
" 去除尾部空字符
"nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>W :%s/\s\+$//<CR> :w!<CR>
" 将 4 个空格转换为一个 TAB
"nnoremap <leader>T :%s/    /\t/g<CR>
" 更改窗口大小
nnoremap <C-H> :vertical resize -1<CR>
nnoremap <C-J> :resize -1<CR>
nnoremap <C-K> :resize +1<CR>
nnoremap <C-L> :vertical resize +1<CR>
" 切换窗口
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
" 切换buffers
nnoremap <TAB> :bnext<CR>

" 设置 gvim/macvim 字体
if has("gui_running")
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
endif

" 引入相关插件配置
" 插件配置文件现放在名为 plugin 的文件夹下可被自动加载，不再另作引入操作
"source ~/.vim/vim_plugin_config.vim
" source ~/.vim/filetype.vim " 自动加载

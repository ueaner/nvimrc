filetype off                  " required

if has('win32')
    " @link https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows
    set rtp+=~/vimfiles/bundle/Vundle.vim
    let path='~/vimfiles/bundle'
    call vundle#begin(path)
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'

" 主题
Plugin 'fatih/molokai'
" status/tabline
Plugin 'bling/vim-airline'
" 选择窗口
Plugin 't9md/vim-choosewin'
" marks, 快捷键帮助:help showmarks-mappings
Plugin 'juanpabloaj/ShowMarks'

" git, airline 上会默认显示分支，变更行数等信息
Plugin 'tpope/vim-fugitive'
" git, 文件 diff 状态
Plugin 'airblade/vim-gitgutter'

if has('lua')
    " 自动完成
    Plugin 'shougo/neocomplete.vim'
    " snippets
    Plugin 'Shougo/neosnippet'
    " 提供了各语言的 snippets, 可以按自己的需要修改
    Plugin 'Shougo/neosnippet-snippets'
endif

" 文件快捷查找
Plugin 'kien/ctrlp.vim'
" 目录管理, 加载时间稍长
"Plugin 'scrooloose/nerdtree'

" 更改括号
Plugin 'tpope/vim-surround'

" 语法高亮
" nginx
Plugin 'evanmiller/nginx-vim-syntax'
" markdown
Plugin 'tpope/vim-markdown'

" -------------------------------------------------- "
" 注释
Plugin 'tomtom/tcomment_vim'
"Plugin 'scrooloose/nerdcommenter'
"Plugin 'DoxygenToolkit.vim'

" mothon: as a minimalist [Lokaltog/vim-easymotion]
"Plugin 'justinmk/vim-sneak'
" grep, 加载时间稍长
"Plugin 'easygrep'

" 语法检查, 加载时间稍长
"Plugin 'scrooloose/syntastic'
" tags outline
"Plugin 'majutsushi/tagbar'
" php tags
"Plugin 'vim-php/tagbar-phpctags.vim'
" 对齐
"Plugin 'godlygeek/tabular'
" emmet, html & css
"Plugin 'mattn/emmet-vim'
" json
"Plugin 'elzr/vim-json'
" twig
"Plugin 'evidens/vim-twig'
" 16 进制高亮
"Plugin 'hexHighlight.vim'
" 添加注释
" css color 加载太慢
"Plugin 'skammer/vim-css-color'

" 画图
"Plugin 'drawit'

" ini
"Plugin 'matze/vim-ini-fold'

"Plugin 'Yggdroot/indentLine'

" ---------------- 试用插件 -----------------
if has('python')
    " dbgp debugger
    "Plugin 'joonty/vdebug'
    "Plugin 'brookhong/DBGPavim'
endif

call vundle#end()            " required

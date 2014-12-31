" 关闭兼容模式(nocompatible)
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" 主题
Plugin 'fatih/molokai'
" 状态条 & buffers tabline & tagbar & ctrlp ...
Plugin 'bling/vim-airline'
" 目录管理
Plugin 'scrooloose/nerdtree'
" 选择窗口
Plugin 't9md/vim-choosewin'

" 快捷查找
Plugin 'kien/ctrlp.vim'
" 自动完成
Plugin 'shougo/neocomplete.vim'
" 括号匹配
Plugin 'tpope/vim-surround'
" mothon: as a minimalist [Lokaltog/vim-easymotion]
Plugin 'justinmk/vim-sneak'
" grep
Plugin 'easygrep'
" snippets
Bundle 'Shougo/neosnippet'
" 提供了各语言的 snippets, 可以按自己的需要修改
Bundle 'Shougo/neosnippet-snippets'

" marks, 快捷键帮助:help showmarks-mappings
Plugin 'juanpabloaj/ShowMarks'

" 语法检查
Plugin 'scrooloose/syntastic'
" tags outline
Plugin 'majutsushi/tagbar'
" php tags
"Plugin 'vim-php/tagbar-phpctags.vim'
" 注释
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

" git
"Plugin 'tpope/vim-fugitive'
" git 使用 NERDTree 时此插件无法使用，应该多练习下 ctrlp 的使用
Plugin 'airblade/vim-gitgutter'

" 画图
"Plugin 'drawit'

" nginx
Plugin 'evanmiller/nginx-vim-syntax'

call vundle#end()            " required
" 为特定的文件类型载入相应的插件
filetype plugin indent on    " required


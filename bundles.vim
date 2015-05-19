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
" statusline/tabline
Plugin 'bling/vim-airline'
" 选择窗口
Plugin 't9md/vim-choosewin'
" marks, 快捷键帮助:help showmarks-mappings
Plugin 'juanpabloaj/ShowMarks'

" git, 封装
"Plugin 'tpope/vim-fugitive'
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

" 文件快捷查找: files, buffer, tag
Plugin 'kien/ctrlp.vim'

" 多点编辑
Bundle 'terryma/vim-multiple-cursors'

" 目录管理, 加载时间稍长
Plugin 'scrooloose/nerdtree'
" tags outline
Plugin 'majutsushi/tagbar'
" 语法检查
"Plugin 'scrooloose/syntastic'

" 注释
Plugin 'tomtom/tcomment_vim'
" 更改括号
Plugin 'tpope/vim-surround'
" motion
Plugin 'justinmk/vim-sneak'

" yii2
"Plugin 'mikehaertl/yii2-apidoc-vim'
" php namespace
"Bundle 'arnaud-lb/vim-php-namespace'

Bundle 'mattn/emmet-vim'

if has('python')
    " dbgp debugger
    "Plugin 'joonty/vdebug'
endif

call vundle#end()            " required

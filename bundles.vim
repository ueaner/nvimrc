filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

if has('lua')
    " 自动完成
    Plugin 'shougo/neocomplete.vim'
endif

" 主题
Plugin 'ueaner/molokai'

" marks, 快捷键帮助:help showmarks-mappings
Plugin 'juanpabloaj/ShowMarks'

" git, 文件 diff 状态
Plugin 'airblade/vim-gitgutter'

" 文件快捷查找: files, buffers, mru
Plugin 'ctrlpvim/ctrlp.vim'

" 文件浏览
Plugin 'scrooloose/nerdtree'

" buffer tabs
Plugin 'ap/vim-buftabline'

" 多点编辑, 也可以使用 *cw<要替换的内容><ESC>, n.n.n.
" 参见：http://federicoramirez.name/why-vim-is-awesome/
Plugin 'terryma/vim-multiple-cursors'
" 对齐
Plugin 'junegunn/vim-easy-align'
" 自动关闭括号
Plugin 'cohama/lexima.vim'
" motion
"Plugin 'justinmk/vim-sneak'

if has('python')
    " dbgp debugger, 默认端口 9000.
    Plugin 'joonty/vdebug'
endif

call vundle#end()            " required

silent! source ~/.vim/bundles_config.vim

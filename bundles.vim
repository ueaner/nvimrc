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
Plugin 'kien/ctrlp.vim'

" 多点编辑
Plugin 'terryma/vim-multiple-cursors'
" 文件浏览
Plugin 'scrooloose/nerdtree'
" 对齐
Plugin 'junegunn/vim-easy-align'
" 自动关闭括号
Plugin 'cohama/lexima.vim'
" motion
"Plugin 'justinmk/vim-sneak'

if has('python')
    " dbgp debugger
    "Plugin 'joonty/vdebug'
endif

call vundle#end()            " required

silent! source ~/.vim/bundles_config.vim

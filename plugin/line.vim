" ==================== airline ====================
" 查看 airline 的可用主题：~/.vim/bundle/vim-airline/autoload/airline/themes/
"let g:airline_theme='powerlineish'
let g:airline_theme='jellybeans'
" tabline 启动时会将文件列表在顶栏显示，干的漂亮
let g:airline#extensions#tabline#enabled = 1
" show buffer number, 方便切换
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s: '
" tagbar
let g:airline#extensions#tagbar#enabled = 0
" ctrlp
let g:airline#extensions#ctrlp#show_adjacent_modes = 1

" whitespace: [ 'indent', 'trailing' ]
let g:airline#extensions#whitespace#enabled = 0
"let g:airline#extensions#whitespace#checks  = [ 'trailing' ]

" font
let g:airline_powerline_fonts = 1

" 指定 airline 的显示信息
"let g:airline_section_*

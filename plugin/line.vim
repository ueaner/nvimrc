" ############# airline #############
" 查看 airline 的可用主题：~/.vim/bundle/vim-airline/autoload/airline/themes/
"let g:airline_theme='jellybeans'
let g:airline_theme='powerlineish'
"let g:airline_theme='dark'
" tabline 启动时会将文件列表在顶栏显示，干的漂亮
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tab_nr = 1 " show tab number
" tagbar
let g:airline#extensions#tagbar#enabled = 1
" ctrlp
let g:airline#extensions#ctrlp#show_adjacent_modes = 1

let g:airline#extensions#branch#enabled = 1

" font
let g:airline_powerline_fonts = 1

" unicode symbols: let g:airline_symbols 配置
" sections
"let g:airline_section_z='%{g:airline_externals_fugitive}
"%{tagbar#currenttag('[%s] ','')}
"%{fugitive#statusline()}



" ==================== tagbar ====================
"nnoremap <leader>t :TagbarToggle<CR>
"let g:tagbar_width = 30
let g:tagbar_show_linenumbers = -1
let g:tagbar_phpctags_bin='bin/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'

" ==================== ctags ====================
" 设置 tags 文件路径: set tags=./tags,tags;$HOME
"set tags=.tags
let g:tagbar_type_php = {
  \ 'ctagstype' : 'php',
  \ 'kinds' : [
    \ 'i:interfaces',
    \ 'c:classes',
    \ 'd:constant definitions',
    \ 'f:functions',
    \ 'j:javascript functions:1'
  \ ]
\ }


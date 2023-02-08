" ==================== tagbar ==================== {{{

" TODO: 开发基于 tree-sitter 的 outline, 可借助 fzf 做显示（或者 tagbar 做显示）
" :CocList outline，依赖 ctags 需要更新 universal-ctags
" brew install --HEAD universal-ctags
" outline
nnoremap <leader>o :TagbarToggle<CR>
let g:tagbar_width        = 40
let g:tagbar_iconchars    = ['▸', '▾']
"let g:tagbar_autofocus    = 1

" tagbar 自动支持 jstemmer/gotags

nnoremap <silent><nowait> <leader>O :<C-u>CocList -I symbols<CR>

" }}}

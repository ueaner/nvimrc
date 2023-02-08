" ==================== indent ==================== {{{

" editorconfig 更像是一个社区标准
" 缩进应该以 editorconfig 配置为准，不同项目允许使用不同的缩进，
" 尤其是在多个开源项目之间切换时，同一编程语言的不同项目的作者，对缩进的实际使用也不一样

" 打开文件时检测实际缩进使用的空格数量
autocmd BufReadPost * autocmd BufEnter <buffer=abuf> ++once silent DetectIndent
autocmd BufNewFile * autocmd BufWritePost <buffer=abuf> ++once silent DetectIndent
nnoremap <leader>id :DetectIndent<CR>
nnoremap <leader>it :IndentTabs<CR>
nnoremap <leader>i2 :IndentSpaces 2<CR>
nnoremap <leader>i4 :IndentSpaces 4<CR>

" }}}

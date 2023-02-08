" ==================== align ==================== {{{

" quick insert date
"nnoremap <leader>id "=strftime("%Y-%m-%d %H:%M:%S")<CR>P
"inoremap <leader>id <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
"nnoremap <leader>iD "=strftime('%s')<CR>P
"inoremap <leader>iD <C-R>=strftime('%s')<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
" 使用: vipga*| 格式化 markdown 表格
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)

" Align GitHub-flavored Markdown tables
" 使用: vip,\ 或者 vip,| 格式化 markdown 表格
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
au FileType markdown vmap <Leader><Bar> :EasyAlign*<Bar><Enter>
" 需要先激活 :EasyAlign 即进入 EasyAlign 命令行模式，在普通模式下不能直接完成全部映射

" }}}

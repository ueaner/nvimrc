"setlocal foldmethod=syntax
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" 临时调试 lua 脚本时使用，直接运行当前文件
nnoremap <leader>r :luafile %<CR>

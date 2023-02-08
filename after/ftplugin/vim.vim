setlocal keywordprg=:help
setlocal foldmethod=marker

setlocal iskeyword-=#
"setlocal iskeyword+=-

" 临时调试 vim 脚本时使用，直接运行当前文件
nnoremap <leader>r :source %<CR>

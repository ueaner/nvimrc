" 运行 support/phpmanual-for-vim.sh 生成 PHP 手册的 VIM 帮助格式
set rtp+=$VIMHOME/local/phpmanual
setlocal keywordprg=:help

setlocal foldmethod=indent

" 词典文件
"setlocal dictionary=$VIMHOME/dict/php.dict
" k 标志位：扫描 'dictionary' 选项给出的文件
setlocal complete-=k complete+=k

" switch case indent
let g:PHP_vintage_case_default_indent = 1

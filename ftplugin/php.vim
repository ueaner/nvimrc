" PHP 相关配置

if exists("b:did_ftplugin_php") | finish | endif
let b:did_ftplugin_php = 1

" 运行 support/phpmanual-for-vim.sh 生成 PHP 手册的 VIM 帮助格式
set rtp+=$VIMHOME/local/phpmanual
setlocal keywordprg=:help

setlocal foldmethod=indent

" 词典文件
setlocal dictionary=$VIMHOME/dict/php.dict
" 自动完成扫描 'dictionary' 选项给出的文件
setlocal complete-=k complete+=k

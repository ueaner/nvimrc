au BufRead,BufNewFile */nginx*/etc/*,*/nginx*/etc/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */nginx*/*,*/nginx*/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */php-fpm.conf,*/my.cnf*,*.ini* setf dosini
" markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
" 拼写检查
autocmd FileType markdown,vim set spell

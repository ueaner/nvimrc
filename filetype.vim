au BufRead,BufNewFile */nginx*/etc/*,*/nginx*/etc/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */nginx*/*,*/nginx*/conf.d/* if &ft == '' | setf nginx | endif
au BufRead,BufNewFile */php-fpm.conf,*/my.cnf*,*.ini* setf dosini
autocmd BufNewFile,Bufread *.{inc,php} setf php
" markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
" @link http://www.laruence.com/2010/08/18/1718.html
autocmd FileType php,vim set keywordprg="help"
autocmd FileType vim setlocal noet ts=2 sw=2 sts=2

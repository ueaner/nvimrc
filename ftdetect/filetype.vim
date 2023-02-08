" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" ==================== filetype detect ==================== {{{

" .env 文件高亮
au BufNewFile,BufRead .env,.env.*  setf dosini

au BufNewFile,BufRead *.ssh/config.d/* setf sshconfig

au BufRead,BufNewFile */etc/{nginx,openresty}/* setf nginx
au BufRead,BufNewFile */{nginx,openresty}/conf.d/* setf nginx
au BufRead,BufNewFile */{nginx,openresty}/*.conf setf nginx

" lib.deno.d.ts
au BufNewFile,BufRead *.d.ts setf typescript

au BufNewFile,BufRead .gitconfig.*  setf gitconfig
au BufNewFile,BufRead *man.conf  setf manconf

au BufNewFile,BufRead *.xt  setf xt
" strace 文件高亮
au BufNewFile,BufRead *.trace,*.strace,*.trace.*,*.strace.*  setf strace

"au BufNewFile,BufRead tsconfig.*.json    echo "detect jsonc"
"au BufNewFile,BufRead */tsconfig/*.json  echo "detect jsonc"

" Try to auto detect and use the indentation of a file when opened.
" :verbose autocmd BufEnter
" G 翻页到末尾
" g 翻页到首行
" d 上半屏
" u 下半屏
"autocmd BufRead *vimrc*,*.vim DetectIndent

" }}}
" ==================== language specific ==================== {{{

au BufWritePre *.php,*.py,*.js,*.ts,*.lua,*.rs,*.md,*.go,*.sh,*.zsh :Stripspace

"au BufWritePre *.php,*.py,*.js,*.ts,*.lua,*.rs,*.md,*.go,*.sh,*.zsh :Stripspace
"au BufNewFile,BufRead *.sh,*.zsh,*.yml,*.html,*.js setlocal ts=2 sw=2 sts=2
"    autocmd BufEnter *.yml setlocal tabstop=2 shiftwidth=2 softtabstop=2

" }}}

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et

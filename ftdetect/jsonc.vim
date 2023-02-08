" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

autocmd BufNewFile,BufRead *.cjson setlocal filetype=jsonc
autocmd BufNewFile,BufRead coc-settings.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead *.jsonc setfiletype jsonc
autocmd BufNewFile,BufRead .eslintrc.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead .babelrc setlocal filetype=jsonc
autocmd BufNewFile,BufRead .jshintrc setlocal filetype=jsonc
autocmd BufNewFile,BufRead .jslintrc setlocal filetype=jsonc
autocmd BufNewFile,BufRead .mocharc.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead jsconfig.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead */.vscode/*.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead */tsconfig/*.json setlocal filetype=jsonc

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et

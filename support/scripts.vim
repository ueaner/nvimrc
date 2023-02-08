
" ==================== $VIMHOME ==================== {{{

if has('win32') || has('win64')
    let $VIMHOME = $HOME . "/vimfiles"
else
    " 对于 :! 命令, 默认使用 bash shell 环境
    set shell=bash
    " sudo -s, 使用 $SUDO_USER 的插件配置
    if exists('$SUDO_USER') && !has('mac')
        " 不处理当前用户 $HOME/.vim 下的插件配置
        set rtp-=$HOME/.vim
        set rtp-=$HOME/.vim/after

        let $VIMHOME = "/home/" . $SUDO_USER . "/.vim"
    else
        let $VIMHOME = $HOME . "/.vim"
    endif
endif

" }}}

" 可以配置到 ftplugin
"autocmd BufWritePre *.md,*.php,*.py,*.sh :call CleanExtraSpaces()

" Delete trailing white space on save, useful for some filetypes ;)
function! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

nnoremap <leader>it :set noexpandtab shiftwidth=0 softtabstop=0<CR>
nnoremap <leader>i2 :call s:IndentSpaces(2)<CR>
nnoremap <leader>i4 :IndentTabs<CR>
func s:IndentSpaces(...)
    " Non-numbers get converted to 0
    if a:0 == 1 && a:1 >= 2
        let width = a:1
        exec printf("setlocal tabstop=%d softtabstop=%d shiftwidth=%d",
                    \width, width, width)
    endif

    echo printf("tabstop=%d softtabstop=%d shiftwidth=%d, fold toggle: ,<space>",
                \ &tabstop, &softtabstop, &shiftwidth)
endfunc

command! -nargs=1 IndentSpaces call s:IndentSpaces(<q-args>)
command! -nargs=0 IndentTabs set noexpandtab shiftwidth=0 softtabstop=0


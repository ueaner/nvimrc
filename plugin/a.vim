" https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim#L302
" Make sure pasting in visual mode doesn't replace paste buffer
" vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
func RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunc
func s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunc
vmap <silent> <expr> p <sid>Repl()

" Visual mode pressing * or # searches for the current selection
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
func s:VisualSelection() range
    let l:saved_reg = @"
    exec "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc
vnoremap <silent> * :call <sid>VisualSelection()<cr>
vnoremap <silent> # :call <sid>VisualSelection()<cr>

" Remove Trailing Whitespace / ^M
function! s:Stripspace()
    " Remove Trailing Whitespace
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)

    " Remove Trailing ^M
    exec ":%s/\r//e"
endfunc
command! Stripspace call s:Stripspace()

" 关闭当前 buffer, 避免影响编辑器布局
func CloseSplitOrDeleteBuffer()
  let currBuf = bufnr('%')
  " non normal buffer
  " 通常使用中，主编辑区为 normal buffer (modifiable), 而 nvimtree aerial.nvim 为 nofile buffer
  " 非主编辑区的 buffer 可以直接关闭
  if &buftype != ""
    exec "confirm bd" . currBuf
    return
  endif

  " normal buffer - File not modified or saved
  if !&modified          " 切换 关闭
    exec "bp"
    exec "bd" . currBuf
    return
  endif

  " normal buffer - File modified not saved
  " 如果选择了取消不需要切换 buf, 这里做一个简版的实现替换 confirm bd bufnumber
  let choice = confirm(printf("Save changes to \"%s\"?", bufname(currBuf)),
        \ "&Yes\n&No\n&Cancel", 1)
  if choice == 1          " Yes: 保存 切换 关闭
    exec "update"
    exec "bp"
    exec "bd" . currBuf
  elseif choice == 2      " No: 切换 强制关闭
    exec "bp"
    exec "bd!" . currBuf
  else                    " Cancel: 取消不切换
    echohl WarningMsg
    echo "E516"
    echohl None
    echon ": No buffers were deleted: CloseSplitOrDeleteBuffer()"
  endif
endfunc

" Zoom / Restore window.
func! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = v:false
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = v:true
    endif
endfunc
command! ZoomToggle call s:ZoomToggle()

" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim#answer-198073
" Examples:
" :call Exec('buffers')
" This will include the output of :buffers into the current buffer.
" 
" Also try:
" :call Exec('ls')
" :call Exec('autocmd')
" :call Exec('scriptnames')
func! s:Exec(command)
    redir =>output
    silent exec a:command
    redir END
    let @o = output
    exec "put o"
    return ''
endfunc
" :Exec verbose au BufRead
command! -nargs=+ Exec call s:Exec(<q-args>)

" terminal 需要和 float window 结合，否则 terminal 直接在 buf 中打开时，使用 CTRL-N/P 切换 buf 就完全不适用了。

hi default link FloatBorder               Special

let g:floaterm_width  = 0.8
let g:floaterm_height = 0.8
hi default link FloatermBorder Special
nnoremap <silent> <leader>T :FloatermToggle<CR>
tnoremap <silent> <leader>T <C-\><C-n>:FloatermToggle<CR>

"autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
"autocmd TermClose * execute 'bdelete! ' . expand('<abuf>')
" 终端退出时不需要按任意键退出提示 [Process exited 0]
"au TermClose * call feedkeys("i")
"au TermOpen * startinsert
" floaterm exit status 为 0 时，会自动退出
" 从 floaterm 中退出时不需要调用 feedkeys
"au TermClose * if &ft != 'floaterm' | call feedkeys("i")
" floaterm 和 fzf 已经处理的很好了，只针对打开的普通终端
let blocklist = ['floaterm', 'fzf']
au TermClose * if index(blocklist, &ft) < 0 | call feedkeys("i")
" 打开终端时进入插入模式
au TermOpen * if index(blocklist, &ft) < 0 | startinsert

" floaterm fzf 也是基于 terminal, term:// 开头也被匹配到
"au TermClose term://* call feedkeys("i")
"au TermOpen term://* startinsert



function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    "let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'border': [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]}

    let top = '╭' . repeat('─', width - 2) . '╮'
    let mid = '│' . repeat(' ', width - 2) . '│'
    let bot = '╰' . repeat('─', width - 2) . '╯'
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    " 默认的 opts border 展示的两层的通过FloatBorder高亮，需要单独定义一个 line，这个 line 被认为是普通文本，只受 Normal 高亮控制
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    call setwinvar(s:buf, 'wincolor', 'Floaterm')

    set winhl=Normal:Floating,FloatBorder:Special
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

" https://github.com/huytd/vim-config/blob/master/init.vim#L172-L217
"set wildoptions=pum
set pumblend=1
let s:float_term_border_win = 0
let s:float_term_win = 0
function! FloatTerm(...)
  " Configuration
  let height = float2nr((&lines - 2) * 0.6)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.6)
  let col = float2nr((&columns - width) / 2)
  " Border Window
  let border_opts = {
        \ 'relative': 'editor',
        \ 'row': row - 1,
        \ 'col': col - 2,
        \ 'width': width + 4,
        \ 'height': height + 2,
        \ 'style': 'minimal'
        \ }
  " Terminal Window
  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }
  let top = "╭" . repeat("─", width + 2) . "╮"
  let mid = "│" . repeat(" ", width + 2) . "│"
  let bot = "╰" . repeat("─", width + 2) . "╯"
  let lines = [top] + repeat([mid], height) + [bot]
  let bbuf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(bbuf, 0, -1, v:true, lines)
  let s:float_term_border_win = nvim_open_win(bbuf, v:true, border_opts)
  let buf = nvim_create_buf(v:false, v:true)
  let s:float_term_win = nvim_open_win(buf, v:true, opts)
  " Styling
  "hi FloatWinBorder guifg=#87bb7c
  hi default link FloatWinBorder               Special
  "set winhl=Normal:Floating,FloatBorder:Special
  call setwinvar(s:float_term_border_win, '&winhl', 'Normal:FloatWinBorder')
  call setwinvar(s:float_term_win, '&winhl', 'Normal:Normal')
  if a:0 == 0
    terminal
  else
    call termopen(a:1)
  endif
  startinsert
  " Close border window when terminal window close
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

"let blacklist = ['rb', 'js', 'pl']
"autocmd BufWritePre * if index(blacklist, &ft) < 0 | do somthing you like

"autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335
"set winhl=NormalFloat:Normal,FloatBorder:Special
"set winhl=NormalFloat:Floating
"let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
"let g:fzf_layout = { 'window': 'call FloatTerm()' }


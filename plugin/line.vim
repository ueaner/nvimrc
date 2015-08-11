" ==================== tabline ====================

let g:buftabline_numbers    = 1
let g:buftabline_indicators = 1

" ==================== statusline ====================

function! HasPaste()
    if &paste
        return 'PASTE'
    en
    return 'BUF #' . bufnr('%')
endfunction

function! Editing()
    if &modified
        return '[+]'
    en
    return ''
endfunction

if has("statusline") && !&cp
  let g:statusline_separator = '|'

  " @link https://github.com/maciakl/vim-neatstatus
  let &stl=""
  " buffer number
  let &stl.="%1* %{HasPaste()} %0*"
  "let &stl.="%2* %{GitGutterGetHunkSummary()} %0* "
  "let &stl.="%2* %{s:summary[0], s:summary[1], s:summary[2]} %0* "
  " file path
  let &stl.=" %<%F "
  " read only, modified, modifiable flags in brackets
  let &stl.="%(%2* %r%{Editing()} %)"
  "let &stl.="%1* %(%r%m%) %0*"

  " right-aligh everything past this point
  let &stl.="%= "

  " file type (eg. python, ruby, etc..)
  let &stl.="%2*%( %{&filetype} %)%0* "
  " file format (eg. unix, dos, etc..)
  let &stl.="%{&fileformat} ".g:statusline_separator
  " file encoding (eg. utf8, latin1, etc..)
  let &stl.=" %(%{(&fenc!=''?&fenc:&enc)} %)"
  "line number (pink) / total lines (percentage done)
  let &stl.="%3* LN %2*%4l/%-4.L%0* %03p%% ".g:statusline_separator
  " column number (minimum width is 4)
  let &stl.=" COL %-3.c "
  " modified / unmodified (purple)
  "let &stl.="%(%6* %{&modified ? 'modified':''} %)"

endif

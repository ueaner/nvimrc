setlocal foldmethod=indent
"setlocal noexpandtab

"nnoremap <silent> <leader>dt :DlvToggleBreakpoint<CR>
"
"nnoremap <silent> <leader>da :DlvAddBreakpoint<CR>
"nnoremap <silent> <leader>dc :DlvRemoveBreakpoint<CR>
"nnoremap <silent> <leader>dd :DlvClearAll<CR>
"nnoremap <silent> <leader>de :DlvDebug<CR>
"nnoremap <silent> <leader>dt :DlvTest<CR>
"nnoremap <silent> <leader>dr :DlvExec<CR>

" DlvAddBreakpoint
" DlvAddTracepoint
" DlvAttach
" DlvClearAll
" DlvConnect
" DlvCore
" DlvDebug
" DlvExec
" DlvRemoveBreakpoint
" DlvRemoveTracepoint
" DlvTest
" DlvToggleBreakpoint
" DlvToggleTracepoint

let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }


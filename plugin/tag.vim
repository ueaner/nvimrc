" ==================== tagbar ====================
nnoremap <leader>t :TagbarToggle<CR>
let g:tagbar_width = 30
let g:tagbar_show_linenumbers = -1
" tagbar statusLine 反应不是很快
function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
	let colour = a:current ? '%#StatusLine#' : '%#StatusLineNC#'
	let flagstr = join(flags, '')
	if flagstr != ''
		let flagstr = '[' . flagstr . '] '
	endif
	return colour . '[' . sort . '] ' . flagstr . fname
endfunction
let g:tagbar_status_func = 'TagbarStatusFunc'

" ==================== ctags ====================
" 设置 tags 文件路径: set tags=./tags,tags;$HOME
"set tags=.tags
let g:tagbar_type_php = {
  \ 'ctagstype' : 'php',
  \ 'kinds' : [
    \ 'i:interfaces',
    \ 'c:classes',
    \ 'd:constant definitions',
    \ 'f:functions',
    \ 'j:javascript functions:1'
  \ ]
\ }


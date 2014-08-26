"
" Author ueaner <ueaner at gmail.com>
"

" markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
" Markdown to HTML
nnoremap <leader>md :%!/usr/local/bin/Markdown.pl --html4tags <CR>

" ############# tagbar #############
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

" ############# ctags #############
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

" ############# molokai #############
let g:molokai_original = 1
"let g:rehash256 = 1

" ############# airline #############
" 查看 airline 的可用主题：~/.vim/bundle/vim-airline/autoload/airline/themes/
let g:airline_theme='jellybeans'
" tabline 启动时会将文件列表在顶栏显示，干的漂亮
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#show_tab_nr = 1 " show tab number
" font
"let g:airline_powerline_fonts=1
" tagbar
let g:airline#extensions#tagbar#enabled = 1
" ctrlp
let g:airline#extensions#ctrlp#show_adjacent_modes = 1

" unicode symbols
"if !exists('g:airline_symbols')
"    let g:airline_symbols = {}
"endif
"let g:airline_left_sep = '»'
"let g:airline_right_sep = '«'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.whitespace = 'Ξ'

"let g:airline_section_z='%{g:airline_externals_fugitive}
"%{tagbar#currenttag('[%s] ','')}
"%{fugitive#statusline()}


" ############# neocomplete	#############
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" AutoComplPop like behavior.
let g:neocomplete#enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" 参见：/usr/local/vim74/share/vim/vim74/autoload/phpcomplete.vim
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

" ############# neosnippet #############
" Plugin key-mappings.
imap <C-y>     <Plug>(neosnippet_expand_or_jump)
smap <C-y>     <Plug>(neosnippet_expand_or_jump)
xmap <C-y>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" ############# indent guides #############
" 使用：<leader>ig 启动
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0 " 自动着色,自定义的颜色配置就不起作用
let g:indent_guides_soft_pattern = ' '
" 这两个颜色可以随意设置
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=black

" ############# indent guides #############
"let g:DoxygenToolkit_authorName="ueaner"
"let g:DoxygenToolkit_briefTag_funcName="yes"
"let g:DoxygenToolkit_versionString="1.0"

" ############# PHP 5.3+ 语法 #############
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

" ############# Omni-complete #############

" ############# NERDTree #############
"nnoremap <leader>d :NERDTreeToggle<CR>
"let NERDTreeQuitOnOpen=1 " 打开文件时关闭树
"let NERDTreeWinSize = 25 " 窗口大小
"let NERDTreeMinimalUI = 1 " 不显示帮助面板
"let NERDTreeDirArrows = 0 " 目录箭头:1显示箭头 0传统+-|号
"let NERDTreeMouseMode = 2 " 单击打开目录，双击打开文件

" ############# Syntastic #############
let g:syntastic_check_on_open=1
let g:syntastic_echo_current_error=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump=0
let g:syntastic_auto_loc_list=2
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }


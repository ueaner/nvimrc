" ==================== plugins ==================== {{{

filetype off                  " required

if has('win32') || has('win64')
    " @link https://github.com/gmarik/Vundle.vim/wiki/Vundle-for-Windows
    set rtp+=~/vimfiles/bundle/Vundle.vim
    let path='~/vimfiles/bundle'
    call vundle#begin(path)
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'

if has('lua')
    " 自动完成
    Plugin 'shougo/neocomplete.vim'
endif

" 主题
Plugin 'ueaner/molokai'

" marks, 快捷键帮助:help showmarks-mappings
Plugin 'juanpabloaj/ShowMarks'

" 文件浏览
Plugin 'scrooloose/nerdtree'

" buffer tabs
Plugin 'ap/vim-buftabline'

"
" and more ...
"
" 自动关闭括号
Plugin 'fatih/vim-go'
"Plugin 'keith/swift.vim'
"Plugin 'mattn/emmet-vim'
"Plugin 'xwsoul/vim-zephir'
"Plugin 'cohama/lexima.vim'
"Plugin 'junegunn/vim-easy-align'
"Plugin 'justinmk/vim-sneak'
"Plugin 't9md/vim-choosewin'
"Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'StanAngeloff/php.vim'

" 多点编辑, 也可以使用 *cw<要替换的内容><ESC>, n.n.n.
" 参见：http://federicoramirez.name/why-vim-is-awesome/
"Plugin 'terryma/vim-multiple-cursors'

" 中文文档
Plugin 'vimchina/vimcdoc'

if has('python')
    " dbgp debugger, 默认端口 9000.
    "Plugin 'joonty/vdebug'
endif

call vundle#end()            " required

" }}}
" ==================== neocomplete ==================== {{{

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
inoremap <silent> <CR> <C-R>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    " 有补全菜单进行补全，否则插入回车
    return (pumvisible() ? "\<C-Y>" : "" ) . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-N>" : "\<TAB>"

" 自动选中第一个
let g:neocomplete#enable_auto_select = 1
" 使用 CTRL+X+O 提示参数时只显示下拉提示，不显示 preview
" 为 1 且配合set completeopt+=preview 则永久显示
" https://github.com/Shougo/neocomplete.vim/issues/95
let g:neocomplete#enable_auto_close_preview = 0

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php    = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.python = '[^. *\t]\.\w*\|\h\w*'

" 使用 vim-multiple-cursors 插件进行多点编辑时锁定 NeoComplete
function! Multiple_cursors_before()
    exe 'NeoCompleteLock'
    echo 'Disabled autocomplete'
endfunction

function! Multiple_cursors_after()
    exe 'NeoCompleteUnlock'
    echo 'Enabled autocomplete'
endfunction

" }}}
" ==================== showmarks ==================== {{{

" Enable ShowMarks
let showmarks_enable = 1
" Show which marks
let showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = 'hqm'
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1

" mappings from showmarks.vim
if !hasmapto( '<Plug>ShowmarksShowMarksToggle' ) | map <silent> <unique> <leader>mt :ShowMarksToggle<cr>|    endif
if !hasmapto( '<Plug>ShowmarksShowMarksOn'     ) | map <silent> <unique> <leader>mo :ShowMarksOn<cr>|        endif
if !hasmapto( '<Plug>ShowmarksClearMark'       ) | map <silent> <unique> <leader>mh :ShowMarksClearMark<cr>| endif
if !hasmapto( '<Plug>ShowmarksClearAll'        ) | map <silent> <unique> <leader>ma :ShowMarksClearAll<cr>|  endif
if !hasmapto( '<Plug>ShowmarksPlaceMark'       ) | map <silent> <unique> <leader>mm :ShowMarksPlaceMark<cr>| endif

" }}}
" ==================== nerdtree ==================== {{{

" 禁止载入 netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

"let NERDTreeQuitOnOpen = 1 " 打开文件时关闭树
let NERDTreeMinimalUI  = 1 " 不显示帮助面板
let NERDTreeDirArrows  = 0 " 目录箭头:1显示箭头 0传统+-|号
let NERDTreeMouseMode  = 2 " 单击打开目录，双击打开文件
"let NERDTreeWinSize = 25 " 窗口大小

let NERDTreeIgnore     = ['\.idea$', '\.tags$']

" Open nerdtree in current dir, write our own custom function because
" NerdTreeToggle just sucks and doesn't work for buffers
function! g:NerdTreeFindToggle()
    if g:NERDTree.IsOpen()
        exec 'NERDTreeClose'
    else
        exec 'NERDTreeFind'
    endif
endfunction

" For toggling
noremap <leader>n :<C-U>call g:NerdTreeFindToggle()<cr>

" }}}
" ==================== buffer tabline ==================== {{{

let g:buftabline_indicators = get(g:, 'buftabline_indicators', 1)
hi default link BufTabLineCurrent TabLineSel
hi default link BufTabLineActive  Pmenu
hi default link BufTabLineHidden  TabLine
hi default link BufTabLineFill    TabLineFill

" }}}

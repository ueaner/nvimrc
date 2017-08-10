" ==================== plugins ==================== {{{

filetype off                  " required

set rtp+=$VIMHOME/bundles/Vundle.vim
call vundle#begin($VIMHOME . "/bundles")

Plugin 'gmarik/Vundle.vim'

if has('lua')
    " 自动完成
    Plugin 'shougo/neocomplete.vim'
endif

" buffer tabs
Plugin 'ap/vim-buftabline'

" 文件浏览
Plugin 'scrooloose/nerdtree'

if filereadable(expand($VIMHOME . "/local/local.bundles.vim"))
    source $VIMHOME/local/local.bundles.vim
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

" java neocomplete
autocmd FileType java setlocal omnifunc=javacomplete#Complete
let g:neocomplete#sources#omni#input_patterns.java = '\h\w*\.\w*'

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

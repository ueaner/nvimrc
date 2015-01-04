" ==================== NerdTree ====================
let NERDTreeQuitOnOpen=1 " 打开文件时关闭树
"let NERDTreeWinSize = 25 " 窗口大小
let NERDTreeMinimalUI = 1 " 不显示帮助面板
let NERDTreeDirArrows = 0 " 目录箭头:1显示箭头 0传统+-|号
let NERDTreeMouseMode = 2 " 单击打开目录，双击打开文件

" Open nerdtree in current dir, write our own custom function because
" NerdTreeToggle just sucks and doesn't work for buffers
function! g:NerdTreeFindToggle()
    if nerdtree#isTreeOpen()
        exec 'NERDTreeClose'
    else
        exec 'NERDTreeFind'
    endif
endfunction

" For toggling
noremap <Leader>n :<C-u>call g:NerdTreeFindToggle()<cr>

" For refreshing current file and showing current dir
noremap <Leader>j :NERDTreeFind<cr>

" ==================== choosewin ====================
" invoke with '-'
nmap  -  <Plug>(choosewin)

" ==================== ctrlp ====================
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

"echomsg "load plugin/nerdtree.vim"
" ==================== nerdtree ==================== {{{
" https://github.com/Xuyuanp/yanil nerdtree in lua

" 使用 I 展示/隐藏 . 开头的文件

" 禁止载入 netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

let NERDTreeCascadeSingleChildDir = 0
let NERDTreeShowHidden = 1  " 显示隐藏文件
let NERDTreeMinimalUI  = 1  " 不显示帮助面板
let NERDTreeDirArrows  = 0  " 目录箭头:1显示箭头 0传统+-|号
let NERDTreeMouseMode  = 2  " 单击打开目录，双击打开文件
let NERDTreeWinSize    = 36 " 窗口大小

let NERDTreeIgnore = ['node_modules$', '\.git$']

func g:NERDTreeFindToggle()
    if g:NERDTree.IsOpen()
        exec 'NERDTreeClose'
    else
        exec 'NERDTreeFind'
    endif
endfunc

" 定位当前打开的文件在 NERDTree 中的位置
" 最终状态：打开并定位
func g:NERDTreeFindLocate()
    if strridx(expand('%'), 'NERD_tree_') != '0'
        exec 'NERDTreeFind'
    endif
endfunc

func g:NERDTreeFindLocate__()
    let cfname = expand('%')
    " 当前在 NERDTree 中时什么也不做
    if strridx(cfname, 'NERD_tree_') == '0'
        return
    endif
    " 去除 ./ 开头前缀，否则 nerdtree/autoload/nerdtree/ui_glue.vim@s:findAndRevealPath 报错
    if strridx(cfname, './') == '0' " cfname[0:1], substitute
        exec 'NERDTreeFind ' . cfname[2:]
    else
        exec 'NERDTreeFind %'
    endif
endfunc

" For toggling
nnoremap <leader>e :<C-U>call g:NERDTreeFindToggle()<CR>
nnoremap <leader>l :<C-U>call g:NERDTreeFindLocate()<CR>

" Nerdtree: Close NERDTree if it is the last open buffer
" 当有其他 buf 时也被退出 vim 了
"autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
"function! s:CloseIfOnlyNerdTreeLeft()
"  if exists("t:NERDTreeBufName")
"    if bufwinnr(t:NERDTreeBufName) != -1
"      if winnr("$") == 1
"        q
"      endif
"    endif
"  endif
"endfunction

" }}}

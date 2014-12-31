" ==================== showmarks ====================
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

" ==================== sneak ====================
" s{char}{char} 支持两个字符搜索

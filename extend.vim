" 配色方案
if &t_Co == 256
    let g:rehash256 = 1
endif
silent! colorscheme molokai

" 命令行补全忽略
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.DS_Store

" 拼写检查，7.4+
if has('spell') && v:version >= 704 && has('patch092')
    " 中日韩字符不进行检查，7.4.092+，:help spell-cjk
    set spelllang=en_us,cjk
    " 10 条最佳拼写建议, 使用 z= 列出拼写建议
    set spellsuggest=best,10
    " markdown, php 类型文件自动进行拼写检查
    "autocmd FileType markdown,php set spell
    " 快捷键 ,s
    nnoremap <leader>s :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif

" ==================== 插入模式下 readline 命令行风格键映射 ==================== {{{

" 移动: 行首/行尾
inoremap <C-A> <Home>
inoremap <C-E> <ESC><S-A>
" 移动: 向左/右一个字符
inoremap <C-B> <Left>
inoremap <C-F> <Right>
" 删除光标前/后一个字符
" <C-H>  :h i_CTRL-H
inoremap <C-D> <Del>
" 删除光标前一个单词
" <C-W>  :h i_CTRL-W
" 删除光标前/后所有字符
" <C-U>  :h i_CTRL-U
inoremap <C-K> <C-O>D

" }}}

" 使用鼠标
if has('mouse')
    "set mouse=a
endif

" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
"set clipboard^=unnamed
"set clipboard^=unnamedplus

" 粘贴模式 ,p
"nnoremap <leader>p :set paste<CR>p :set nopaste<CR>

" 直接进入可视模式
inoremap <C-V> <Esc>lv
" <C-o> 插入模式下进入 临时插入模式 可以执行一条命令后再次进入插入模式

" 高亮最后一次插入的文本，gv 高亮最后一次的选中: h gv, h v_o
nnoremap gV `[v`]

" 输入模式下键入jj映射到<ESC>
imap jj <ESC>
" <C-c> = <ESC>

" 选中一个表格格式区域 ,t 将其格式化
map <leader>t :'<'>! column -t<CR>

" 最大化, 另一个调整窗口大小的命令 :resize
nnoremap + :on<CR>
" 关闭, 最小化 ,g 唤出刚关闭的 buffer
nnoremap - :call CloseSplitOrDeleteBuffer()<CR>

" 针对 class 文件的函数折叠 ,f 只显示函数名, 再次 ,f 显示函数全部内容
function! FoldToggle()
    "let &foldlevel = &foldlevel == 1 ? 10 : 1
    if &foldlevel == 10
        if &filetype == 'vim'
            silent! setlocal foldlevel=0
        else
            silent! setlocal foldlevel=1
        endif
    else
        silent! setlocal foldlevel=10
    endif
endfunction

function! SimplePhpLint()
    let l:output = system("php -l " . @%)
    let l:list = split(l:output, "\n")

    if 0 != v:shell_error && match(l:list[0], "No syntax errors") == -1
        echohl Error | echo l:list[0] | echohl None
    else
        echo "No syntax errors"
    endif
endfunction

augroup Multi
    autocmd!
    autocmd FileType php,vim nnoremap <leader>f :call FoldToggle()<CR>
    autocmd FileType php nnoremap <leader>c :call SimplePhpLint()<CR>
augroup END

" ==================== filetype ==================== {{{

au BufRead,BufNewFile *.{conf,cnf,ini} setf dosini

" }}}

" @see https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim#L202
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        echo "normal /" . l:pattern . "^M"
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

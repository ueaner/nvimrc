" {{{
"
" Author ueaner <ueaner#gmail.com>
"
" 目录结构:
" ~
" ├── .vim
" │   ├── README.md
" │   ├── after
" │   │   └── ftplugin       针对文件类型的配置
" │   ├── autoload
" │   │   └── plug.vim       vim-plug 插件管理工具
" │   ├── gvimrc             gvim/macvim 配置
" │   ├── support            支持性的脚本及文件
" │   ├── vimrc              主配置文件
" │   └── vimrc.local        自定义本地配置，会自动加载
" ├── .cache/nvim
" │   ├── bundle             插件存储目录
" │   └── undo               undo 文件目录
" └── .config
"     ├── coc
"     │   ├── coc-settings.json
"     │   └── ...
"     └── nvim
"         └── init.vim
"
" }}}
" ==================== general options ==================== {{{

let mapleader = ','
let g:mapleader = ','

" truecolor
" echo $TERM_PROGRAM  Apple_Terminal iTerm.app tmux
" enables 24-bit rgb color in the tui.
" uses "gui" highlight attributes instead of "cterm" attributes.
" https://github.com/termstandard/colors
" brew edit someformula 不支持 truecolor
if has('termguicolors') && $COLORTERM == 'truecolor'
    set termguicolors
endif

" 启用鼠标
set mouse=nvi

" vim 内部编码(buffer,菜单文本[gvim],消息文本等), :help ++enc
set encoding=utf-8
" utf-8 编码, 去除 BOM
if &modifiable | set fileencoding=utf-8 nobomb | endif
" 换行符格式, Line Endings, :help ++ff
set fileformats=unix,dos,mac
" 不生成备份文件, 和 .swp 文件
set nobackup
set nowritebackup
set noswapfile
set updatetime=300
" 文件改变自动读入，就像协作一样
set autoread
autocmd FocusGained,BufEnter * checktime
" Reopen files at last edit position, :help restore-cursor
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! `\"" |
  \ endif

" 隐藏缓冲区, 无需保存即可切换 buffer
set hidden
" 重用已打开的 buffer
set switchbuf=useopen
" 新窗口在下右方打开
set splitbelow splitright

" 显示空白字符，SpecialKey 定义空白字符的显示颜色
set list nowrap
" 长行不换行
set nowrap
set listchars=tab:>-,trail:.
" 垂直窗口分割字符 vert 默认渲染为无空隙的整条竖线, 和折叠填充字符
set fillchars=fold:\ ,eob:\ ,diff:-
" Global Statusline (nvim0.7+) 底部动态展示活动窗口的 statusline，hl-WinSeparator
" 展示内容使用 :help statusline 配置项
set laststatus=3
" 在屏幕右下角显示未完成的指令输入
set showcmd
" 显示当前模式
set showmode
" 显示行号
set number
" 光标滚动时始终保持在中间行, 属于非 H M L 和 zz zt zb 的另一种操作习惯
"let &scrolloff=&lines
" 光标滚动时屏幕上下保留 3 行
set scrolloff=3

" 括号匹配，依赖 $VIMRUNTIME/plugin/matchparen.vim
set showmatch
" 跳转到匹配括号的停留时间 0.3s
set matchtime=3
" 突出显示当前行号
set cursorline cursorlineopt=number
" 行尾单词整体换行，不截断单词
set linebreak
" 滚屏时光标保持在同一列
set nostartofline
" FOOBAR=~/<CTRL-X><CTRL-F>
" Vim 提供 file.c:line 的跳转方式，如光标在 file.c:10 时，按下 gF 将跳转到 file.c 文件的第 10 行
" 但不提供 file.c@symbol 的跳转方式，@ 默认被认为是文件中的一部分
set isfname-==
set isfname-=:

" 1 个 TAB 占 4 个位置
set tabstop=4 softtabstop=4 shiftwidth=4
" 使用空格代替 tab
set expandtab
set smarttab
" 智能缩进
set autoindent smartindent
" 回退
set backspace=indent,eol,start

" 默认自动折叠，默认 foldlevel=0 时关闭所有折叠
"set foldlevel=0
set nofoldenable
" indent 受 shiftwidth 的影响，如果 shiftwidth=4 但实际文件中以两个空格代表一个 tab 进行缩进
" 在输入回车自动缩进和折叠时都还会
set foldmethod=indent
" 左侧添加一列, 指示折叠的打开和关闭
"silent! set foldcolumn=1
" Merge signcolumn with number line
"set signcolumn=number
" signcolumn 保持一直有或者一直没有，避免 auto 窗口跳动
set signcolumn=yes

" 中间可能会有其他插件设置 signcolumn 的值，配置文件中， plugin 应该放在最上面
"if &signcolumn != 'number'
    " coc diagnostic.enableSign: true 时, signcolumn 会被自动设置为 auto
    " 当有错误提示时 coc 会多一列指示错误行，编辑窗口会跳动一下，
    " 关闭它（关闭了之后 vim8 的 signcolumn 又不起作用了）
    " 只展示错误行号的颜色就好，就像在行号上打标记
    "set signcolumn=no
"endif

" auto complete
" 自动完成的最大条数
set pumheight=10
" :help completeopt@en
"set complete=.,w,b,u,t
set complete-=i
set completeopt=longest,menuone,noinsert
" Suggestion: show info for completion candidates in a popup menu
if !has('nvim')
    set completeopt+=popup
    set completepopup=align:menu,border:off,highlight:Pmenu
endif

" 搜索文件并打开 :find somefile<TAB>
set path+=**
" 命令行补全增强
set wildmenu
" nvim 下命令行补全忽略文件名大小写
set wildignorecase
" 命令行列出所有的补全可能性, 配合 <C-N>, <C-P> 使用
if !has('nvim')
    set wildmode=longest,list
    " vim8.2 screen-256color 会丢失颜色
    "set term=xterm-256color
endif

" 实时显示搜索结果
set incsearch
" 忽略大小写, 如果输入搜索模式下含有大写字母则不启用忽略大小写
set ignorecase smartcase
" 高亮搜索结果
set hlsearch

set shortmess+=c

" 去除提示音
set noerrorbells
" 关闭可视响铃和鸣叫
set visualbell t_vb=
" timeout
set notimeout
set ttimeout
set ttimeoutlen=10

" undo
set undofile
set undolevels=400
" v:progname: nvim 和 vim 二者的 undofile 格式不兼容
if has('nvim')
    set undodir=$HOME/.cache/nvim/undo
else
    set undodir=$HOME/.cache/vim/undo
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
endif

" 合并注释行时自动删除注释标志
silent! set formatoptions+=j

" 中日韩字符不进行检查，:help spell-cjk
set spelllang=en_us,cjk
" 10 条最佳拼写建议, 使用 z= 列出拼写建议
set spellsuggest=best,10

" 追加补全词典
if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words
endif

" }}}
" ==================== mappings ==================== {{{

vnoremap <silent> <expr> p <sid>Repl()

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call <SID>VisualSelection()<CR> :let v:hlsearch=1<CR>
vnoremap <silent> # :call <SID>VisualSelection()<CR> :let v:hlsearch=1<CR>

" 暂停/恢复高亮
nnoremap <expr> <leader>h v:hlsearch ? ":let v:hlsearch=0\<CR>" : ":let v:hlsearch=1\<CR>"

" 搜索当前光标下的单词，但是不跳转下一个, :help gd
nnoremap <silent> <leader>k wb/\<<C-R><C-W>\>/e<CR>

" 使用空格打开/关闭折叠
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>

" 对较长行自动换行时，可以作为多行上下移动
noremap j gj
noremap k gk

" 复制到行尾，类似大写的 C 和 D 操作
nnoremap Y y$

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" Save
inoremap <C-s>     <C-O>:update<CR>
nnoremap <C-s>     :update<CR>

" | 使当前窗口成为屏幕上唯一的窗口，其它窗口都关闭
nnoremap \| :only<CR>
" +_ 调整当前窗口大小: winwidth('%') winheight('%'), % 和 0 表示当前窗口
nnoremap + :resize +3<CR>
nnoremap _ :resize -3<CR>

" 标签跳转：一个匹配，直接跳转；多个匹配，选择跳转。 :h g_CTRL-]
"nnoremap <C-]> g<C-]>

" Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" 插入模式下 Emacs 风格键映射
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
" h i_CTRL-Y 插入光标上面的字符

" 命令行模式下 Emacs 风格键映射
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>
" 删除光标后的所有字符
cnoremap <C-K> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
"cnoremap <expr> <C-Y> pumvisible() ? "\<C-Y>" : "\<C-R>-"

" 切换 buffer，也可映射为 gB/gb 类似 tab 的 gT/gt 操作
nnoremap <expr> <C-N> empty(&buftype) ? ":bnext\<CR>" : ''
nnoremap <expr> <C-P> empty(&buftype) ? ":bprev\<CR>" : ''
" 切换到上一个打开的 buffer, 同 CTRL-^
nnoremap <expr> <leader><leader> empty(&buftype) ? ":e#\<CR>" : ''

" 关闭当前 buffer 或关闭 window
nnoremap <leader>q :call CloseSplitOrDeleteBuffer()<CR>

" 关闭除当前 buffer 以外的其他 buffers
nnoremap <leader>Q :call CloseOtherBuffers()<CR>

" 快速编辑当前加载的 vimrc 配置文件
nnoremap <leader>vv :e $MYVIMRC<CR>
nnoremap <leader>va :e ~/.config/alacritty/alacritty.yml<CR>
nnoremap <leader>vt :e ~/.config/tmux/tmux.conf<CR>

" 有补全菜单进行补全，否则插入回车
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" 插入模式下重新映射 <TAB> 键到 InsertTabWrapper
inoremap <silent> <TAB> <C-R>=<SID>InsertTabWrapper()<CR>

" 保存无权限文件, :h E174
command! W w !sudo tee % > /dev/null

" toggle clipboard
" XXX: <Bar> 造成了光标位置变动?
" nnoremap <silent> <leader>c :ClipboardToggle<CR><Bar>:ShowToggle clipboard<CR>
nnoremap <silent> <leader>c :ClipboardToggle<CR>
"nnoremap <leader>c :call <SID>ClipboardToggle()<CR>

" toggle zoom
nnoremap <leader>z :ZoomToggle<CR>

" toggle fold
"nnoremap <expr> <leader><space> &foldenable ? ':set nofoldenable<CR>' : ':set foldenable<CR>'
"nnoremap <leader><space> :set foldenable!<CR>
nnoremap <leader><space> zi

" 切换粘贴模式
"set pastetoggle=<leader>p
nnoremap <leader>p :set paste!<CR>

" toggle spell
nnoremap <leader>s :set spell!<CR>

" 去除尾部空字符
"nnoremap <silent> <leader>W :%s/\s\+$//e<CR>:let @/=''<CR>
" NOTE: 替换动作会改变光标位置（成功匹配到并替换时），单独写函数处理光标问题
nnoremap <leader>W :Stripspace<CR>

" 去除尾部 ^M
nnoremap <leader>M :%s/\r//e<CR>

" Disable Ex-Mode
nnoremap Q <NOP>

nnoremap <BS> X

" 显示当前文件名的完整路径和当前缓冲区号。
nnoremap <C-g> 2<C-g>

" }}}
" ==================== vimrc.local ==================== {{{

" 加载本地配置，可覆盖默认配置
exec 'silent! source ' . expand('<sfile>:p:h') . '/vimrc.local'

" 为特定的文件类型载入相应的插件
filetype plugin indent on
" 打开语法高亮
syntax on

" }}}
" ==================== functions ==================== {{{

" https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim#L295
" Make sure pasting in visual mode doesn't replace paste buffer
func RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunc
func s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunc

" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
func s:VisualSelection() range
    let l:saved_reg = @"
    exec "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

" http://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
func CloseSplitOrDeleteBuffer()
    let curNr = winnr()
    let curBuf = bufnr('%')
    wincmd w                    " try to move on next split
    if winnr() == curNr         " there is no split
        exec 'bdelete'
    elseif curBuf != bufnr('%') " there is split with another buffer
        wincmd W                " move back
        exec 'bdelete'
    else                        " there is split with same buffer
        wincmd W
        wincmd c
    endif
endfunc

" 关闭除当前 buffer 以外的其他 buffers
" nerdtree 和未保存的文件不会被关闭
func CloseOtherBuffers(...)
    let range = a:0 > 0 ? a:1 : 'other'
    " 获取 buffer number 列表，不包含未保存的 buffer
    let bufNums = filter(range(1, bufnr('$')), 'buflisted(v:val) && !getbufvar(v:val, "&modified")')
    let curBufNum = bufnr('%')
    for bufNum in bufNums
        if range ==# 'other'    " 关闭其他 buffer
            if bufNum != curBufNum
                exec 'bdelete ' . bufNum
            endif
        elseif range ==# 'left'  " 关闭左侧 buffer
            if bufNum < curBufNum
                exec 'bdelete ' . bufNum
            endif
        elseif range ==# 'right' " 关闭右侧 buffer
            if bufNum > curBufNum
                exec 'bdelete ' . bufNum
            endif
        endif
    endfor
endfunc

" 使用 tab 键自动补全或尝试自动补全: 补全 'complete' 选项的词
" :help i_CTRL-N and :help 'complete'
func s:InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<TAB>"
    elseif pumvisible()
        return "\<C-N>"
    else
        " 首次弹出补全菜单自动选中
        return "\<C-N>\<Down>"
    endif
endfunc

" Vim 使用系统剪切板开关
func s:ClipboardToggle()
    if strridx(&clipboard, "unnamed") > -1
        set clipboard-=unnamed
        set clipboard-=unnamedplus
    else
        set clipboard^=unnamed
        set clipboard^=unnamedplus
    endif
endfunc
command! ClipboardToggle call s:ClipboardToggle()

" Zoom / Restore window.
func! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = v:false
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = v:true
    endif
endfunc
command! ZoomToggle call s:ZoomToggle()

" Remove unnecessary whitespace
function! s:Stripspace()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunc
command! Stripspace call s:Stripspace()

func! s:ShowToggle(name) abort
    " my#toggle#list += xxx
    let toggles = {
        \ 'clipboard': strridx(&clipboard, 'unnamed') > -1,
        \ 'zoom': exists('t:zoomed') && t:zoomed,
        \ 'fold': &foldenable,
        \ 'paste': &paste,
        \ 'spell': &spell,
    \}

    if !has_key(toggles, a:name)
        echo printf("Warning: toggle could be either %s.", join(keys(toggles), "|"))
        return
    endif

    " 首字母大写: substitute(a:name, '^.', '\u&', '')
    echo printf("%s: %s", a:name, strpart("offon", 3 * toggles[a:name], 3))
endfunc

command! -nargs=1 ShowToggle call s:ShowToggle(<q-args>)

" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim#answer-198073
" Examples:
":call Exec('buffers')
"This will include the output of :buffers into the current buffer.
"
"Also try:
":call Exec('ls')
":call Exec('autocmd')
func! s:Exec(command)
    redir =>output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
    return ''
endfunc
" :Exec verbose au BufRead
command! -nargs=+ Exec call s:Exec(<q-args>)

" }}}

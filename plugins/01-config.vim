echo expand("<sfile>")
" ==================== plugins ==================== {{{


"silent! colorscheme molokai
"silent! colorscheme Tomorrow-Night-Bright
silent! colorscheme onedark
"hi default link BufTabLineActive          PmenuSel
hi default link BufTabLineActive          StatusLine
hi default link FloatBorder               Special

" }}}
" ==================== nerdtree ==================== {{{

" 使用 I 展示/隐藏 . 开头的文件

" 禁止载入 netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

"let NERDTreeQuitOnOpen = 1 " 打开文件时关闭树
let NERDTreeMinimalUI  = 1 " 不显示帮助面板
let NERDTreeDirArrows  = 0 " 目录箭头:1显示箭头 0传统+-|号
let NERDTreeMouseMode  = 2 " 单击打开目录，双击打开文件
"let NERDTreeWinSize = 25 " 窗口大小

func g:NERDTreeFindToggle()
    if g:NERDTree.IsOpen()
        exec 'NERDTreeClose'
    else
        exec 'NERDTreeFind'
    endif
endfunc

" 不在 nerdtree 上时，跳转到 nerdtree 上的文件位置
" 便于打开某个文件时的定位
func g:NERDTreeFindF()
    if strridx(expand('#'), 'NERD_tree_') != '0'
        exec 'NERDTreeFind %'
    endif
endfunc

" 没有打开 nerdtree 的时候使用 ,n
" 打开 nerdtree 且光标在主编辑文件时用 ,f :NERDTreeFind %

" For toggling
nnoremap <leader>n :<C-U>call g:NERDTreeFindToggle()<CR>
nnoremap <leader>l :<C-U>call g:NERDTreeFindF()<CR>

" }}}
" ==================== tagbar ==================== {{{

" brew install --HEAD universal-ctags
" outline
nnoremap <leader>o :TagbarToggle<CR>
let g:tagbar_width        = 40
let g:tagbar_iconchars    = ['▸', '▾']
"let g:tagbar_autofocus    = 1

" tagbar 自动支持 jstemmer/gotags

nnoremap <silent><nowait> <leader>O :<C-u>CocList -I symbols<CR>

" }}}
" ==================== fzf rg ==================== {{{

function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    "let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'border': [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]}

    let top = '╭' . repeat('─', width - 2) . '╮'
    let mid = '│' . repeat(' ', width - 2) . '│'
    let bot = '╰' . repeat('─', width - 2) . '╯'
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    " 默认的 opts border 展示的两层的通过FloatBorder高亮，需要单独定义一个 line，这个 line 被认为是普通文本，只受 Normal 高亮控制
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    call setwinvar(s:buf, 'wincolor', 'Floaterm')

    set winhl=Normal:Floating,FloatBorder:Special
    "let opts.row += 1
    "let opts.height -= 2
    "let opts.col += 2
    "let opts.width -= 4
    "call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    "au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

" https://github.com/huytd/vim-config/blob/master/init.vim#L172-L217
"set wildoptions=pum
set pumblend=1
let s:float_term_border_win = 0
let s:float_term_win = 0
function! FloatTerm(...)
  " Configuration
  let height = float2nr((&lines - 2) * 0.6)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.6)
  let col = float2nr((&columns - width) / 2)
  " Border Window
  let border_opts = {
        \ 'relative': 'editor',
        \ 'row': row - 1,
        \ 'col': col - 2,
        \ 'width': width + 4,
        \ 'height': height + 2,
        \ 'style': 'minimal'
        \ }
  " Terminal Window
  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }
  let top = "╭" . repeat("─", width + 2) . "╮"
  let mid = "│" . repeat(" ", width + 2) . "│"
  let bot = "╰" . repeat("─", width + 2) . "╯"
  let lines = [top] + repeat([mid], height) + [bot]
  let bbuf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(bbuf, 0, -1, v:true, lines)
  let s:float_term_border_win = nvim_open_win(bbuf, v:true, border_opts)
  let buf = nvim_create_buf(v:false, v:true)
  let s:float_term_win = nvim_open_win(buf, v:true, opts)
  " Styling
  "hi FloatWinBorder guifg=#87bb7c
  hi default link FloatWinBorder               Special
  "set winhl=Normal:Floating,FloatBorder:Special
  call setwinvar(s:float_term_border_win, '&winhl', 'Normal:FloatWinBorder')
  call setwinvar(s:float_term_win, '&winhl', 'Normal:Normal')
  if a:0 == 0
    terminal
  else
    call termopen(a:1)
  endif
  startinsert
  " Close border window when terminal window close
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

"autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335
"set winhl=NormalFloat:Normal,FloatBorder:Special
"set winhl=NormalFloat:Floating
"let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
"let g:fzf_layout = { 'window': 'call FloatTerm()' }


" Disable fzf statusline
let g:fzf_statusline=0
let g:fzf_nvim_statusline=0
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>e :History<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>m :Marks<CR>

let g:fzf_colors = {
  \ 'header':  ['fg', 'Comment']
  \ }

" brew install ripgrep
" 1. 允许使用在 vim 命令行给 Rg 传递参数，如 :Rg -w somestring
"    搜索以 "-" 开头的词需要转义，避免被认为是传递的参数 :Rg "\-\-exclude"
" 2. 未输入关键字时，默认搜索光标下的词，否则搜索输入的词
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '
  \   . (empty(<q-args>) ? expand("<cword>") : <q-args>),
  \   1, fzf#vim#with_preview(), <bang>0)

nnoremap <leader>/ :Rg<space>

command TODO Rg! 'XXX|TODO|FIXME|todo|fixme'
nnoremap <leader>x :Rg 'XXX\|TODO\|FIXME\|todo\|fixme'<CR>

" 使用的 /usr/share/dict/words
inoremap <expr> <C-X><C-K> fzf#vim#complete#word({'right': '15%'})

" }}}
" ==================== coc ==================== {{{

" Debug: :CocCommand workspace.showOutput yaml

let g:coc_config_home = $HOME . '/.config/coc'

let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-vimlsp',
  \ 'coc-go',
  \ 'coc-rls', 'coc-rust-analyzer',
  \ 'coc-pyright',
  \ 'coc-tsserver', 'coc-tslint-plugin',
  \ 'coc-java',
  \ 'coc-lua',
  \ 'coc-snippets',
  \ 'coc-clangd',
  \ 'coc-sh',
  \ 'coc-marketplace',
  \ 'coc-highlight',
  \ 'coc-yaml',
  \ 'coc-tabnine',
  \ 'coc-markmap',
  \ 'coc-floaterm'
  \ ]

" github/copilot.vim

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" :CocList marketplace

" coc-vimlsp: vimscript language server    后期可以考虑换成 https://github.com/google/vimscript-language-server

" 一些系统自带或者brew包的头文件依赖，生成 compile_commands.json 文件，供 coc-clangd 使用

" https://github.com/josa42/coc-go

let g:coc_filetype_map = {
  \ 'yaml.docker-compose': 'yaml',
  \ }

" :CocOpenLog

" 中间可能会有其他插件设置 signcolumn 的值，配置文件中， plugin 应该放在最上面
if &signcolumn != 'number'
    " coc diagnostic.enableSign: true 时, signcolumn 会被自动设置为 auto
    " 当有错误提示时 coc 会多一列指示错误行，编辑窗口会跳动一下，
    " 关闭它（关闭了之后 vim8 的 signcolumn 又不起作用了）
    " 只展示错误行号的颜色就好，就像在行号上打标记
    set signcolumn=no
endif

if exists('g:did_coc_loaded')
augroup cocgroup
  autocmd!
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
endif

func s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif(index(['man'], &filetype) >= 0)
    execute 'Man '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunc

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

nnoremap <C-e> :call CocActionAsync('diagnosticNext', 'error')<cr>

" Show all diagnostics
" nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>

" <Plug> 需要使用 nmap
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)

nmap <silent> gy <Plug>(coc-type-definition)
" 常用 gi 跳转到上次编辑的位置，使用 gl 跳转 implementation
nmap <silent> gl <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Find symbol of current document.
nnoremap <silent><nowait> go  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> gO  :<C-u>CocList -I symbols<cr>

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call   CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call   CocAction('runCommand', 'editor.action.organizeImport')

let g:coc_snippet_next = '<tab>'
"let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'


let g:floaterm_width  = 0.8
let g:floaterm_height = 0.8
hi default link FloatermBorder Special
nnoremap <silent> <leader>t :FloatermToggle<CR>
tnoremap <silent> <leader>t <C-\><C-n>:FloatermToggle<CR>


" }}}
" ==================== hotkey ==================== {{{

" quick insert date
"nnoremap <leader>id "=strftime("%Y-%m-%d %H:%M:%S")<CR>P
"inoremap <leader>id <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
"nnoremap <leader>iD "=strftime('%s')<CR>P
"inoremap <leader>iD <C-R>=strftime('%s')<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
" 使用: vipga*| 格式化 markdown 表格
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)

" Align GitHub-flavored Markdown tables
" 使用: vip,\ 或者 vip,| 格式化 markdown 表格
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
au FileType markdown vmap <Leader><Bar> :EasyAlign*<Bar><Enter>
" 需要先激活 :EasyAlign 即进入 EasyAlign 命令行模式，在普通模式下不能直接完成全部映射


nnoremap <leader>gb :TigBlame <CR>

" signify-mappings
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)
nmap <leader>gJ 9999<leader>gj
nmap <leader>gK 9999<leader>gk

" }}}
" ==================== indent ==================== {{{

" editorconfig 更像是一个社区标准
" 缩进应该以 editorconfig 配置为准，不同项目允许使用不同的缩进，
" 尤其是在多个开源项目之间切换时，同一编程语言的不同项目的作者，对缩进的实际使用也不一样

" 打开文件时检测实际缩进使用的空格数量
autocmd BufReadPost * autocmd BufEnter <buffer=abuf> ++once silent DetectIndent
autocmd BufNewFile * autocmd BufWritePost <buffer=abuf> ++once silent DetectIndent
nnoremap <leader>id :DetectIndent<CR>
nnoremap <leader>it :IndentTabs<CR>
nnoremap <leader>i2 :IndentSpaces 2<CR>
nnoremap <leader>i4 :IndentSpaces 4<CR>

" }}}

" https://github.com/Rican7/dotfiles/blob/master/.vim/plugin/fzf.vim#L49-L76
" Function to prevent FZF commands from opening in functional buffers
"
" See: https://github.com/junegunn/fzf/issues/453
" TODO: Remove once this workaround is no longer necessary.
function! FZFOpen(cmd)
    " Define the functional buffer types that we want to not clobber
    let functional_buf_types = ['quickfix', 'help', 'nofile', 'terminal']

    " If more than 1 window, and buffer type is not one of the functional types
    if winnr('$') > 1 && (index(functional_buf_types, &bt) >= 0)
        " Find all 'normal' (not functional) buffer windows
        let norm_wins = filter(range(1, winnr('$')),
                    \ 'index(functional_buf_types, getbufvar(winbufnr(v:val), "&bt")) == -1')

        " Grab the first one that we can use
        let norm_win = !empty(norm_wins) ? norm_wins[0] : 0

        " Move to that window
        exe norm_win . 'winc w'
    endif

    " Execute the passed command
    exe a:cmd
endfunction


" ==================== fzf rg ==================== {{{
" 搜索模糊匹配相关（文件、内容关键字、Git、寄存器）
" brew install fzf ripgrep

" Disable fzf statusline
let g:fzf_statusline=0
let g:fzf_nvim_statusline=0
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>H :History<CR>
"nnoremap <leader>f :Files<CR>
nnoremap <leader>f :call FZFOpen(':Files')<CR>
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

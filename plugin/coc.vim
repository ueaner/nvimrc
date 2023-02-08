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
  \ 'coc-markmap',
  \ 'coc-floaterm'
  \ ]

  "\ 'coc-tabnine',
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

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" }}}

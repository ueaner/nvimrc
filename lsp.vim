lua << EOF
local nvim_lsp = require 'nvim_lsp';
-- require'nvim_lsp'.gopls.setup{}

-- Customize how to find the root_dir
nvim_lsp.gopls.setup {
  root_dir = nvim_lsp.util.root_pattern(".git");
}

-- nvim_lsp.gopls.setup({});

EOF

autocmd Filetype go,lua,php setl omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> ;dc <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ;df <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ;h  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ;i  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> ;s  <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> ;td <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> ;rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ;rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> ;p  <cmd>lua vim.lsp.buf.peek_definition()<CR>
nnoremap <silent> ;f  <cmd>lua vim.lsp.buf.formatting()<CR>


"call nvim_lsp#setup("gopls", {})

" $TERM_PROGRAM='Apple_Terminal'

set foldtext=""

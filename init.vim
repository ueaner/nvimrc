" nvim 0.5+
" disable
let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0
"let g:loaded_python3_provider = 0

" /usr/local/bin/python3 -m pip install --upgrade pip pynvim yapf jedi
let g:python3_host_prog = '/usr/local/bin/python3.9'

" filetype.lua
let g:do_filetype_lua = 1

" 把 ~/.vim 加入 runtimepath 使其可以加载其中的 plugin, after 等目录
"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"echomsg "before source vimrc"
"source ~/.vim/vimrc
"source vimrc

source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/general.vim
"source $HOME/.config/nvim/plugins_settings.vim
"source $HOME/.config/nvim/filetypes.vim
"source $HOME/.config/nvim/plugins/ultisnips.vim



lua << EOF
  require('g');
  -- require('a');
  --require('appearance');
  --require('settings');
  --require('mappings');
  -- https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/lua/config/lsp.lua
  --require('lsp');
 -- require('debugger');
  --require('treesitter');
--print("loading debug.lua")
EOF


" dap mappings
" ,da ,dc ,dd 可以定义为添加/删除/清除全部 breakpoint
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>do :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>ds :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>dB :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>dl :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
"nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
" start debug, 相当于 gdb 的 continue
nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
" run debug, run test, run exec
nnoremap <silent> <leader>dt :DlvTest<CR>
nnoremap <silent> <leader>de :DlvExec<CR>


let g:dap_virtual_text = v:true

" vim startup
" 1. 设置 'shell' 和 'term' 选项
" 2. 处理命令行参数
" 3. 根据环境变量和/或文件执行 Ex 命令，load-vimrc
" 4. 载入插件脚本 load-plugins
"    - :runtime! plugin/**/*.vim
"    - :runtime! runtimepath/after/**/*.vim
"    - :runtime! packpath/start/**/*.vim   找到则加入 runtimepath，并执行
"    - :runtime! packpath/after/**/*.vim   找到则执行
" 5. ...

"echomsg "after source vimrc"
"set signcolumn=yes

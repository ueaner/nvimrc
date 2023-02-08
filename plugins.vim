" ==================== plugins ==================== {{{
"
" plugin package extension component module bundle
"

" 自动安装 vim-plug 插件管理工具
"if empty(glob('~/.vim/autoload/plug.vim'))
"    silent !curl -flo ~/.vim/autoload/plug.vim --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" 插件存储路径 stdpath("data")
let g:packpath = $HOME . "/.cache/nvim/bundle"
if !isdirectory(g:packpath)
    call mkdir(g:packpath, 'p')
endif

" 插件列表
call plug#begin(g:packpath)

if isdirectory("/usr/local/opt/fzf")
    Plug '/usr/local/opt/fzf'
else
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
Plug 'junegunn/fzf.vim'

" Colors
Plug 'ueaner/molokai'       " colorscheme
Plug 'joshdick/onedark.vim' " colorscheme
Plug 'ueaner/template.vim'

" Browsing
Plug 'ap/vim-buftabline'
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/tagbar', { 'on':  'TagbarToggle' }
Plug 'junegunn/vim-peekaboo'         " 插入寄存器内容 :h i_CTRL-R

" Edit
" undo surround repeat
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'timakro/vim-yadi'                  " 缩进检测，自动设置符合当前文件内容的缩进规则
Plug 'editorconfig/editorconfig-vim'     " TODO: 缩进检测优先以 editorconfig 为准
"Plug 'unblevable/quick-scope' " Lightning fast left-right movement in Vim

" Git
Plug 'iberianpig/tig-explorer.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" Lang
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/jsonc.vim'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'junegunn/vim-markdown-toc', { 'for': 'markdown' }
" ,tm : toggle table for markdown
Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
let g:table_mode_corner='|'

Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
Plug 'isobit/vim-caddyfile', { 'for': 'caddyfile' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
"Plug 'jparise/vim-graphql'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" Lint

Plug 'yianwillis/vimcdoc'         " 中文文档

" Testing
"Plug 'buoto/gotests-vim'          " 生成 Go 测试代码
" Plug 'vim-test/vim-test'

" Debugging
" Plug 'puremourning/vimspector'
"Plug 'benmills/vimux'
" 和 tmux 交互使用终端调试，原生的 dlv；默认使用 vim 内置 terminal 调试
"let g:delve_use_vimux = 1

Plug 'ueaner/vim-delve', { 'for': 'go' }    " sebdah/vim-delve
let g:delve_enable_linenr_highlighting = 1
"let g:delve_backend = "native"

Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'

" Others
Plug 'chrisbra/Colorizer'
Plug 'mhinz/vim-startify'
Plug 'voldikss/vim-floaterm'      " float terminal
" Plug 'voldikss/vim-translator'
" " let g:translator_proxy_url = 'socks5://127.0.0.1:1080'
" let g:translator_default_engines = ['bing', 'youdao']

" :'<,'>Translate ZH -source=EN -command=translate_shell -parse_after=window -output=floating
Plug 'uga-rosa/translate.nvim'
" lua <<EOL
" require("translate").setup({
"     default = {
"         command = "deepl_pro",
"     },
"     preset = {
"         output = {
"             split = {
"                 append = true,
"             },
"         },
"     },
" })
" EOL

Plug 'feline-nvim/feline.nvim'


call plug#end()

" }}}

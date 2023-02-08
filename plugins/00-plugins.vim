echo expand("<sfile>")

" 自动安装 vim-plug 插件管理工具
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" 插件存储路径
" stdpath("data")
let g:packpath = $HOME . "/.cache/nvim/bundle"
if !isdirectory(g:packpath)
    call mkdir(g:packpath, 'p')
endif

" 插件列表
call plug#begin(g:packpath)

Plug 'mhinz/vim-startify'

" 搜索模糊匹配相关（文件、关键字）
" brew install fzf ripgrep
if isdirectory("/usr/local/opt/fzf")
    Plug '/usr/local/opt/fzf'
else
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
Plug 'junegunn/fzf.vim'

" Colors
Plug 'ueaner/molokai'
Plug 'bluz71/vim-nightfly-guicolors'
let g:nightflyTransparent = 1

Plug 'joshdick/onedark.vim'
" :h w18
let s:selection  = $COLOR_SELECTION
let s:line       = $COLOR_LINE
let s:gray       = $COLOR_GRAY
" 8 colors
let s:black   = $COLOR_BLACK
let s:red     = $COLOR_RED
let s:green   = $COLOR_GREEN
let s:yellow  = $COLOR_YELLOW
let s:blue    = $COLOR_BLUE
let s:magenta = $COLOR_MAGENTA
let s:cyan    = $COLOR_CYAN
let s:white   = $COLOR_WHITE
" Vim 支持 Named ANSI colors，看起来实际读取的值不是终端设置的值，应该是内部写死的。
" let s:black   = "black"
" let s:red     = "red"
" let s:green   = "green"
" let s:yellow  = "yellow"
" let s:blue    = "blue"
" let s:magenta = "magenta"
" let s:cyan    = "cyan"
" let s:white   = "white"

" for main branch
let g:onedark_color_overrides = {
  \ "red":            { "gui": s:red,       "cterm": "167",  "cterm16": "1"    },
  \ "green":          { "gui": s:green,     "cterm": "185",  "cterm16": "2"    },
  \ "yellow":         { "gui": s:yellow,    "cterm": "221",  "cterm16": "3"    },
  \ "blue":           { "gui": s:blue,      "cterm": "110",  "cterm16": "4"    },
  \ "purple":         { "gui": s:magenta,   "cterm": "182",  "cterm16": "5"    },
  \ "cyan":           { "gui": s:cyan,      "cterm": "115",  "cterm16": "6"    },
  \ "white":          { "gui": s:white,     "cterm": "254",  "cterm16": "15"   },
  \ "black":          { "gui": s:black,     "cterm": "234",  "cterm16": "0"    },
  \ "foreground":     { "gui": s:white,     "cterm": "253",  "cterm16": "NONE" },
  \ "background":     { "gui": "",          "cterm": "234",  "cterm16": "NONE" },
  \ "comment_grey":   { "gui": s:gray,      "cterm": "102",  "cterm16": "7"    },
  \ "gutter_fg_grey": { "gui": s:gray,      "cterm": "102",  "cterm16": "8"    },
  \ "menu_grey":      { "gui": s:line,      "cterm": "235",  "cterm16": "7"    },
  \ "cursor_grey":    { "gui": s:line,      "cterm": "235",  "cterm16": "0"    },
  \ "visual_grey":    { "gui": s:selection, "cterm": "236",  "cterm16": "8"    },
  \ "special_grey":   { "gui": s:selection, "cterm": "236",  "cterm16": "7"    },
  \ "vertsplit":      { "gui": s:black,     "cterm": "234",  "cterm16": "7"    },
\}

"augroup colorextend
"    autocmd!
"    " 背景透明
"    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white })
"    " 非活动窗口时
"    " 如果设置 cursor_grey 为 s:selection 可以配合 StatusLineNC bg s:line 使用
"    autocmd ColorScheme * call onedark#extend_highlight("StatusLineNC", { "bg": {"gui": s:line} })
"    " 需要先 set cursorline 启用高亮光标所在行的功能，然后是具体什么颜色
"    "autocmd ColorScheme * call onedark#extend_highlight("CursorLineNr", { "fg": {"gui": s:white} })
"augroup END

Plug 'ueaner/template.vim'
" 根据实际项目和文件内容动态设置缩进，配置 editorconfig 使用效果更佳
" Tomorrow-Night-Bright

" Browsing
Plug 'ap/vim-buftabline'
" https://github.com/Xuyuanp/yanil
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
" :CocList outline，依赖 ctags 需要更新 universal-ctags
" TODO: 开发基于 tree-sitter 的 outline, 可借助 fzf 做显示（或者 tagbar 做显示）
" brew install --HEAD universal-ctags
Plug 'preservim/tagbar', { 'on':  'TagbarToggle' }
" 插入模式下 <CTRL-R> 列出寄存器内容，输入寄存器标记即可插入相应的内容
Plug 'junegunn/vim-peekaboo'


" Edit
" undo surround repeat
Plug 'junegunn/vim-easy-align'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

Plug 'editorconfig/editorconfig-vim'

" 也可参考 vscode 的缩进检测算法 https://github.com/microsoft/vscode/blob/main/src/vs/editor/common/model/indentationGuesser.ts#L105
" 缩进检测
Plug 'timakro/vim-yadi'


" Git
Plug 'iberianpig/tig-explorer.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'



" Lang
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/jsonc.vim'

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'junegunn/vim-markdown-toc', { 'for': 'markdown' }
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
Plug 'isobit/vim-caddyfile', { 'for': 'caddyfile' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'


" Lint

" 中文文档
Plug 'yianwillis/vimcdoc'

" quick find
"Plug 'unblevable/quick-scope'


" Plug 'antoinemadec/coc-fzf'

" 多语言调试工具，大多是借用 vscode 的调试能力在 vim 下使用
" 或者尝试使用 gdbgui 来调试
" 不同的调试场景属于不同调试级别可以尝试使用不同的工具
" Plug 'puremourning/vimspector'

" Plug 'asenac/vim-opengrok'
" let g:opengrok_jar="~/Public/opengrok/opengrok-1.5.11/lib/opengrok.jar"

" 有时屏幕会跳动
"Plug 'junegunn/vim-slash'

" Testing
" 这个插件对于使用三方语言开发 vim 插件是一个很好的例子
"Plug 'ueaner/vim-http-client'
" let g:http_client_json_ft = 'json' " default Javascript
" 显示中文原始文本 todo 请求时中文会提示 latin-1 Python 编码问题
let g:http_client_json_escape_utf = 0
let g:http_client_focus_output_window = 0

"Plug 'vim-test/vim-test'
" 生成测试代码
Plug 'buoto/gotests-vim'


" Debugging

Plug 'benmills/vimux'
" 和 tmux 交互使用终端调试，原生的 dlv；默认使用 vim 内置 terminal 调试
"let g:delve_use_vimux = 1

"Plug 'sebdah/vim-delve'
Plug 'ueaner/vim-delve', { 'for': 'go' }
let g:delve_enable_linenr_highlighting = 1
"let g:delve_backend = "native"

" 内置的 $VIMRUNTIME/lua/vim/treesitter
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'

Plug 'chrisbra/Colorizer'
" float terminal
Plug 'voldikss/vim-floaterm'

call plug#end()


" :h group-name
" s:selection - s:black
" #252931 - #1e222a = #070707; 首先获取颜色差值，颜色差值除以2得到颜色中间值 #040404 偏移量
" #252931 - #040404 = #21252d; 再次相减得到区分近似背景值又可区分背景值的颜色
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
  \ "vertsplit":      { "gui": s:selection,     "cterm": "234",  "cterm16": "7"    },
\}

" 如果不想显示 VertSplit WinSeparator 使用 gui: s:black

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

"silent! colorscheme molokai
"silent! colorscheme Tomorrow-Night-Bright
silent! colorscheme onedark

hi default link BufTabLineActive          StatusLine
" statusline Diagnostic
exec printf("hi Diagnostic guifg=%s guibg=%s", $COLOR_RED, $COLOR_LINE)

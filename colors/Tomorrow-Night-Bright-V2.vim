" Tomorrow Night Bright - Full Colour and 256 Colour
" http://chriskempson.com
"
" Hex colour conversion functions borrowed from the theme "Desert256""
"
" https://github.com/jwilm/dotfiles/blob/master/vim/colors/Tomorrow-Night-Bright.vim
"
" 可以参考 molokai 对此高亮再次优化，如 = + - || 等符号未高亮
" 另，如以下是否可以直接糅合在 basic 高亮配置里
" call <SID>X("goDirective", s:magenta, "", "")
" call <SID>X("goDeclaration", s:magenta, "", "")
" call <SID>X("goStatement", s:magenta, "", "")
" call <SID>X("goConditional", s:magenta, "", "")
" call <SID>X("goConstants", s:orange, "", "")
" call <SID>X("goTodo", s:yellow, "", "")
" call <SID>X("goDeclType", s:blue, "", "")
" call <SID>X("goBuiltins", s:magenta, "", "")
" rg -i 'goDirective|goDeclaration|goStatement|goConditional|goConstants|goTodo|goDeclType|goBuiltins' ~/.cache/nvim/bundle/vim-go/syntax/go.vim /usr/local/opt/nvim/share/nvim/runtime/syntax/go.vim

" Default GUI Colours
" 此时默认为黑色，但是 signcolumn 等不显示设置为黑色时，不生效
" 背景色为空是透明，由 alacritty colors.primary.background 决定
let s:background = ""
let s:foreground = "#eaeaea" " white
let s:black000   = "#000000" " 为需要显示设置为 000 黑色的项使用
let s:selection  = "#232526" " fg+bg-> special_grey
let s:line       = "#2a2a2a" " bg -> cursor_grey, menu_grey
let s:comment    = "#7E8E91" " fg -> comment_grey
let s:window     = "#4d5057"

let s:black   = "#121212"
let s:red     = "#d54e53"
let s:green   = "#b9ca4a"
let s:yellow  = "#e7c547"
let s:blue    = "#7aa6da"
let s:magenta = "#c397d8" " purple
let s:cyan    = "#70c0b1" " aqua
let s:orange  = "#f78c6c"

" --color=bg:#000000,hl:#E6DB74,hl+:#F92672,fg+:#F8F8F2,bg+:#000000,info:#7E8E91,border:#000000,prompt:#7E8E91,pointer:#F92672,marker:#F92672,spinner:#E6DB74,header:#7E8E91"


" " Background and foreground
" let s:black      = '#011627'
" let s:white      = '#c3ccdc'
" " Variations of blue-grey
" let s:black_blue = '#081e2f'
" let s:dark_blue  = '#092236'
" let s:deep_blue  = '#0e293f'
" let s:slate_blue = '#2c3043'
" let s:regal_blue = '#1d3b53'
" let s:steel_blue = '#4b6479'
" let s:grey_blue  = '#7c8f8f'
" let s:cadet_blue = '#a1aab8'
" let s:ash_blue   = '#acb4c2'
" let s:white_blue = '#d6deeb'
" " Core theme colors
" let s:yellow     = '#e3d18a'
" let s:peach      = '#ffcb8b'
" let s:tan        = '#ecc48d'
" let s:orange     = '#f78c6c'
" let s:red        = '#fc514e'
" let s:watermelon = '#ff5874'
" let s:violet     = '#c792ea'
" let s:purple     = '#ae81ff'
" let s:indigo     = '#5e97ec'
" let s:blue       = '#82aaff'
" let s:turquoise  = '#7fdbca'
" let s:emerald    = '#21c7a8'
" let s:green      = '#a1cd5e'
" " Extra colors
" let s:cyan_blue  = '#296596'

" Clear highlights and reset syntax only when changing colorschemes.
hi clear
syntax reset

let g:colors_name = "Tomorrow-Night-Bright"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)
		let l:r = ("0x" . strpart(a:rgb, 1, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 3, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 5, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)
		if a:fg != ""
			exec "hi " . a:group . " guifg=" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
		if a:bg != ""
			exec "hi " . a:group . " guibg=" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
		endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun

	" Vim Highlighting
	call <SID>X("Normal", s:foreground, s:background, "") " onedark 背景不透明
	" call <SID>X("Normal", s:foreground, "NONE", "")
	call <SID>X("LineNr", s:comment, "", "") " onedark gutter_fg_grey
	call <SID>X("CursorLineNr", s:yellow, "", "") " onedark 空的
	call <SID>X("NonText", s:selection, "", "") " onedark special_grey
	call <SID>X("SpecialKey", s:selection, "", "") " onedark fg special_grey
	call <SID>X("Search", s:background, s:yellow, "")
	call <SID>X("TabLine", s:comment, s:black, "none") " onedark fg comment_grey
	call <SID>X("TabLineFill", "", "", "none")
	call <SID>X("TabLineSel", "", "", "none")
	call <SID>X("StatusLine", s:comment, s:black, "none") " onedark fg white bg cursor_grey
	call <SID>X("StatusLineNC", s:comment, s:selection, "none") " onedark fg comment_grey
	call <SID>X("VertSplit", s:black, "", "none") " onedark vertsplit
	call <SID>X("Visual", "", s:selection, "") " onedark fg visual_black bg visual_grey
	" call s:h("VisualNOS", { "bg": s:visual_grey }) " Visual mode selection when vim is "Not Owning the Selection". Only X11 Gui's gui-x11 and xterm-clipboard supports this.


	call <SID>X("Directory", s:blue, "", "")
	call <SID>X("ModeMsg", s:green, "", "")
	call <SID>X("MoreMsg", s:green, "", "")
	call <SID>X("Question", s:green, "", "")
	call <SID>X("WarningMsg", s:red, s:black, "bold")
	call <SID>X("MatchParen", "", s:selection, "") " onedark blue
	call <SID>X("Folded", "", s:line, "none") "  onedark comment_grey
	call <SID>X("FoldColumn", "", s:black, "")
	call <SID>X("ExtraWhitespace", "", s:red, "")
	if version >= 700
		call <SID>X("CursorLine", "", s:line, "none")
		call <SID>X("CursorColumn", "", s:line, "none")
		call <SID>X("PMenu", s:blue, s:line, "none") " onedark menu_grey
		call <SID>X("PMenuSel", s:foreground, s:selection, "none") " onedark blue
		" call s:h("PmenuSel", { "fg": s:black, "bg": s:blue }) " Popup menu: selected item.
		call <SID>X("PMenuSbar", s:foreground, s:selection, "none") " onedark bg special_grey
		call <SID>X("SignColumn", "", s:black000, "none")
	end
	if version >= 703
		call <SID>X("ColorColumn", "", s:line, "none")
	end

	" Standard Highlighting
	call <SID>X("Constant", s:orange, "", "")
	call <SID>X("String", s:green, "", "")

	call <SID>X("Comment", s:comment, "", "")
	call <SID>X("Todo", s:yellow, s:black, "none")
	call <SID>X("Title", s:comment, "", "")
	call <SID>X("Identifier", s:blue, "", "none")
	call <SID>X("Statement", s:magenta, "", "")
	call <SID>X("Conditional", s:magenta, "", "")
	call <SID>X("Repeat", s:magenta, "", "")
	call <SID>X("Function", s:blue, "", "")
	call <SID>X("Operator", s:cyan, "", "none")

	call <SID>X("Type", s:magenta, "", "none")
	call <SID>X("StorageClass", s:magenta, "", "none")
	call <SID>X("Structure", s:magenta, "", "")
	call <SID>X("Typedef", s:magenta, "", "")
	call <SID>X("Keyword", s:magenta, "", "")

	call <SID>X("Special", s:red, "", "")
	call <SID>X("SpecialChar", s:red, "", "")
	call <SID>X("Tag", s:red, "", "")
	call <SID>X("Delimiter", s:cyan, "", "")
	call <SID>X("SpecialComment", s:comment, "", "")
	call <SID>X("Debug", s:red, "", "")

	call <SID>X("PreProc", s:red, "", "none")
	call <SID>X("Define", s:orange, "", "none")
	call <SID>X("Include", s:orange, "", "")
	call <SID>X("Macro", s:red, "", "")
	call <SID>X("PreCondit", s:orange, "", "")
	"call <SID>X("Ignore", "666666", "", "")

	" Vim Highlighting
	call <SID>X("vimCommand", s:red, "", "none")

	" C Highlighting
	call <SID>X("cType", s:yellow, "", "")
	call <SID>X("cStorageClass", s:magenta, "", "")
	call <SID>X("cConditional", s:magenta, "", "")
	call <SID>X("cRepeat", s:magenta, "", "")

	" PHP Highlighting
	call <SID>X("phpVarSelector", s:red, "", "")
	call <SID>X("phpKeyword", s:magenta, "", "")
	call <SID>X("phpRepeat", s:magenta, "", "")
	call <SID>X("phpConditional", s:magenta, "", "")
	call <SID>X("phpStatement", s:magenta, "", "")
	call <SID>X("phpMemberSelector", s:foreground, "", "")

	" Ruby Highlighting
	call <SID>X("rubySymbol", s:red, "", "")
	call <SID>X("rubyConstant", s:orange, "", "")
	call <SID>X("rubyAccess", s:yellow, "", "")
	call <SID>X("rubyAttribute", s:blue, "", "")
	call <SID>X("rubyInclude", s:blue, "", "")
	call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
	call <SID>X("rubyCurlyBlock", s:foreground, "", "")
	call <SID>X("rubyStringDelimiter", s:green, "", "")
	call <SID>X("rubyConditional", s:magenta, "", "")
	call <SID>X("rubyRepeat", s:magenta, "", "")
	call <SID>X("rubyControl", s:magenta, "", "")
	call <SID>X("rubyException", s:magenta, "", "")
	call <SID>X("rubyDefine", s:magenta, "", "")
	call <SID>X("rubyClass", s:magenta, "", "")
	call <SID>X("rubyClassDeclaration", s:orange, "", "")
	call <SID>X("rubyArrayDelimiter", s:cyan, "", "")
	call <SID>X("rubyInterpolationDelimiter", s:cyan, "", "")
	call <SID>X("rubyCurlyBlockDelimiter", s:cyan, "", "")
	call <SID>X("rubyTodo", s:yellow, "", "bold")

	" Python Highlighting
	call <SID>X("pythonInclude", s:magenta, "", "")
	call <SID>X("pythonStatement", s:magenta, "", "")
	call <SID>X("pythonConditional", s:magenta, "", "")
	call <SID>X("pythonRepeat", s:magenta, "", "")
	call <SID>X("pythonException", s:magenta, "", "")
	call <SID>X("pythonFunction", s:blue, "", "")
	call <SID>X("pythonPreCondit", s:magenta, "", "")
	call <SID>X("pythonRepeat", s:cyan, "", "")
	call <SID>X("pythonExClass", s:orange, "", "")

	" JavaScript Highlighting
	call <SID>X("javaScriptBraces", s:foreground, "", "")
	call <SID>X("javaScriptFunction", s:magenta, "", "")
	call <SID>X("javaScriptConditional", s:magenta, "", "")
	call <SID>X("javaScriptRepeat", s:magenta, "", "")
	call <SID>X("javaScriptNumber", s:orange, "", "")
	call <SID>X("javaScriptMember", s:orange, "", "")
	call <SID>X("javascriptNull", s:orange, "", "")
	call <SID>X("javascriptGlobal", s:blue, "", "")
	call <SID>X("javascriptStatement", s:red, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:red, "", "")
	call <SID>X("htmlTagName", s:red, "", "")
	call <SID>X("htmlArg", s:red, "", "")
	call <SID>X("htmlScriptTag", s:red, "", "")

	" Diff Highlighting
	call <SID>X("diffAdded", s:green, "", "")
	call <SID>X("diffRemoved", s:red, "", "")
	call <SID>X("diffSubname", s:foreground, "", "")
	call <SID>X("DiffDelete", s:red, s:black, "")
	call <SID>X("DiffAdd", s:green, s:black, "")
	call <SID>X("DiffText", s:blue, s:black, "")
	call <SID>X("DiffChange", s:yellow, s:black, "")

	" Lua Highlighting
	call <SID>X("luaStatement", s:magenta, "", "")
	call <SID>X("luaRepeat", s:magenta, "", "")
	call <SID>X("luaCondStart", s:magenta, "", "")
	call <SID>X("luaCondElseif", s:magenta, "", "")
	call <SID>X("luaCond", s:magenta, "", "")
	call <SID>X("luaCondEnd", s:magenta, "", "")

	" Cucumber Highlighting
	call <SID>X("cucumberGiven", s:blue, "", "")
	call <SID>X("cucumberGivenAnd", s:blue, "", "")

	" Go Highlighting
	call <SID>X("goDirective", s:magenta, "", "")
	call <SID>X("goDeclaration", s:magenta, "", "")
	call <SID>X("goStatement", s:magenta, "", "")
	call <SID>X("goConditional", s:magenta, "", "")
	call <SID>X("goConstants", s:orange, "", "")
	call <SID>X("goTodo", s:yellow, "", "")
	call <SID>X("goDeclType", s:blue, "", "")
	call <SID>X("goBuiltins", s:magenta, "", "")

	" Rust highlighting
	call <SID>X("rustSigil", s:cyan, "", "")
	call <SID>X("rustAssert", s:red, "", "")
	call <SID>X("rustLifetime", s:red, "", "italic")
	call <SID>X("rustSelf", s:magenta, "", "")
	call <SID>X("rustModPathSep", s:orange, "", "")
	call <SID>X("rustTodo", s:yellow, "", "bold")

	call <SID>X("SpellBad", s:black000, s:red, "underline")


	call <SID>X("yamlKeyValueDelimiter", s:cyan, "", "")
	call <SID>X("yamlTodo", s:yellow, "", "bold")

	" Git Highlighting
	call <SID>X("gitcommitSelectedType", s:green, "", "")
	call <SID>X("gitcommitSelectedFile", s:foreground, "", "")
	call <SID>X("gitcommitDiscardedType", s:red, "", "")
	call <SID>X("gitcommitDiscardedFile", s:foreground, "", "")
	call <SID>X("gitcommitHeader", s:yellow, "", "")
	call <SID>X("gitcommitBranch", s:blue, "", "")
	call <SID>X("gitcommitSummary", s:magenta, "", "bold")
	call <SID>X("gitcommitUntrackedFile", s:comment, "", "")

	call <SID>X("mkdCode", s:magenta, "", "")
	call <SID>X("mkdListItem", s:cyan, "", "")
	call <SID>X("mkdLink", s:blue, "", "")
	call <SID>X("mkdURL", s:comment, "", "")
	call <SID>X("htmlH1", s:red, "", "")
	call <SID>X("htmlH2", s:orange, "", "")
	call <SID>X("htmlH3", s:orange, "", "")
	call <SID>X("htmlH4", s:orange, "", "")
	call <SID>X("htmlH5", s:orange, "", "")
	call <SID>X("htmlH6", s:orange, "", "")

	" Delete Functions
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number
endif

set background=dark

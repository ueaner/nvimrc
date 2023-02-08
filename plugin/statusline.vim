" statusline
let &statusline=" %{my#stl#paste()} %<%f%m %{my#stl#fn()} %= "
            \ . " %#Diagnostic#%{my#stl#diagnostic()}%* %{my#stl#clipboard()} %{&filetype} "
            \ . " %{&fileformat} | %(%{(empty(&fenc)?&enc:&fenc)} %)"
            \ . " %(%{my#stl#indent()} %) LN %4l/%-4.L COL %-3.c "

" nvim 0.8+
"let &winbar=" %f "

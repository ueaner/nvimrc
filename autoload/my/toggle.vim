" map -> closure
" func! my#toggle#list(name) abort
    " my#toggle#list += xxx

let my#toggle#list = {}

func! my#toggle#show(name) abort
    " name -> closure / ToggleItem#turnedON
    let toggles = {
        \ 'clipboard': strridx(&clipboard, 'unnamed') > -1,
        \ 'zoom': exists('t:zoomed') && t:zoomed,
        \ 'fold': &foldenable,
        \ 'paste': &paste,
        \ 'spell': &spell,
    \}

    if !has_key(toggles, a:name)
        echo printf("Warning: toggle could be either %s.", join(keys(toggles), "|"))
        return
    endif

    " 首字母大写: substitute(a:name, '^.', '\u&', '')
    echo printf("%s: %s", a:name, strpart("offon", 3 * toggles[a:name], 3))
endfunc



" :function Foo(arg)
" :  let i = 3
" :  return {x -> x + i - a:arg}
" :endfunction
" :let Bar = Foo(4)
" :echo Bar(6)
" <	5

" :function! Foo()
" :  let x = 0
" :  function! Bar() closure
" :    let x += 1
" :    return x
" :  endfunction
" :  return funcref('Bar')
" :endfunction
"
" :let F = Foo()
" :echo F()
" <				1 >
" :echo F()
" <				2 >
" :echo F()
" <				3

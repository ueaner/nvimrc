
" let vim_info = coc#util#vim_info()
" echo vim_info
" 可以查看下 nerdtree 的代码是否有相关实现
"
" 可用于针对项目的特定配置，如执行 run/test 时所需要的参数
"

function! s:project_root_patterns()
  let default_root_patterns = ['.git']

  if get(g:, 'coc_enabled', 0) != 1
    return default_root_patterns
  endif

  try
      let root_patterns = coc#util#root_patterns()
      return get(root_patterns, 'global', default_root_patterns)
  catch
  endtry

  return default_root_patterns
endfunction

if !exists('b:root_patterns')
  let b:root_patterns = s:project_root_patterns()
endif

function! ProjectrootGet()
  let fullpath = expand('%:p:h')
  for marker in b:root_patterns
    let pivot=fullpath
    while 1
      let prev=pivot
      let fn = pivot.(pivot == '/' ? '' : '/').marker
      echo fn
      if filereadable(fn) || isdirectory(fn)
        return pivot
      endif
      let pivot=fnamemodify(pivot, ':h')
      if pivot==prev
        break
      endif
    endwhile
  endfor
  return ''
endfunction


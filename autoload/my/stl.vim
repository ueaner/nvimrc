func my#stl#paste()
    return &paste ? 'PASTE ' : 'BUF #' . bufnr('%')
endfunc

func my#stl#fn()
    return get(b:,'coc_current_function','')
endfunc

func my#stl#clipboard()
    return strridx(&clipboard, "unnamed") > -1 ? 'clipboard |' : ''
endfunc

func my#stl#indent()
    return &expandtab ? 'SPACES ' . shiftwidth() : 'TABS'
endfunc

func my#stl#diagnostic() abort
    if !exists('g:did_coc_loaded')
        return
    endif

  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, '✖' . info['error'])
  endif
  "if get(info, 'warning', 0)
  "  call add(msgs, '⚠️' . info['warning'])
  "endif
  "Status
  return join(msgs, ' ')
endfunc


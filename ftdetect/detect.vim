au BufNewFile,BufRead *.service    set filetype=systemd

au BufRead,BufNewFile go.sum       set filetype=gosum
au BufRead,BufNewFile go.work.sum  set filetype=gosum
au BufRead,BufNewFile go.work      set filetype=gowork
au BufRead,BufNewFile go.mod       set filetype=gomod

au BufRead,BufNewFile *.mdx        set filetype=markdown.mdx

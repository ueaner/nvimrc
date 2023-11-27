au BufRead,BufNewFile *.service    setlocal ft=systemd

au BufRead,BufNewFile go.sum       setlocal ft=gosum
au BufRead,BufNewFile go.work.sum  setlocal ft=gosum
au BufRead,BufNewFile go.work      setlocal ft=gowork
au BufRead,BufNewFile go.mod       setlocal ft=gomod

au BufRead,BufNewFile *.mdx        setlocal ft=markdown.mdx

au BufRead,BufNewFile *.grpc       setlocal ft=grpc

au BufRead,BufNewFile */roles/*/tasks/*.yml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yml        setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/meta/*.yml            setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/hosts                 setlocal ft=cfg
au BufRead,BufNewFile */ansible/tasks/*.yml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/handlers/*.yml        setlocal ft=yaml.ansible
au BufRead,BufNewFile */playbooks/hosts               setlocal ft=cfg
au BufRead,BufNewFile */playbooks/tasks/*.yml         setlocal ft=yaml.ansible
au BufRead,BufNewFile */playbooks/handlers/*.yml      setlocal ft=yaml.ansible

" Toggle folds with the `zi` command
au BufRead,BufNewFile */lua/plugins/*.lua             setlocal foldlevel=1
au BufRead,BufNewFile */lua/*/plugins/*.lua           setlocal foldlevel=1

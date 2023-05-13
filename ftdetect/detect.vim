au BufNewFile,BufRead *.service    setlocal ft=systemd

au BufRead,BufNewFile go.sum       setlocal ft=gosum
au BufRead,BufNewFile go.work.sum  setlocal ft=gosum
au BufRead,BufNewFile go.work      setlocal ft=gowork
au BufRead,BufNewFile go.mod       setlocal ft=gomod

au BufRead,BufNewFile *.mdx        setlocal ft=markdown.mdx

au BufRead,BufNewFile */roles/*/tasks/*.yml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/tasks/*.yaml          setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yml        setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yaml       setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/meta/*.yml            setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/meta/*.yaml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/hosts                 setlocal ft=cfg
au BufRead,BufNewFile */playbooks/hosts               setlocal ft=cfg

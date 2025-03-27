au BufRead,BufNewFile *.service    setlocal ft=systemd

au BufRead,BufNewFile go.sum       setlocal ft=gosum
au BufRead,BufNewFile go.work.sum  setlocal ft=gosum
au BufRead,BufNewFile go.work      setlocal ft=gowork
au BufRead,BufNewFile go.mod       setlocal ft=gomod

au BufRead,BufNewFile *.mdx        setlocal ft=markdown.mdx

au BufRead,BufNewFile *.http       setlocal ft=http

au BufRead,BufNewFile *.grpc       setlocal ft=grpc

au BufNewFile,BufRead .env,.env.*  setlocal ft=dosini

au BufRead,BufNewFile .gitconfig.* setlocal ft=gitconfig

au BufRead,BufNewFile */roles/*/tasks/*.yml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yml        setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/meta/*.yml            setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/hosts                 setlocal ft=cfg
au BufRead,BufNewFile */ansible/tasks/*.yml           setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/handlers/*.yml        setlocal ft=yaml.ansible
au BufRead,BufNewFile */playbooks/hosts               setlocal ft=cfg
au BufRead,BufNewFile */playbooks/tasks/*.yml         setlocal ft=yaml.ansible
au BufRead,BufNewFile */playbooks/handlers/*.yml      setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/templates/*.j2        setlocal ft=jinja

" Toggle folds with the `zi` command
au BufRead,BufNewFile */lua/plugins/*.lua             setlocal foldlevel=1
au BufRead,BufNewFile */lua/*/plugins/*.lua           setlocal foldlevel=1

au BufRead,BufNewFile Caddyfile                       setlocal ft=caddyfile
au BufRead,BufNewFile *.Caddyfile,Caddyfile.*         setlocal ft=caddyfile

au BufRead,BufNewFile */etc/{nginx,openresty}/*       setlocal ft=nginx
au BufRead,BufNewFile */{nginx,openresty}/conf.d/*    setlocal ft=nginx
au BufRead,BufNewFile */{nginx,openresty}/*.conf      setlocal ft=nginx
au BufRead,BufNewFile */etc/*nginx*.conf              setlocal ft=nginx

au BufNewFile,BufRead */etc/man_db.conf               setlocal ft=manconf

au BufNewFile,BufRead *.xt                            setlocal ft=xt
au BufNewFile,BufRead *.trace,*.trace.*               setlocal ft=strace
au BufNewFile,BufRead *.strace,*.strace.*             setlocal ft=strace

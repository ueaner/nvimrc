安装 VIM 7.4 并支持 lua 和 python  或其他语言写的扩展。

#### 安装依赖

    # yum install ncurses-devel lua-devel python-devel cscope ctags git

如果需要支持 ruby 或其他语言写的扩展，请安装相应语言的开发包，并在 VIM 编译中添加相应的参数，
如: `--enable-rubyinterp`。

#### 下载 VIM 源码包

    # wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2

#### 编译安装 VIM

这里需要注意的是通过开启 `lua` 和 `python` 的支持, 来使用 lua 和 python 开发的插件。
如：[gundo], [YouCompleteMe] 等需要 python 支持, [neocomplete] 需要 lua 的支持。

    # tar xf vim-7.4.tar.bz2 -C /usr/local/src/
    # cd /usr/local/src/vim74/
    # ./configure --prefix=/usr/local/vim74 \
     --with-compiledby="ueaner" \
     --with-features=huge \
     --enable-fail-if-missing \
     --enable-multibyte \
     --enable-cscope \
     --enable-luainterp \
     --enable-pythoninterp \
     --enable-gui=no

    make -j8
    make install

使用 `./configure --help` 查看更多编译参数帮组。

* 现在可以通过 `/usr/local/vim74/bin/vim --version` 看到 `+lua` 和 `+python` 字样，表示成功。

如果需要重新编译，先执行：

    # rm -f src/auto/config.cache
    # make distclean

再把上述 `configure make make install` 来一遍。

#### 配置默认使用 vim74 版本

编辑或新建 `/etc/profile.d/vim.sh` 文件, 输入以下内容：

    if [ -n "$BASH_VERSION" -o -n "$KSH_VERSION" -o -n "$ZSH_VERSION" ]; then
      [ -x /usr/bin/id ] || return
      #ID=`/usr/bin/id -u`
      #[ -n "$ID" -a "$ID" -le 200 ] && return
      # for bash and zsh, only if no alias is already set
      alias vi >/dev/null 2>&1 || alias vi=/usr/local/vim74/bin/vim
    fi

运行 `. /etc/profile.d/vim.sh` 使之在当前终端生效，注销或重启永久生效。

#### 参考

    https://github.com/mikecanann/vim_config
    https://github.com/larrupingpig/vimgdb-for-vim7.4


[gundo]: https://github.com/sjl/gundo.vim
[YouCompleteMe]: https://github.com/Valloric/YouCompleteMe
[neocomplete]: https://github.com/Shougo/neocomplete.vim

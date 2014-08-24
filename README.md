## 编译安装 VIM 7.4 最新版本

#### 安装依赖

    # yum install ncurses-devel lua-devel python-devel cscope ctags git

#### 下载 VIM 源码包

    # wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2

#### 编译安装 VIM

这里主要需要注意的是开启 `lua` 和 `python` 的支持, 来支持使用 lua 和 python 开发的插件。
如：`[gundo]`, `[YouCompleteMe]` 等需要 python 支持, `[neocomplete]` 需要 lua 的支持。

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

如果需要重新编译，先执行：

    # rm -f src/auto/config.cache
    # make distclean

再把上述 `configure make make install` 来一遍。

#### 配置默认使用 vim74 版本

编辑 `/etc/profile.d/vim.sh` 文件, 注释第 3, 4 行, 编辑第 6 行 `alias vi=/usr/local/vim74/bin/vim`

    if [ -n "$BASH_VERSION" -o -n "$KSH_VERSION" -o -n "$ZSH_VERSION" ]; then
      [ -x /usr/bin/id ] || return
      #ID=`/usr/bin/id -u`
      #[ -n "$ID" -a "$ID" -le 200 ] && return
      # for bash and zsh, only if no alias is already set
      alias vi >/dev/null 2>&1 || alias vi=/usr/local/vim74/bin/vim
    fi

运行 `. /etc/profile.d/vim.sh` 使之生效。

#### 参考

    https://github.com/mikecanann/vim_config
    https://github.com/larrupingpig/vimgdb-for-vim7.4

## 配置 VIM

clone 本地址:

    git clone https://github.com/ueaner/vim.git

将 `.vimrc` 和 `.vim_plugin_config.vim` 两个文件放到 home 目录下。

#### 插件列表一览

    gmarik/Vundle.vim
    tomasr/molokai
    bling/vim-airline
    kien/ctrlp.vim
    shougo/neocomplete.vim
    tpope/vim-surround
    mhinz/vim-signify
    justinmk/vim-sneak
    easygrep
    Shougo/neosnippet
    Shougo/neosnippet-snippets
    zhisheng/visualmark.vim
    scrooloose/syntastic
    majutsushi/tagbar
    stanangeloff/php.vim
    nathanaelkane/vim-indent-guides
    scrooloose/nerdcommenter
    tpope/vim-markdown
    mattn/emmet-vim
    elzr/vim-json
    tyru/open-browser.vim

插件地址都在 github 上。

#### 安装插件

我这里使用的 `Vundle` 来管理 VIM 插件，你也可以选用 [pathogen] 等相关功能的插件来管理你的 VIM 插件。

打开 vim, 命令行执行：

    :PluginInstall

等待少许时间, 你的插件就自动安装完成了，现在使用 vim 打开一个文件，焕然一新。享受的你的开发旅程吧。

#### 互动

如果有任何关于 VIM 或本文档的疑问，或者好的建议，好的 VIM 插件或配置，关于 VIM 的交流...

你都可以：

* 发 [issues],
* 发邮件到 ueaner at gmail.com
* fork 本项目

感谢您阅读完本文档。

[gundo]: https://github.com/sjl/gundo.vim
[YouCompleteMe]: https://github.com/Valloric/YouCompleteMe
[neocomplete]: https://github.com/Shougo/neocomplete.vim
[pathogen]: http://github.com/tpope/vim-pathogen
[issues]: https://github.com/ueaner/vim/issues

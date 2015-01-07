安装 VIM 7.4 并支持 lua 和 python  或其他语言写的扩展。

#### Mac 下

    $ brew install vim --with-lua --with-luajit

#### Windows 下

    ftp://ftp.vim.org/pub/vim/pc/gvim74.exe

**以下为 CentOS 下的安装**。

#### 安装依赖

    # yum install ncurses-devel lua-devel python-devel cscope ctags git

如果需要支持 ruby 或其他语言写的扩展，请安装相应语言的开发包，并在 VIM 编译中添加相应的参数，
如: `--enable-rubyinterp`。

#### 下载 VIM 源码包

到 http://ftp.debian.org/debian/pool/main/v/vim/ 下载最新版本的 orig 包，
这里包含了 vim 7.4 版本很多不存在的 patches。我这里下载到的最新版本是 7.4.488。

    # wget http://ftp.debian.org/debian/pool/main/v/vim/vim_7.4.488.orig.tar.gz

#### 编译安装 VIM

这里需要注意的是通过开启 `lua` 和 `python` 的支持, 来使用 lua 和 python 开发的插件。
如：[gundo], [YouCompleteMe] 等需要 python 支持, [neocomplete] 需要 lua 的支持。

    # tar xf vim_7.4.488.orig.tar.gz
    # cd vim-7.4.488/
    # ./configure --prefix=/usr \
     --with-compiledby="ueaner" \
     --with-features=huge \
     --enable-fail-if-missing \
     --enable-multibyte \
     --enable-cscope \
     --enable-luainterp \
     --enable-pythoninterp \
     --enable-gui=no

    make -j4
    make install

使用 `./configure --help` 查看更多编译参数帮组。

* 现在可以通过 `vim --version` 看到 `+lua` 和 `+python` 字样，表示成功。

如果需要重新编译，先执行：

    # rm -f src/auto/config.cache
    # make distclean

再把上述 `configure make make install` 来一遍。

如果有新版本可以直接覆盖编译。

#### 参考

    https://github.com/mikecanann/vim_config
    https://github.com/larrupingpig/vimgdb-for-vim7.4


[gundo]: https://github.com/sjl/gundo.vim
[YouCompleteMe]: https://github.com/Valloric/YouCompleteMe
[neocomplete]: https://github.com/Shougo/neocomplete.vim

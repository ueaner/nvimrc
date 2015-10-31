安装 VIM 7.4 并支持 lua 和 python  或其他语言写的扩展。

#### Mac 下

    $ brew install vim --with-lua --with-luajit

#### Windows 下

    ftp://ftp.vim.org/pub/vim/pc/gvim74.exe
    如果需要的 lua，python 等语言支持的, 请查看 http://vim.wikia.com/wiki/Where_to_download_Vim 这个页面, 
    有提供相应的 dll 文件。

**以下为 CentOS 下的安装**。

#### 安装依赖

    # yum install ncurses-devel lua-devel python-devel cscope ctags git gcc

如果需要支持 ruby 或其他语言写的扩展，请安装相应语言的开发包，并在 VIM 编译中添加相应的参数，
如: `--enable-rubyinterp`。

#### 下载 VIM 源码包

    # git clone https://github.com/vim/vim.git

#### 编译安装 VIM

这里需要注意的是通过开启 `lua` 和 `python` 的支持, 来使用 lua 和 python 开发的插件。
如：[gundo], [YouCompleteMe] 等需要 python 支持, [neocomplete] 需要 lua 的支持。

    # cd vim/
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

此 VIM 配置，包括了：

* 界面主题
* 插件管理
* 文件备份
* buffers & windows
* 文本和缩进
* 状态条
* 键映射
* 杂项
* 辅助函数

所使用的插件列表：

* [gmarik/Vundle.vim]
* [tomasr/molokai]
* [bling/vim-airline]
* [kien/ctrlp.vim]
* [shougo/neocomplete.vim]
* [tpope/vim-surround]
* [mhinz/vim-signify]
* [justinmk/vim-sneak]
* [easygrep]
* [Shougo/neosnippet]
* [Shougo/neosnippet-snippets]
* [zhisheng/visualmark.vim]
* [scrooloose/syntastic]
* [majutsushi/tagbar]
* [stanangeloff/php.vim]
* [nathanaelkane/vim-indent-guides]
* [scrooloose/nerdcommenter]
* [tpope/vim-markdown]
* [mattn/emmet-vim]
* [elzr/vim-json]
* [tyru/open-browser.vim]

如果你的 VIM 版本 < 7.3 或不支持 `lua` 和 `python`，请查看 [INSTALL.md] 文件，进行安装。

#### 使用

    git clone https://github.com/ueaner/vim.git ~/.vim

#### 安装插件

我这里使用的 [Vundle] 来管理 VIM 插件，你也可以选用 [pathogen] 等相关功能的插件来管理你的 VIM 插件。

安装 Vundle 插件:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

打开 vim, 命令行执行：

    :PluginInstall

等待少许时间, 你的插件就自动安装完成了，现在使用 vim 打开一个文件，焕然一新。享受的你的开发旅程吧。

#### 交流

如果有任何关于 VIM 或本文档的疑问，或者好的建议，好的 VIM 插件或配置，关于 VIM 的交流...

你都可以：

* 发 [issues],
* 发邮件到 ueaner at gmail.com
* fork 本项目

感谢您阅读完本文档。

[INSTALL.md]: https://github.com/ueaner/vim/blob/master/INSTALL.md "安装 VIM7.4"

[pathogen]: http://github.com/tpope/vim-pathogen
[Vundle]: https://github.com/gmarik/Vundle.vim
[issues]: https://github.com/ueaner/vim/issues

[gmarik/Vundle.vim]: https://github.com/gmarik/Vundle.vim
[tomasr/molokai]: https://github.com/tomasr/molokai
[bling/vim-airline]: https://github.com/bling/vim-airline
[kien/ctrlp.vim]: https://github.com/kien/ctrlp.vim
[shougo/neocomplete.vim]: https://github.com/shougo/neocomplete.vim
[tpope/vim-surround]: https://github.com/tpope/vim-surround
[mhinz/vim-signify]: https://github.com/mhinz/vim-signify
[justinmk/vim-sneak]: https://github.com/justinmk/vim-sneak
[easygrep]: https://github.com/easygrep
[Shougo/neosnippet]: https://github.com/Shougo/neosnippet
[Shougo/neosnippet-snippets]: https://github.com/Shougo/neosnippet-snippets
[zhisheng/visualmark.vim]: https://github.com/zhisheng/visualmark.vim
[scrooloose/syntastic]: https://github.com/scrooloose/syntastic
[majutsushi/tagbar]: https://github.com/majutsushi/tagbar
[stanangeloff/php.vim]: https://github.com/stanangeloff/php.vim
[nathanaelkane/vim-indent-guides]: https://github.com/nathanaelkane/vim-indent-guides
[scrooloose/nerdcommenter]: https://github.com/scrooloose/nerdcommenter
[tpope/vim-markdown]: https://github.com/tpope/vim-markdown
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[elzr/vim-json]: https://github.com/elzr/vim-json
[tyru/open-browser.vim]: https://github.com/tyru/open-browser.vim

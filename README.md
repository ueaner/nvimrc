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

如果你的 VIM 版本 < 7.3 或不支持 `lua` 和 `python`，请查看 [INSTALL_VIM.md] 文件，进行安装。

#### 使用

    git clone https://github.com/ueaner/vim.git ~/.vim

#### 安装插件

我这里使用的 [Vundle] 来管理 VIM 插件，你也可以选用 [pathogen] 等相关功能的插件来管理你的 VIM 插件。

安装 Vundle 插件:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

打开 vim, 命令行执行：

    :PluginInstall

等待少许时间, 你的插件就自动安装完成了。

下面的操作是为了美化标签页和状态栏，如果你不想要或不支持，可以打开 `.vim/plugin/line.vim` 文件，
修改 `let g:airline_powerline_fonts = 1` 参数为 `0`。

#### 安装 Powerline Fonts

你可以在 [Powerline Patched Fonts](https://github.com/powerline/fonts) 选择自己喜欢的字体，
我这里使用的 `Source Code Pro for Powerline` 字体。

下载字体:

    curl -L "https://github.com/powerline/fonts/raw/master/SourceCodePro/Sauce%20Code%20Powerline%20Regular.otf" -o "Source Code Pro for Powerline.otf"

*Linux* 下安装字体：

    # mkdir -p /usr/share/fonts/PowerlineFonts
    # cp Source\ Code\ Pro\ for\ Powerline.otf /usr/share/fonts/PowerlineFonts/
    # cd /usr/share/fonts/PowerlineFonts/
    # mkfontscale
    # mkfontdir
    # fc-cache -f

*Mac* 下安装字体：

    $ mkdir -p ~/Library/Fonts/PowerlineFonts
    $ cp Source\ Code\ Pro\ for\ Powerline.otf ~/Library/Fonts/PowerlineFonts/

这样就可以了，Mac 下会自动识别放在 `~/Library/Fonts/` 子目录下的字体文件。

#### 设置终端字体

对于 gvim 和 macvim 是基于自己的 ui，可以通过配置 guifont 控制字体显示象形符号，
而 vim 基于终端运行，所以终端的字体的设置决定了 vim 的标签页和状态条中的象形符号是否可以正常显示。

打开你所用的终端，将字体设置为你刚安装 Powerline 字体。

现在打开你的 vim，无论是本地的还是远程的，焕然一新。享受的你的开发之旅吧。

来张图：
![截图](preview.png)

#### 交流

如果有任何关于 VIM 或本文档的疑问，或者好的建议，好的 VIM 插件或配置，关于 VIM 的交流...

你都可以：

* 发 [issues],
* 发邮件到 ueaner at gmail.com
* fork 本项目

感谢您阅读完本文档。

[INSTALL_VIM.md]: INSTALL_VIM.md "安装 VIM7.4"

[pathogen]: http://github.com/tpope/vim-pathogen
[Vundle]: https://github.com/gmarik/Vundle.vim
[issues]: https://github.com/ueaner/vim/issues

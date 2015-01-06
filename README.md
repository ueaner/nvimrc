 个人 Vim 配置.

![截图](preview.png)

#### 使用

    git clone https://github.com/ueaner/vim.git ~/.vim

#### 安装插件

安装 [Vundle](https://github.com/gmarik/Vundle.vim) 插件管理工具:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

打开 vim, 命令行执行：

    :PluginInstall

等待少许时间, Vim 常用 插件就自动安装完成了。

#### 安装 Powerline Fonts

这里使用的 `Source Code Pro for Powerline` 字体。
可以在 [Powerline Patched Fonts](https://github.com/powerline/fonts) 选择更多字体.

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
而 vim 基于终端运行，所以终端字体的设置决定了 vim 的标签页和状态条中的象形符号是否可以正常显示
(无论是在本地的还是远程连接的)。

打开终端，将字体设置为刚安装 Powerline 字体即可。

安装并使用 Powerline Fonts 字体
-----------

如果我们使用 airline、lightline 等状态条插件的话，通常需要使用 Powerline Fonts 字体，使状态条看着更过瘾。

#### 安装 Powerline Fonts

这里使用的 `Source Code Pro for Powerline` 字体。
可以在 [Powerline Patched Fonts](https://github.com/powerline/fonts) 选择更多字体.

下载字体:

    curl -L "https://github.com/powerline/fonts/raw/master/SourceCodePro/Source%20Code%20Pro%20for%20Powerline.otf" -o "Source Code Pro for Powerline.otf"

*Linux* 下安装字体：

    # mkdir -p ~/.fonts/PowerlineFonts
    # cp Source\ Code\ Pro\ for\ Powerline.otf ~/.fonts/PowerlineFonts
    # fc-cache -f -v ~/.fonts/

如果让所有用户可用, 则放在 `/usr/share/fonts/<somedir>/` 目录下, 执行 `fc-cache -f /usr/share/fonts/<somedir>/` 即可.

*Mac* 下安装字体：

    $ mkdir -p ~/Library/Fonts/PowerlineFonts
    $ cp Source\ Code\ Pro\ for\ Powerline.otf ~/Library/Fonts/PowerlineFonts/

这样就可以了，Mac 下会自动识别放在 `~/Library/Fonts/` `子目录`下的字体文件。[参见](http://support.apple.com/en-us/HT201722).

*Windows* 下安装字体：

    直接将字体拖到 `C:\WINDOWS\Fonts` 下.

#### 设置终端字体

对于 gvim 和 macvim 是基于自己的 ui，可以通过配置 guifont 控制字体显示象形符号，
而 vim 基于终端运行，所以终端字体的设置决定了 vim 的标签页和状态条中的象形符号是否可以正常显示
(无论是在本地的还是远程连接的)。

打开终端，将字体设置为刚安装 Powerline 字体即可。

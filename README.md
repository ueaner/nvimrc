![截图](https://i.imgur.com/ScFMDYe.png)

#### 使用

macOS/Linux:

    git clone https://github.com/ueaner/vimrc.git ~/.vim

windows cmd.exe:

    git clone https://github.com/ueaner/vimrc.git %USERPROFILE%\vimfiles

`7.4 之前的版本`需要做个软链:

    macOS/Linux: ln -s ~/.vim/vimrc ~/.vimrc

    windows: 创建快捷方式：%USERPROFILE%\_vimrc

#### 自定义本地配置

通过编辑 `~/.vim/local/vimrc` 文件自定义本地配置，编辑之后在 vim 命令行中执行
`:source ~/.vim/local/vimrc` ，或者重新打开 vim使配置生效。

#### 插件管理

这里以 [Vundle] 插件管理器为例:

首先下载 Vundle 插件管理器：

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

编辑 `~/.vim/local/vimrc` 文件，添加以下内容：

    filetype off                  " required

    set rtp+=$VIMHOME/bundle/Vundle.vim
    " 插件存储目录
    call vundle#begin($VIMHOME . "/bundle")

    Plugin 'VundleVim/Vundle.vim'

    " 插件列表
    Plugin 'ueaner/molokai'
    Plugin 'ap/vim-buftabline'
    Plugin 'scrooloose/nerdtree'

    " if has('nvim')
    "     Plugin 'Shougo/deoplete.nvim'
    " elseif has('lua')
    "     Plugin 'Shougo/neocomplete.vim'
    " endif
    " Plugin 'kshenoy/vim-signature'
    " Plugin 'majutsushi/tagbar'
    " ...

    call vundle#end()            " required

    " 插件配置 ...

Vim 命令行执行安装:

    :PluginInstall

等待少许时间, 配置的插件就安装完成了。

#### Vim 与 Tmux 共享剪切板

以 [Vundle] 插件管理器为例。

编辑 `~/.vim/local/vimrc` 文件，添加以下插件：

    Plugin 'tmux-plugins/vim-tmux-focus-events'
    Plugin 'roxma/vim-tmux-clipboard'

Vim 命令行执行安装:

    :PluginInstall

编辑 `~/.tmux.conf` 添加对应的配置：

    set -g focus-events on

重新打开 tmux 和 vim 即可。


[Vundle]: https://github.com/VundleVim/Vundle.vim

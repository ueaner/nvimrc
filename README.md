![截图](https://i.imgur.com/R6rnKhO.png)

#### 使用

macOS/Linux:

    git clone https://github.com/ueaner/vimrc.git ~/.vim

windows cmd.exe:

    git clone https://github.com/ueaner/vimrc.git %USERPROFILE%\vimfiles

`7.4 之前的版本`需要做个软链:

    macOS/Linux: ln -s ~/.vim/vimrc ~/.vimrc

    windows: 创建快捷方式：%USERPROFILE%\_vimrc

#### 自定义本地配置

通过编辑 `local/local.vimrc` 文件自定义本地配置，编辑之后重新打开
vim，或者在 vim 命令行中执行 `:source local/local.vimrc` 使配置生效。

#### 插件管理

通过编辑 `local/local.bundles.vim` 文件自定义插件配置。

这里以 [Vundle](https://github.com/VundleVim/Vundle.vim) 插件管理器为例:

首先下载 Vundle 插件管理器：

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

编辑 `local/local.bundles.vim` 文件内容为：

    filetype off                  " required

    set rtp+=$VIMHOME/bundle/Vundle.vim
    " 插件存储目录
    call vundle#begin($VIMHOME . "/bundle")

    Plugin 'VundleVim/Vundle.vim'

    " 插件列表
    Plugin 'ueaner/molokai'
    Plugin 'ap/vim-buftabline'
    Plugin 'scrooloose/nerdtree'

    " Plugin 'Shougo/neocomplete.vim'
    " Plugin 'kshenoy/vim-signature'
    " Plugin 'majutsushi/tagbar'
    " ...

    call vundle#end()            " required

    " 插件配置 ...

Vim 命令行执行安装:

    :PluginInstall

等待少许时间, 配置的插件就安装完成了。

 个人 Vim 配置.

![截图](preview.png)

#### 使用

    git clone https://github.com/ueaner/vim.git ~/.vim
    git clone https://github.com/ueaner/vim.git "C:\Documents and Settings\<your_username>\vimfiles"

`7.4 之前的版本`需要做个软链:

    ln -s ~/.vim/vimrc ~/.vimrc
    创建快捷方式 :)

#### 安装插件

安装 [Vundle](https://github.com/gmarik/Vundle.vim) 插件管理工具:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    git clone https://github.com/gmarik/Vundle.vim.git "C:\Documents and Settings\<your_username>\vimfiles\bundle\Vundle.vim"

命令行执行, 开始安装插件:

    vim +PluginInstall +qall

等待少许时间, Vim 常用插件就自动安装完成了。

#!/usr/bin/env bash

# 安装 fzf rg
brew install fzf ripgrep fd bat
brew install universal-ctags

# 安装 vim-plug 插件管理
if [ -e "$HOME"/.vim/autoload/plug.vim ]; then
  vim -E -s +PlugUpgrade +qa
else
  curl -fLo "$HOME"/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 安装插件
vim +PlugInstall +qall

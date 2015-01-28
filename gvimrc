" gvim/macvim 设置, has('gui_running')

" Powerline 字体
if has('gui_gtk')
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 12
elseif has('mac')
    set guifont=Sauce\ Code\ Powerline:h12
elseif has('win32')
    set guifont=Sauce\ Code\ Powerline:h12:cANSI
endif

" 信息提示编码
language message zh_CN.UTF-8

" 菜单乱码
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim

set guioptions-=m " 隐藏菜单栏
set guioptions-=T " 隐藏工具栏
set guioptions-=r " 隐藏右侧滚动条
set guioptions-=l " 隐藏左侧滚动条
set guioptions-=R " 隐藏垂直窗口右侧滚动条
set guioptions-=L " 隐藏垂直窗口左侧滚动条

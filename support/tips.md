疑难杂症

1. Tab 键

`:help keycodes` 终端绑定键：

    Ctrl-I      Tab
    Ctrl-[      Esc
    Ctrl-M      Enter
    Ctrl-H      Backspace

   inoremap 下允许映射 Tab，noremap 模式不允许映射 Tab

2. buffer 操作

gB/gb(bp, bn) 类似 tab 的 gT/gt  `考虑是否使用 ctrl-n ctrl-m 组合`
bf/bl 第一个和最后一个 buffer
,, e# 切换上一个 buffer
bd 删除一个 buffer
b <pattern><tab> 模糊匹配 buffer, CTRL-N/CTRL-P 选择buffer，回车执行 buffer 切换

e <filepath> 编辑新的文件

3. 跳转表

CTRL-I(进入in) / CTRL-O(回出out)

4. CTRL-P

CTRL-K / CTRL-J 上下翻滚选项，CTRL-J 被 tmux 占用
CTRL-P / CTRL-N 前后翻历史记录

5. tmux prefix 选取问题 CTRL-O

    双手触发 prefix 键的便捷性，需要选择 CTRL + 右手键区
    Y 太远了，U 翻页，I,O 跳转表，HJKL上下左右,
    NP自定提示变更选项和CTRL-P插件，CTRL-M是回车

    CTRL+非字母无法映射

    右手键区全部在用，只能找VIM中使用最不频繁的影响最小的键

    CTRL-J 按键方便，上下切窗口使用较少


6. 跳转

屏内跳转：H M L
页跳转：CTRL-U CTRL-D
行首尾：gg G















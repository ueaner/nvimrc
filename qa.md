
当使用直接打开一个新的文件时，由于文件未写入磁盘，会报这个错误：

[coc.nvim] Jedi error: Traceback (most recent call last):
  File "completion.py", line 670, in watch
    response = self._process_request(rq)
  File "completion.py", line 592, in _process_request
    jedi.Script(
  File "/usr/local/lib/python3.8/site-packages/jedi/api/__init__.py", line 163, in __init__
    with open(path, 'rb') as f:
FileNotFoundError: [Errno 2] No such file or directory: '/private/tmp/a.py'


$ brew install luarocks
:CocInstall coc-lua


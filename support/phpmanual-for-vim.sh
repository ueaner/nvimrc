#!/bin/sh
# PHP 手册转 Vim 手册脚本
# 依赖：php, w3m(使用 brew, apt-get, yum 等包管理工具一般可直接安装)
# 使用：sh phpmanual-for-vim.sh
# @author ueaner#gmail.com

script_path=`pwd`

# 定义变量
tmp_workspace=/tmp/tmp_workspace            # 临时工作区目录
lang=${1:-"en"}                             # PHP 手册语言, zh 中文暂不支持，K 查看时会出现乱码
php_manual_tar=php_manual_${lang}.tar.gz    # PHP 手册 tar 包名称
handler_manual_file=${script_path}/doc.php  # PHP 手册转 Vim 手册程序名称
php_manual_dir=~/.vim/local/phpmanual/            # PHP 手册存放于 Vim runtimepath 的目录

# 依赖检查
# @link http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if ! which w3m >/dev/null; then
    echo Please install w3m
    exit 1
fi

# 创建并转到临时工作区目录
mkdir -p ${tmp_workspace}
cd ${tmp_workspace}

# 下载 PHP 手册
if [ ! -f ${php_manual_tar} ]; then
    curl -L http://cn2.php.net/distributions/manual/${php_manual_tar} -o ${php_manual_tar}
fi

# 避免下载中断，退出执行
if [ ! -f ${php_manual_tar} ]; then
    echo Download Error
    exit 1
fi

# 解压 PHP 手册 tar 包
tar xf ${php_manual_tar}

# 执行转换
php ${handler_manual_file} ${tmp_workspace}/php-chunked-xhtml/

# tags sort
if [ -f doc/tags ]; then
    vim +%sort +wq doc/tags
fi

mkdir -p ${php_manual_dir}
mv doc/ ${php_manual_dir}

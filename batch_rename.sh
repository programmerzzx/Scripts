#!/bin/bash

# 批量重命名文件

read -p "输入源目录(请一次正确输入目录): " src_dir

# 删除最后一个斜杠
src_dir=${src_dir%\/}

# 判断目录是否存在
if [ ! -d $src_dir ];
then
	echo "该目录不存在！"
	exit 2
fi

# 在 sed 中使用自定义变量要使用双引号(很谜)
read -p "输入正则表达式: " reg
read -p "输入替换内容: " replacement

for f in `ls $src_dir` ;
do
	new_filename=`echo $f | sed "s/$reg/$replacement/"`
	#echo $src_dir/$f $src_dir/$new_filename
	mv $src_dir/$f $src_dir/$new_filename
done


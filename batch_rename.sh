#!/bin/bash

# 批量重命名文件

src_dir='/d/video/老友记_第10季'
tar_dir='/f/老友记'

# 判断目录是否存在
if [[ ! -d $src_dir ]];
then
	echo "源目录不存在！"
	exit 2
fi

# 判断存放不存在则创建
if [[ ! -d $tar_dir ]];
then
	mkdir -p $tar_dir
	# exit 2
fi

# 在 sed 中使用自定义变量要使用双引号(很谜)
# reg='.*(S0.E.{2}).*'
reg='.*s\.(.*)\.中.*'
replacement='\1'
prefix='Friends_'
format='.mp4'

for f in `ls $src_dir` ;
do
	# toUpperCase
	typeset -u episode
	episode=`echo $f | sed -r "s/$reg/$replacement/"`
	new_file=$prefix$episode$format
	echo $src_dir/$f $tar_dir/$new_file	
	cp $src_dir/$f $tar_dir/$new_file	
done


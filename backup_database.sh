#!/bin/bash
# 备份数据库到 码云 私有仓库

# 指定数据库信息
mysql_user=root
mysql_password=root
database=badblog

# git 项目目录
git_dir=~/document/git/Backup


backup() {

	# 导出数据库数据
	# --dump-date 将导出时间添加至输出文件中, --skip-dump-date 关闭选项 ; 目的为判断 sql 文件是否有数据更变
	mysqldump -u$mysql_user -p$mysql_password $database --skip-dump-date > "$git_dir/$database.sql"

	# git 备份至码云私有仓库
	cd $git_dir

	# 判断数据是否 modified	
	git add $database.sql
	
	modified=`git status | grep modified`
	if [ -z "$modified" ];
	then
		echo "数据没有被修改过,退出备份"
		exit
	fi	

	git commit -m $database
	git push origin master -f

}

backup

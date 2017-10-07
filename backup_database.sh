#!/bin/bash
# 备份数据库到 码云 私有仓库

# 指定数据库信息
mysql_user=root
mysql_password=root
database=badblog

# git 项目目录
git_dir=~/document/git/Backup

# 备份函数
backup() {
	
	# 判断是否是 root 
	if [ $UID -ne 0 ];
	then
		echo "非 root 用户无法执行!"
		exit
	fi

	# 导出数据库数据 (没有指定用户名及密码是因为在 /etc/mysql/my.cnf 配置了用户名及密码 )
	# --dump-date 将导出时间添加至输出文件中, --skip-dump-date 关闭选项 ; 目的为判断 sql 文件是否有数据更变
	mysqldump -u$mysql_user -p$mysql_password $database --skip-dump-date > "$git_dir/$database.sql"

	# git 备份至码云
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
	git push origin master

}

backup

#!/bin/bash
# 备份数据库到 码云 私有仓库

read -p "输入要备份的数据:" database

# git 项目目录
git_dir=~/document/git/Backup

function backup() {
	# 导出数据库数据 (没有指定用户名及密码是因为在 /etc/mysql/my.cnf 配置了用户名及密码 )
	mysqldump $database > "$git_dir/$database.sql"

	# git 备份
	cd $git_dir
	git add *
	git commit -m $database
	git push origin master

}

for(( ; ; ));{
	backup
	# 每隔 1天 备份
	sleep 1d
}

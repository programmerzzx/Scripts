#!/bin/bash
# 备份数据库到 码云 私有仓库
database=badblog
git_dir=~/document/git/Backup

function backup() {

	# 导出数据库数据
	mysqldump $database > "$git_dir/$database.sql"

	# git 备份
	cd $git_dir
	git add *
	git commit -m $database
	git push origin master

}

#backup

for(( ; ; ));{
	backup
	# 每隔 1天 备份
	sleep 1d
}

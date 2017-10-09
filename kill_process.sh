#!/bin/bash
# 进程名
read -p "输入进程名: " pName

if [ -z $pName ];
then 
	echo "输入为空!!!"
	exit
fi

ps -ef | grep -i $pName | awk '{ print $2; }' | xargs kill -9
ps -ef | grep -i $pName


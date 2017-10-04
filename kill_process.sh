#!/bin/bash
# 输入进程名,终止进程
read -p "输入进程名: " pName

#echo $pName
ps -ef | grep -i $pName | awk '{ if(NR == 1) { print $2; } }' | xargs kill -9

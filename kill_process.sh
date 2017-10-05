#!/bin/bash
# 输入进程名,终止进程
read -p "输入进程名: " process

#echo $process
ps -ef | grep -i $process | awk '{ print $2; }' | xargs kill -9 
#ps -ef | grep -i $process | awk ' NR == 1 { print $2; }' | xargs kill -9 | grep -i $process

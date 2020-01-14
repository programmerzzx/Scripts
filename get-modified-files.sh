#!/bin/bash
# author zhongzx

# find recent modified files between tow git commits and then save to destination directory
# run `sh get-modified-file.sh` command on (Git?) Bash


# 文件最终保存目录
saveDir="$(pwd)/modified-files"
# 开始提交 hash 值
beginCommit='95933781'
# 截止提交 hash 值
endCommit='850c100f'

# 修改的文件
modifiedFiles=`git diff $beginCommit $endCommit --name-only`


# 当前目录
currentDir=`pwd`

for file in $modifiedFiles
do
    # 文件存在则复制到保存目录下
    sourceFile="$currentDir/$file"
    if [ -f $sourceFile ];then

        # 保存目录不存在则创建
        distFile="$saveDir/$file"
        # 截取目录
        distDir=${distFile%/*}
        if [ ! -d $distDir ];then
            # 创建目录
            mkdir -p $distDir
        fi

        # 复制
        echo '复制' $sourceFile ' 》》》》》》》 ' $distFile
        cp $sourceFile $distFile

    fi

done 

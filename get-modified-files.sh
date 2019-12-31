#!/bin/bash
# author zhognzx

# find recent modified files between tow git commits and save to destination directory


# 文件最终保存目录
saveDir='/e/gogs/fszqt/test-shell'
# 开始提交
beginCommit='6630888c'
# 截止提交
endCommit='193954c7'

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


#!/bin/bash
# SVN JavaWeb项目 两个版本之间提取增量更新文件

# 思路
# 1. 通过 svn diff 从 svn 项目获取更改文件列表
# 2. 找出对应的本地更改文件
# 3. 复制到目标文件夹

# 必须指定的参数
# svnProjectUrl       SVN项目地址
# localProjectDir     本地项目文件夹
# exportDir           目标文件夹
# startVersion        开始版本
# endVersion          结束版本

# ps
# 文件加路径分隔符为 /
# 如果从本地文件中获取修改文件则需要指定 exportFile 文件路径

#项目 svn 地址
svnProjectUrl=''

# 本地项目文件夹
# localProjectDir=''

# 导出文件夹
exportDir='E:/shell/test-fszqt2'

# 开始版本
startVersion=2788

# 结束版本; 默认是最新版本
endVersion=2798

# 导出文件
exportFile="$startVersion""-""$endVersion.txt"


# 找到 WEB-INF/classes 目录
function getClassesDir {
    local classesDir=`find $localProjectDir -type d -path '*/WEB-INF/classes' | tail -1`
    echo $classesDir
}

# 从 svn 中获取修改文件列表
function getDiffFilesFromSVN {
  local diffFiles=`svn diff -r $startVersion:$endVersion --summarize  $svnProjectUrl | awk '{ print $2 }' > $exportFile`
  echo $diffFiles
}

# 从本地文件中获取修改文件列表
function getDiffFilesFromLocal {
  local diffFiles=`cat $exportFile`
  echo $diffFiles
}

# 找出本地对应的修改文件列表
function getLocalChangeFiles {
    local diffFiles=$@
    local index=0
    local changeFileArray
    for file in $diffFiles;
    do
        local changeFile=`echo $file | sed s!$svnProjectUrl!$localProjectDir!`
        changeFileArray[$index]=$changeFile
        index=$[$index + 1]
    done
    echo ${changeFileArray[@]}
}

# 获取文件后缀名
function getFileType {
    local path=$1
    # 判断是否为文件
    local fileType=`echo $path | awk -F '.' '{print $NF}'`
    echo $fileType
}

# 获取对应的源路径
function getSourcePath {
    local path=$1
    local sourcePath
    local fileType=$(getFileType $path)
    if [[ $fileType == 'java' ]] || [[ $fileType == 'xml' ]]
    then
        # .java 对应为 WEB-INF claess  下
        local classesDir=$(getClassesDir)
        sourcePath=`echo $path | sed s!$localProjectDir/src!$classesDir! | sed s!\.java!\.class! `
    else
        sourcePath=$1
    fi
    echo $sourcePath
}

# 获取目标路径
function getTargetPath {
    local sourcePath=$1
    local targetPath=`echo $sourcePath | sed s!$localProjectDir!$exportDir! `
    local fileType=$(getFileType $targetPath)
    echo $targetPath
}

# 复制文件
function copyFile {
    local srcFile=$1
    local tarFile=$2
    local tarDir=${tarFile%/*}

    if [ ! -f $srcFile ]
    then
        # 源文件不存在，退出
        echo '=========== 源文件不存在 ==========='
        echo "$srcFile"
        echo -e "==================================\n"
        #exit 2
        return
    fi

    if [ ! -d $tarDir ]
    then
        # 目标目录不存在则创建
        mkdir -p $tarDir
    fi
    cp $srcFile $tarFile
}

# 比较结果
function compareResult {
    local tempSrcFile='source.txt'
    local tempTargetFile='target.txt'
    local sourceContent=`cat $exportFile | sed s!$svnProjectUrl!! | sort   > $tempSrcFile`
    local targetContent=`find $exportDir -type f | sed s!$exportDir!! | sort > $tempTargetFile`
    echo "========== 比较结果 ============================================"
    echo "========== 第一部分为目标目录文件，第二部分为源目录文件 =============="
    diff $tempSrcFile $tempTargetFile --left-column
    rm -f $tempSrcFile $tempTargetFile
}

# 主函数
function main {

    local fileList=$(getDiffFilesFromLocal)

    local localChangeFiles=($(getLocalChangeFiles $fileList))

    for f in ${localChangeFiles[@]};
    do
        if [ ! -d $f ];
        then
         local sourceFile=$(getSourcePath $f)
         local targetFile=$(getTargetPath $sourceFile)
         copyFile $sourceFile $targetFile
        fi
    done
    
    compareResult
}

main

#!/bin/bash

width_in_pix=$1

path=$2

#默认宽度1500像素
default_width_in_pix=1500

image_type=("jpg","jpeg","png","JPG","JPEG", "PNG")
#image_type=("mp4")

if [ x$1 != x ]
then
    echo "目标图片宽度：$width_in_pix 像素"
else
	echo "未指定图片快读，默认:$default_width_in_pix 像素"
    width_in_pix=$default_width_in_pix
fi

subPath="width_in_pix_$width_in_pix"


if [ x$path != x ]
then
    echo "处理目录或文件为：$path"
else
    path=$(dirname $0)
    echo "未指定目录，默认当前目录:$path"
fi


if [ -f "$path" ]; then
	#目标是文件，处理单个文件

    #获取文件后缀
    subfix=${path##*.}

    #判断是否支持
    if [[ ${image_type[@]/${subfix}/} != ${image_type[@]} ]] 
    then
    	#sips -Z $width_in_pix $path
    	cd $(realpath $0)

    	targetFileName=$(dirname $0)/$subPath"_"$(basename $path)

    	#如果是单个文件，则复制文件后在当前目录中处理，结果保存在当前目录
    	cp $path $targetFileName

    	sips -Z $width_in_pix $targetFileName > /dev/null

    	echo "已处理，输出文件为$targetFileName"
    else
    	echo "结束：不支持处理此文件类型$subfix"
    fi

else
	echo "文件不存在，尝试按文件夹处理"
    if [ -d "$path" ]; then
		cd $path

		#创建子文件夹
		targetPath="$path""/""$subPath"

		if [ ! -d $targetPath  ];then
		 	mkdir $targetPath
		fi

		for file in `ls $path` #注意此处这是两个反引号，表示运行系统命令
		do
			if [ -f $path"/"$file ] #注意此处之间一定要加上空格，否则会报错
			then
				subfix=${file##*.}

				if [[ ${image_type[@]/${subfix}/} != ${image_type[@]} ]] 
			    then

					theShortFileName=$(basename $file)

					echo "处理中：$theShortFileName"

			    	targetFileName=$path"/"$subPath"/"$(basename $file)
			    	
			    	#如果是单个文件，则复制文件后在当前目录中处理，结果保存在当前目录
			    	cp $path"/"$file $targetFileName

			    	sips -Z $width_in_pix $targetFileName > /dev/null

			    	echo "已处理，输出文件为$targetFileName"
			    else
			    	echo "未处理：$file 不支持此文件类型$subfix"
			    fi
		 		
			fi
		done

		echo "处理结束，目标目录：$targetPath"
	else
		echo "文件夹不存在"
		echo "结束，未处理任何文件"
	fi
fi



#!/bin/bash
#yanc 20200227

target=/home/yanc/back
year=`date +%Y`
month=`date +%m`
day=`date +%d`
week=`date +%u`
tim=`date +%H%M%S`
files=$*


if [ ! -z $* ];then
	echo "\033[33m$* will be backup! \033[0m"
else
	echo "\033[33mPlease input correct directory! example:/home\033[0m"
	exit
fi

if [ -d $target ];then
	echo "\033[33m$* will backup to $target! \033[0m"
else
	mkdir $target
	echo "\033[33m$target created successful! \033[0m"
fi

full_backup()
{
#if [ $week -eq 7 ];then
	rm -rf $target/snapshot
	cd $target
	tar -g $target/snapshot -czvf $year$month$day${tim}_fullbackup.tar.gz $files
	if [ $? -eq 0 ];then
		echo "\033[33m$* backup to $target/$year$month${day}_backup.tar.gz successful! \033[0m" 
	fi
#fi
}

add_backup()
{
if [ $week -ne 7 ];then
         cd $target
         tar -g $target/snapshot -czvf $year$month$day${tim}_addbackup.tar.gz $files
         if [ $? -eq 0 ];then
                 echo "\033[33m$* backup to $target/$year$month${day}_backup.tar.gz successful! \033[0m" 
         fi
fi
}

full_backup
#add_backup


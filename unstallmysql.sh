#!/bin/bash
#unstall mysql files
#by yanc 2020.2.9

find / -name mysql-5.7.26 >mysqlpathlog.md
find / -name mysql >>mysqlpathlog.md
find / -name mysqld >>mysqlpathlog.md

len=`sudo cat ./mysqlpathlog.md |wc -l`

for i in $(seq 1 $len);
do
	mysqlfile=`sed -n "$i"p ./mysqlpathlog.md`
	rm -rf $mysqlfile
	echo -e "\033[36mDelete $mysqlfile Successfully!\033[0m"
done

rm -rf /etc/my.cnf
echo -e "\033[36mDelete "/etc/my.cnf" Successfully!\033[0m"


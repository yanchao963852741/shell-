#!/bin/bash
#disk alarm mail
#yanc 20200325

LIST=`df -h|grep "^/dev/" >list.txt`

while read line
do
	ip_address=`ifconfig|grep "broadcast"|awk '{print $2}'`
	disk_name=`echo $line|awk '{print $1}'`
	total_size=`echo $line|awk '{print $2}'`
	use_size=`echo $line|awk '{print $3}'`
	use_percent=`echo $line|awk '{print $5}'|sed 's/%//g'`
	info=info.txt
cat >info.txt<<EOF
**************************
通知类型：告警

IP地址：$ip_address

磁盘分区：$disk_name

总容量：$total_size

已用容量：$use_size

已用百分比：$use_percent%

**************************
EOF
	if [ $use_percent -ge 50 ];then
		mail -s "Disk alarm" yc290782359@163.com < $info >>/dev/null 2>&1
		echo "There is a alarm,disk been used $use_percent%,email has been send!"
	else
		echo "Disk size is safe,current used:$use_percent%"
	fi
done < list.txt

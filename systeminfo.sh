#!/bin/bash
#collect system info
#yanc 20200321

echo "\033[32m \033[1m"
output_systeminfo()
{
Hostname=`hostname`
ip_info=`ifconfig|grep "broadcast"|awk '{print $NF}'`
cpu_info1=`cat /proc/cpuinfo |grep "model name"|awk -F: '{print $NF}'`
cpu_info2=`cat /proc/cpuinfo |grep "physical id"|awk -F: '{print $NF}'|wc -l`
disk_info=`fdisk -l|grep "vda:"|awk '{print $3,$4}'|sed 's/,//g'`
mem_info=`free -m|grep "Mem"|awk '{print $2"M"}' `
load_info=`uptime|awk '{print $(NF-2)}'|sed 's/,//g' `
rm -rf 1.csv
echo ID,hostname,ip,cpu,disk,memery,cload>>1.csv
i=1
#number=`cat hostlist.txt|wc -l`
#for i in $(seq 1 $number)
#do
#Host=`sed -n "$i"p hostlist.txt`
#ssh root@$Host bash -c "echo $i,$Hostname,$ip_info,$cpu_info1 X $cpu_info2,$disk_info,$mem_info,$load_info" >>1.csv
echo "------------------------------------"
echo $i,$Hostname,$ip_info,$cpu_info1 X $cpu_info2,$disk_info,$mem_info,$load_info
echo $i,$Hostname,$ip_info,$cpu_info1 X $cpu_info2,$disk_info,$mem_info,$load_info>>1.csv
echo "------------------------------------"
#done
}

create_database()
{
#create database
read -p "Create database name:" a
mysql -uroot -pvislecaina << EOF >/dev/null
create database $a
EOF
if [ $? -eq 0 ];then
	echo "Database $a create successful!"
else
	echo "Database $a already exist!"
fi
}

drop_database()
{
#drop database
read -p "Drop database name:" b
mysql -uroot -pvislecaina << EOF >/dev/null
drop database $b
EOF
if [ $? -eq 0 ];then
        echo "Database $b dropped successfully!"
else
        echo "Database $b donot exist!"
fi
}

show_databases()
{
mysql -uroot -pvislecaina << EOF >temp.txt
show databases;
EOF
cat temp.txt
}

create_table()
{
#create table
read -p "select database:" x
read -p "table name:" y
mysql -uroot -pvislecaina << EOF >/dev/null
use $x
create table $y(ID int,hostname varchar(64),ip varchar(64),cpu varchar(64),disk varchar(64),memery varchar(64),cload varchar(64))
EOF
if [ $? -eq 0 ];then
        echo "Table $y create successful!"
else
        echo "Table $y already exist!"
fi
}

drop_table()
{
#drop table
read -p "select database:" p
read -p "table name:" q
mysql -uroot -pvislecaina << EOF >/dev/null
use $p
drop table $q
EOF
if [ $? -eq 0 ];then
        echo "Table $q dropped successfully!"
else
        echo "Table $q donot exist!"
fi
}

show_tables()
{
read -p "select database:" g
mysql -uroot -pvislecaina << EOF >temp.txt
use $g
show tables;
EOF
cat temp.txt
}

insert_data()
{
read -p "select database:" m
read -p "table name:" n
query=`cat 1.csv|grep "CPU" |awk -F, '{printf("%s,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",$1,$2,$3,$4,$5,$6,$7)}'`
mysql -uroot -pvislecaina << EOF >/dev/null
use $m
insert into $n values($query)
EOF
}

delete_data()
{
read -p "select database:" w
read -p "table name:" e
read -p "data id:" t
mysql -uroot -pvislecaina << EOF >/dev/null
use $w
delete from $e where ID=$t 
EOF
}

show_data()
{
read -p "select database:" aa
read -p "table name:" bb
mysql -uroot -pvislecaina << EOF >temp.txt
use $aa
select * from $bb  
EOF
cat temp.txt
}

PS3="Please select menu:(1-11)"
select index in create_database drop_database show_databases create_table drop_table show_tables output_systeminfo insert_data delete_data show_data Exit
do
	case $index in
	create_database)
	create_database;;

	drop_database)
	drop_database;;

	show_databases)
	show_databases;;

	create_table)
	create_table;;

	drop_table)
	drop_table;;
	
	show_tables)
	show_tables;;

	output_systeminfo)
	output_systeminfo;;

	insert_data)
	insert_data;;

	delete_data)
	delete_data;;

	show_data)
	show_data;;

	Exit)
	exit
	esac
done 

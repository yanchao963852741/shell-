#!/bin/bash
#auto monitor server email
#yanc 20200319
echo "\033[32m \033[1m"

email()
{
email=email.txt
ip_add=`ifconfig|grep broadcast|awk '{print $2}'`
DATE=`date`

for i in `cat serverlist.txt`
do
count=`ps -ef|grep $i|grep -v email|grep -v "grep"|wc -l`
	if [ $count -eq 0 ];then
cat >$email <<EOF
*****************************
通知类型：故障

主机：$ip_add

时间：$DATE

服务：$i

状态：服务已停止

*****************************
EOF
		echo "The $i server is not running!"
		mail -s "$ip_add $i server warnning" yc290782359@163.com < $email >>/dev/null 2>&1

	else
		echo "The $i server is running!"
	fi
done
}

add_server()
{
read -p "Please input server name to add:" a
echo $a >> serverlist.txt
}

delete_server()
{
read -p "Please input server name to delete:" b
sed -i "/$b/d" serverlist.txt

}


PS3="Please select menu(1-5):"
select i in Add_server Delete_server Show_serverlist Email Exit
do
        case $i in
        Add_server)
	add_server;;

        Delete_server)
        delete_server;;

        Show_serverlist)
        cat serverlist.txt;;

        Email)
        email;;

        Exit)exit
        esac
done


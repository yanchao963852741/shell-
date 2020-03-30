#!/bin/bash
#auto copy files to remote server
#yanc 20200308

stty erase '^H'
add_ip_function()
{
read -p "Please input add ip:" a
echo "$a" >> ip.txt
echo -e "\033[36m$a successfully add!\033[0m"
}

delete_ip_function()
{
read -p "Please input delete ip:" b
sed -i "/$b/d" ip.txt
echo -e "\033[36m$b successfully delete!\033[0m"
}

scp_function()
{
readx_function "local"
ready_function "remote"
for j in `cat ip.txt`
do
	if [ -f $x ];then
		scp $x root@$j:$y
	elif [ -d $x ];then
		scp -r $x root@$j:$y
	fi
done
}

readx_function()
{
err=1
while [ "$err"="1" ]
do
read -p "Input $1 file:" x
f=`stat $x|sed -n '2p'|awk '{print $9}'`
d=`stat $x|sed -n '2p'|awk '{print $8}'`
if [ "$f" == "file" ];then
        echo "This is a file!"
	let err=0
	echo $x
	break
elif [ "$d" == "directory" ];then
	echo "This is a directory!"
	let err=0
	echo $x
	break
else
	echo "Please input a file or directory!"
	let err=1
fi
done
}

ready_function()
{
err=1
while [ "$err"="1" ]
do
read -p "Input $1 path:" y
f=`stat $y|sed -n '2p'|awk '{print $9}'`
d=`stat $y|sed -n '2p'|awk '{print $8}'`
if [ "$f" == "file" ];then
        echo "This is a file!"
        let err=0
        echo $y
        break
elif [ "$d" == "directory" ];then
        echo "This is a directory!"
        let err=0
        echo $y
        break
else
        echo "Please input a file or directory!"
        let err=1
fi
done
}

PS3="Please select menu(1-5):"
select i in Add_ip Delete_ip Show_iplist Scp Exit 
do
	case $i in
	Add_ip)
	add_ip_function;;
	
	Delete_ip)
	delete_ip_function;;
	
	Show_iplist)
	cat ip.txt;;
	
	Scp)
	scp_function;;
	
	Exit)exit
	esac
done



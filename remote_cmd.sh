#!/bin/bash
#execute remote cmd
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

ssh_cmd_function()
{
read -p "Please input cmd:" x
for i in `cat ip.txt`
do
	ssh root@$i $x
done

}

PS3="Please select menu(1-5):"
select i in Add_ip Delete_ip Show_iplist Ssh_cmd Exit
do
        case $i in
        Add_ip)
        add_ip_function;;

        Delete_ip)
        delete_ip_function;;

        Show_iplist)
        cat ip.txt;;

        Ssh_cmd)
        ssh_cmd_function;;

        Exit)exit
        esac
done


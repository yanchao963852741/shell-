#!/bin/bash
#iptable deny_ipaddress
#yanc 20200304

auth_log=/var/log/auth.log
wrong_times=`tail -n 100 $auth_log |grep "Failed password"|awk '{print $13}'|sort|uniq -c|awk '{print $1}'`
ip_address=`tail -n 100 $auth_log |grep "Failed password"|awk '{print $13}'|sort|uniq -c|awk '{print $2}'`
iptables_file=/etc/iptables/rules.v4
ip_deny="-A INPUT -s $ip_address -m state --state NEW -m tcp -p tcp --dport 22 -j DROP"


if [ "$wrong_times" -gt "4" ];then
	sed -i "/\-i/a $ip_deny" $iptables_file
	iptables-restore < /etc/iptables/rules.v4
fi


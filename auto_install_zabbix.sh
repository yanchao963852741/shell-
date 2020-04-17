#!/bin/bash

if [ ! -z `docker ps -aq|wc -l` ];then
	docker rm -f $(docker ps -aq)
fi

#install mysql docker
if [ -z `docker images|grep mysql|grep 5.7|wc -l` ];then
	docker pull mysql:5.7
fi
docker run --name zabbix-mysql -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix2020" -e MYSQL_ROOT_PASSWORD=yanchao123 -v /etc/localtime:/etc/localtime -d mysql:5.7 --character-set-server=utf8 --collation-server=utf8_bin

mysql_docker_id=`docker ps|grep mysql:5.7|awk '{print $1}'`
mysql_ip=`docker inspect $mysql_docker_id|grep IPAddress|sed -n '3p'|awk '{print $NF}'|sed 's/"//g'|sed 's/,//g'`
echo mysql ip is $mysql_ip

#install zabbix-server-mysql docker
if [ -z `docker images|grep zabbix-server|wc -l` ];then
	docker pull zabbix/zabbix-server-mysql
fi
docker run --name zabbix-server-mysql -e DB_SERVER_HOST="$mysql_ip" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix2020" -v /etc/localtime:/etc/localtime -p 10051:10051 -d zabbix/zabbix-server-mysql 

zabbix_server_id=`docker ps|grep zabbix-server|awk '{print $1}'`
zabbix_server_ip=`docker inspect $zabbix_server_id|grep IPAddress|sed -n '3p'|awk '{print $NF}'|sed 's/"//g'|sed 's/,//g'`

echo zabbix ip is $zabbix_server_ip

#install zabbix-web-nginx-mysql docker
if [ -z `docker images|grep zabbix-web|wc -l` ];then
	docker pull zabbix/zabbix-web-nginx-mysql
fi
docker run --name zabbix-web-nginx-mysql --link zabbix-server-mysql:zabbix-server --link zabbix-mysql:mysql -e DB_SERVER_HOST="$mysql_ip" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix2020" -e ZBX_SERVER_HOST="$zabbix_server_ip" -e PHP_TZ="Asia/Shanghai" -v /etc/localtime:/etc/localtime -p 80:80 -d zabbix/zabbix-web-nginx-mysql

#install zabbix/zabbix-agent docker
if [ -z `docker images|grep zabbix-agent|wc -l` ];then
	docker pull zabbix/zabbix-agent
fi
docker run --name zabbix-agent -e ZBX_HOSTNAME="zabbix-agent" -e ZBX_SERVER_HOST="$zabbix_server_ip" --link zabbix-server-mysql:zabbix-server -v /etc/localtime:/etc/localtime -p 10050:10050 -d zabbix/zabbix-agent

echo -e "\033[36mzabbix dockers run finished\033[0m"

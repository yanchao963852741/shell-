#!/bin/bash
#LAMP one key install
#by yanc 2020.2.8


#LAMP MENU
if [ -z "$1" ];then
	echo -e "\033[36mPlease select install menu:\033[0m"
	echo -e "\033[36m1)编译安装Apache服务器\033[0m"
	echo -e "\033[36m2)编译安装MYSQL服务器\033[0m"
	echo -e "\033[36m3)编译安装PHP服务器\033[0m"
	echo -e "\033[36m4)配置index.php并启动LAMP服务\033[0m"
	echo -e "\033[36mUsage:{ /bin/sh $0 1|2|3|4|help}\033[0m"
	exit
fi


#Apache install
##APR url and file
APR_file_name=apr-1.4.5.tar.gz
APR_file_dir=apr-1.4.5
APR_file_url=http://archive.apache.org/dist/apr/
APR_file_prefix=/usr/local/apr/

##APR util url and file
AU_file_name=apr-util-1.3.12.tar.gz
AU_file_dir=apr-util-1.3.12
AU_file_url=http://archive.apache.org/dist/apr/
AU_file_prefix=/usr/local/apr-util/

##Pcre url and file
##Apache url and file
P_file_name=pcre-8.10.zip
P_file_dir=pcre-8.10
P_file_url=https://ftp.pcre.org/pub/pcre/
P_file_prefix=/usr/local/pcre/


##Apache url and file
A_file_name=httpd-2.4.41.tar.bz2
A_file_dir=httpd-2.4.41
A_file_url=https://mirrors.cnnic.cn/apache/httpd/
A_file_prefix=/usr/local/apache2/

if [ $1 -eq 1 ];then
	#安装APR
	#mkdir $APR_file_prefix
	cd ./apachefiles&&wget $APR_file_url/$APR_file_name &&tar -zxf $APR_file_name $APR_file_dir&&cd $APR_file_dir&&./configure --prefix=$APR_file_prefix
 	if [ $? -eq 0 ];then
                make&&make install
                echo -e "\033[36mThe $APR_file_dir Install Successfully!\033[0m"
        else
                echo -e "\033[36mThe $APR_file_dir Install Failed,Please Check...!\033[0m"
 	fi

	#安装APR_UTIL
        #mkdir $AU_file_prefix
	cd ..&&wget $AU_file_url/$AU_file_name &&tar -zxf $AU_file_name $AU_file_dir&&cd $AU_file_dir&&./configure --prefix=$AU_file_prefix -with-apr=$APR_file_prefix/bin/apr-1-config
 	if [ $? -eq 0 ];then
                make&&make install
                echo -e "\033[36mThe $AU_file_dir Install Successfully!\033[0m"
        else
                echo -e "\033[36mThe $AU_file_dir Install Failed,Please Check...!\033[0m"
        fi

	#安装PCRE
        #mkdir $P_file_prefix
	cd ..&&wget $P_file_url/$P_file_name &&unzip $P_file_name &&cd $P_file_dir&&./configure --prefix=$P_file_prefix
	if [ $? -eq 0 ];then
	        make&&make install
	        echo -e "\033[36mThe $P_file_dir Install Successfully!\033[0m"
	else
                echo -e "\033[36mThe $P_file_dir Install Failed,Please Check...!\033[0m"
        fi

	#安装APACHE
	cd ..&&wget $A_file_url/$A_file_name &&tar -jxf $A_file_name $A_file_dir&&cd $A_file_dir&&./configure --prefix=$A_file_prefix -with-apr=$APR_file_prefix -with-apr-util=$AU_file_prefix -with-pcre=$P_file_prefix
	if [ $? -eq 0 ];then
		make&&make install
		echo -e "\033[36mThe $A_file_url/$A_file_dir Install Successfully!\033[0m"
	else
		echo -e "\033[36mThe $A_file_url/$A_file_dir Install Failed,Please Check...!\033[0m"
	fi
fi



#Msql Install
##Mysql url and file
M_file_name=mysql-5.7.26.tar.gz
M_file_dir=mysql
M_file_url=https://dev.mysql.com/get/Downloads/MySQL-5.7/
M_file_prefix=/usr/local/mysql/

##boost files
B_file_name=boost_1_59_0.tar.gz
B_file_dir=boost_1_59_0
B_file_url=http://www.sourceforge.net/projects/boost/files/boost/1.59.0/
B_file_boostdir=/usr/local/boost

if [ $1 -eq 2 ];then
        #下载boost
	#cd ./mysqlfiles&&wget $B_file_url/$B_file_name
	#cd ./mysqlfiles&&tar -zxvf $B_file_name&&mv $B_file_dir $B_file_boostdir
	
	#安装组件ncurses
	#cd ./mysqlfiles&&wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz&&tar -zxvf ncurses-6.0.tar.gz&&cd ncurses-6.0&&export CPPFLAGS="-P"&&./configure --with-shared --without-debug --without-ada --enable-overwrite &&make&&make install	
	#安装组件pkg-config
	#apt install pkg-config
	
	#下载解压mysql
	#mkdir $M_file_prefix&&
        #cd ./mysqlfiles&&wget $M_file_url/$M_file_name 
	cd ./mysqlfiles&&tar -xvf $M_file_name&&mv mysql-5.7.26 $M_file_dir&&cd $M_file_dir
	#&&apt install cmake
	
	#清除上次编译数据
	make clean&&rm -f CMakeCache.txt&&rm -rf /etc/my.cnf&&rm -rf /etc/init.d/mysqld

	#修改账户和文件夹权限
        #groupadd mysql
        #useradd -r -g mysql mysql
        #mkdir -p /usr/local/mysql/data/
        chown mysql:mysql -R /usr/local/mysql/&&/bin/cp support-files/mysql.server /etc/init.d/mysqld&&chmod +x /etc/init.d/mysqld
        #sysv-rc-conf mysqld on

	if [ $? -eq 0 ];then
		#cmake编译
		cmake \
		-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
		-DWITH_BOOST=/usr/local/boost \
		-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		-DWITH_EXTRA_CHARSETS=all \
		-DWITH_MYISAM_STORAGE_ENGINE=1\
		-DWITH_INNOBASE_STORAGE_ENGINE=1\
		-DWITH_MEMORY_STORAGE_ENGINE=1\
		-DWITH_READLINE=1\
		-DENABLED_LOCAL_INFILE=1\
		-DMYSQL_DATADIR=/usr/local/mysql/data \
		-DMYSQL-USER=mysql
		make&&make install
	
                echo -e "\033[36mThe $M_file_dir Install Successfully!\033[0m"
        else
                echo -e "\033[36mThe $M_file_dir Install Failed,Please Check...!\033[0m"
        fi
fi

#PHP install
##boost files
P_file_name=php-5.6.6.tar.gz
P_file_dir=php-5.6.6
P_file_url=http://mirrors.sohu.com/php/
P_file_prefix=/usr/local/php5/


if [ $1 -eq 3 ];then
        #mkdir $P_file_prefix&&mkdir phpfiles
	#安装libxml2组件
	#apt-get install libxml2-dev
        
	#下载PHP
	#cd ./phpfiles&&wget $P_file_url/$P_file_name &&
	
	#安装libiconv
	#mkdir /usr/local/libiconv
	#cd ./phpfiles&&wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz&&tar zxvf libiconv-1.13.1.tar.gz&&
	#cd ./phpfiles/libiconv-1.13.1&&./configure --prefix=/usr/local/libiconv &&make&&make install
	#ln -s /usr/local/libiconv/lib/libiconv.so /usr/lib
	#ln -s /usr/local/libiconv/lib/libiconv.so.2 /usr/lib/libiconv.so.2 
	#cd ..&&echo `pwd`
	#cd ..&&echo `pwd`
	
	#编译PHP
	#ln -s libmysqlclient.so.20 libmysqlclient_r.so   #创建/usr/local/mysql/lib下的软连接
	cd ./phpfiles&&tar -zxf $P_file_name $P_file_dir&&cd $P_file_dir&&./configure --prefix=$P_file_prefix --with-config-file-path=$P_prefix/etc --with-mysql=/usr/local/mysql --with-apxs2=/usr/local/apache2/bin/apxs 
        if [ $? -eq 0 ];then
                make ZEND_EXTRA_LIBS='-liconv'&&make install
                echo -e "\033[36mThe $P_file_dir Install Successfully!\033[0m"
        else
                echo -e "\033[36mThe $P_file_dir Install Failed,Please Check...!\033[0m"
        fi
fi

# Version 0.1
# 基础镜像
FROM ubuntu:14.04
# 维护者信息
MAINTAINER sheldon9527yxd@gmail.com

# 设置源
RUN  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get -y update && apt-get install -y  libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0 zlibc libltdl3-dev slapd ldap-utils db5.1-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/*


#下载文件
RUN mkdir -p /opt/soft && cd /opt/soft && pwd;

# 下载 mysql
RUN cd /opt/soft && wget -c http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
RUN cd /opt/soft && wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17.tar.gz

# 复制 mysql-5.7.17 文件到镜像中（mysql-5.7.17文件夹要和Dockerfile文件在同一路径）
RUN cd /opt/soft && tar -zxvf mysql-5.7.17.tar.gz;

# 编译 mysql-5.7.17
RUN cd /opt/soft/mysql-5.7.17 && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DSYSCONFDIR=/etc  -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/opt/soft -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1  -DENABLED_LOCAL_INFILE=1 -DENABLE_DTRACE=0  -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DMYSQL_TCP_PORT=3306 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8mb4  -DDEFAULT_COLLATION=utf8mb4_general_ci  -DWITH_EMBEDDED_SERVER=1 && make && make install;

#添加 mysql 用户组
RUN groupadd mysql && useradd -g mysql mysql

RUN mkdir -pv /usr/local/mysql/data

RUN chown -R mysql.mysql /usr/local/mysql && chmod +x /usr/local/mysql

COPY my.cnf /etc/

RUN cp /opt/soft/mysql-5.7.17/support-files/mysql.server  /etc/init.d/mysql && chmod +x /etc/init.d/mysql

RUN /usr/local/mysql/bin/mysqld --initialize-insecure   --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql




# 编译 PHP
RUN cd /opt/soft && wget -c http://cn2.php.net/distributions/php-7.1.1.tar.gz

RUN groupadd www && useradd -g www www

#编译 php
RUN cd /opt/soft && tar -zxvf php-7.1.1.tar.gz

#建立软连接
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/
RUN ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/
RUN ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so
RUN ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1

#编译数据
RUN cd /opt/soft/php-7.1.1 && ./buildconf --force && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-bcmath --enable-calendar  --enable-exif --enable-ftp --enable-gd-native-ttf --enable-intl --enable-mbregex --enable-mbstring --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --enable-dba --enable-zip --with-freetype-dir --with-gd --with-gettext --with-iconv --with-icu-dir=/usr --with-jpeg-dir --with-kerberos --with-libedit --with-mhash --with-openssl  --with-png-dir --with-xmlrpc --with-zlib --with-zlib-dir --with-bz2 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-gmp --with-curl --with-xsl --with-ldap --with-ldap-sasl=/usr --enable-pcntl --with-tidy --enable-zend-signals --enable-dtrace  --with-mysqli=mysqlnd   --with-pdo-mysql=mysqlnd  --enable-pdo  --enable-opcache --with-mcrypt --enable-maintainer-zts --enable-gd-jis-conv --with-imap --with-imap-ssl --with-libxml-dir --enable-shared --with-pcre-regex  --with-sqlite3 --with-cdb  --enable-fileinfo --enable-filter --with-pcre-dir  --with-openssl-dir  --enable-json  --enable-mbregex-backtrack  --with-onig  --with-pdo-sqlite --with-readline --enable-session --enable-simplexml  --enable-mysqlnd-compression-support --with-pear && sed -i 's/EXTRA_LIBS.*/& -llber/g' Makefile && make && make install


#copy 配置文件
COPY php-fpm.conf  /usr/local/php/etc/
COPY www.conf  /usr/local/php/etc/php-fpm.d/
COPY php.ini  /usr/local/php/etc/
COPY php-cli.ini  /usr/local/php/etc/


#编译 redis

RUN cd /opt/soft && wget -c http://download.redis.io/releases/redis-3.2.7.tar.gz

RUN cd /opt/soft && tar zxvf redis-3.2.7.tar.gz && mv redis-3.2.7 redis && cp -rf redis /usr/local/

RUN cd /usr/local/redis && make && make install && rm -rf /usr/local/redis/redis.conf
COPY redis.conf  /usr/local/redis/

#编译 redis 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/redis-3.1.1.tgz

RUN cd /opt/soft && tar zxvf redis-3.1.1.tgz && cd redis-3.1.1 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install

#编译 event 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/event-2.2.1.tgz

RUN cd /opt/soft && tar zxvf event-2.2.1.tgz && cd event-2.2.1 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --with-event-core --with-event-extra && make && make install

#编译pthreads
RUN cd /opt/soft && git clone https://github.com/krakjoe/pthreads.git && cd pthreads && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --enable-pthreads --with-pthreads-sanitize --with-pthreads-dmalloc  --with-php-config=/usr/local/php/bin/php-config && make && make install


RUN cd /opt/soft/php-7.1.1  && cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm

#安装 openresty
RUN cd /opt/soft && wget -c https://openresty.org/download/openresty-1.11.2.2.tar.gz
RUN cd /opt/soft && wget -c ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz
RUN cd /opt/soft && wget -c https://www.openssl.org/source/openssl-1.0.2k.tar.gz

RUN cd /opt/soft && tar zxvf openresty-1.11.2.2.tar.gz && tar zxvf pcre-8.40.tar.gz && tar zxvf openssl-1.0.2k.tar.gz

#编译 openresty
RUN cd /opt/soft/openresty-1.11.2.2 && ./configure --prefix=/usr/local/openresty  --with-luajit --with-http_stub_status_module --with-http_v2_module --with-http_ssl_module --with-ipv6 --with-http_gzip_static_module --with-http_realip_module --with-http_flv_module --user=www --group=www --with-pcre=../pcre-8.40 --with-pcre-jit --with-pcre-opt=-g --with-openssl=../openssl-1.0.2k && make && make install

#copy nginx 配置文件
RUN cd /usr/local/openresty/nginx/conf && mv nginx.conf nginx.conf_bak
COPY nginx.conf  /usr/local/openresty/nginx/conf





#创建工作目录
RUN mkdir -pv /home/work
RUN chmod -R +x  /home/work && chown -R www.www /home/work





# 添加启动脚本
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh


CMD /run.sh && tail -f

# Expose ports.
EXPOSE 3306
EXPOSE 80

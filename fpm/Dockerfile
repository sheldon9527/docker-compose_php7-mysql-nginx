# Version 0.1
# 基础镜像
FROM ubuntu:14.04
# 维护者信息
MAINTAINER abulo.hoo@gmail.com
# 设置源
RUN  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
RUN apt-get -y update && apt-get install -y  libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0 zlibc libltdl3-dev slapd ldap-utils db5.1-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
#下载文件
RUN mkdir -p /opt/soft && cd /opt/soft && pwd;
# 编译 PHP
RUN cd /opt/soft && wget -c http://php.net/distributions/php-7.1.6.tar.gz
RUN groupadd www && useradd -g www www
#编译 php
RUN cd /opt/soft && tar -zxf php-7.1.6.tar.gz
#建立软连接
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/
RUN ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/
RUN ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so
RUN ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1
#编译数据
RUN cd /opt/soft/php-7.1.6 && ./buildconf --force && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-bcmath --enable-calendar  --enable-exif --enable-ftp --enable-gd-native-ttf --enable-intl --enable-mbregex --enable-mbstring --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --enable-dba --enable-zip --with-freetype-dir --with-gd --with-gettext --with-iconv --with-icu-dir=/usr --with-jpeg-dir --with-kerberos --with-libedit --with-mhash --with-openssl  --with-png-dir --with-xmlrpc --with-zlib --with-zlib-dir --with-bz2 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-gmp --with-curl --with-xsl --with-ldap --with-ldap-sasl=/usr --enable-pcntl --with-tidy --enable-zend-signals --enable-dtrace  --with-mysqli=mysqlnd   --with-pdo-mysql=mysqlnd  --enable-pdo  --enable-opcache --with-mcrypt --enable-maintainer-zts --enable-gd-jis-conv --with-imap --with-imap-ssl --with-libxml-dir --enable-shared --with-pcre-regex  --with-sqlite3 --with-cdb  --enable-fileinfo --enable-filter --with-pcre-dir  --with-openssl-dir  --enable-json  --enable-mbregex-backtrack  --with-onig  --with-pdo-sqlite --with-readline --enable-session --enable-simplexml  --enable-mysqlnd-compression-support --with-pear && sed -i 's/EXTRA_LIBS.*/& -llber/g' Makefile && make && make install
#编译 redis
RUN cd /opt/soft && wget -c http://download.redis.io/releases/redis-3.2.8.tar.gz  && tar -zxf redis-3.2.8.tar.gz && mv redis-3.2.8 redis && cp -rf redis /usr/local/ &&  cd /usr/local/redis && make && make install && rm -rf /usr/local/redis/redis.conf

#编译 redis 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/redis-3.1.2.tgz && tar -zxf redis-3.1.2.tgz && cd redis-3.1.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install

#编译 event 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/event-2.3.0.tgz && tar -zxf event-2.3.0.tgz && cd event-2.3.0 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --with-event-core --with-event-extra && make && make install

#编译pthreads
RUN cd /opt/soft && git clone https://github.com/krakjoe/pthreads.git && cd pthreads && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --enable-pthreads --with-pthreads-sanitize --with-pthreads-dmalloc  --with-php-config=/usr/local/php/bin/php-config && make && make install


RUN cd /opt/soft && git clone https://github.com/redis/hiredis && cd hiredis && make -j && make install && ldconfig && mkdir -pv /usr/lib/hiredis && cp libhiredis.so /usr/lib/hiredis && mkdir -pv /usr/include/hiredis &&  cp hiredis.h /usr/include/hiredis

RUN cd /opt/soft && wget -c  https://github.com/swoole/swoole-src/archive/v2.0.7.tar.gz && tar -zxf v2.0.7.tar.gz  && cd swoole-src-2.0.7  && /usr/local/php/bin/phpize && ./configure --enable-swoole-debug  --enable-sockets   --enable-async-redis --with-php-config=/usr/local/php/bin/php-config --enable-swoole --enable-thread --enable-mysqlnd --enable-coroutine && make && make install


RUN cd /opt/soft && wget http://pecl.php.net/get/yaml-2.0.0.tgz && tar zxvf yaml-2.0.0.tgz && cd yaml-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install


RUN cd /opt/soft && wget http://pecl.php.net/get/msgpack-2.0.2.tgz && tar zxvf  msgpack-2.0.2.tgz && cd msgpack-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install


RUN cd /opt/soft && wget http://pecl.php.net/get/inotify-2.0.0.tgz  && tar zxvf  inotify-2.0.0.tgz  && cd inotify-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install

RUN cd /opt/soft && git clone https://github.com/rvoicilas/inotify-tools.git && cd inotify-tools && ./autogen.sh && ./configure && make && make install && ln -sv /usr/local/lib/libinotify* /usr/lib/


RUN cd /opt/soft/php-7.1.6  && cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm &&  cd /opt/soft && rm -rf * && apt-get clean

#工作目录
WORKDIR /home/www
#端口
EXPOSE 9000
#开启
CMD /etc/init.d/php-fpm start
CMD /usr/local/php/sbin/php-fpm  --nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf

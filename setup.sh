#!/bin/bash

# assume current working directory is cloned xplex repository
export WORKDIR=$(pwd)

# create a temporary working directory
mkdir -p build
cd build

# download the source code for nginx, openssl, pcre, rtmp, and zlib
export v_NGINX=1.29.1
export vm_OSSL=3.5.0
export vm_PCRE=10.46
export vm_RTMP=1.2.2
export vm_SRTP=1.1
export vm_ZLIB=1.3.1

wget https://nginx.org/download/nginx-${v_NGINX}.tar.gz
wget https://github.com/openssl/openssl/releases/download/openssl-${vm_OSSL}/openssl-${vm_OSSL}.tar.gz
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${vm_PCRE}/pcre2-${vm_PCRE}.tar.gz
wget https://github.com/arut/nginx-rtmp-module/archive/v${vm_RTMP}.tar.gz
wget https://github.com/kaltura/nginx-srt-module/archive/refs/tags/v${vm_SRTP}.tar.gz
wget https://zlib.net/fossils/zlib-${vm_ZLIB}.tar.gz

# extract the source code
cat *.tar.gz | tar -izxvf -

# configure nginx with rtmp module
cd ${WORKDIR}/build/nginx-${v_NGINX}

./configure \
    --with-openssl=../openssl-${vm_OSSL} \
    --with-pcre=../pcre2-${vm_PCRE} \
    --with-zlib=../zlib-${vm_ZLIB} \
    --add-module=../nginx-rtmp-module-${vm_RTMP} \
    --add-module=../nginx-srt-module-${vm_SRTP} \
    --with-stream --with-threads

# compile and install nginx
make -j"$(nproc)"
make install
strip /usr/local/nginx/sbin/nginx

# update nginx configuration to use xplex
cp ${WORKDIR}/conf/*.conf /usr/local/nginx/conf/

# install xplex-hq
mkdir -p /opt/xplex/
cp -r ${WORKDIR}/app/* /opt/xplex/
cd /opt/xplex/
npm install

# add nginx-rtmp and xplex-hq as startup services
cd ${WORKDIR}
cp daemons/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable xplex-hq.service
systemctl start xplex-hq.service
systemctl enable nginx-rtmp.service
systemctl start nginx-rtmp.service

# cleanup & exit
rm -rf ${WORKDIR}/build
echo -e "\033[0;33mInstalled nginx-rtmp to /usr/local/nginx/ \033[0m"
echo -e "\033[0;33mInstalled xplex-hq to /opt/xplex \033[0m"
echo -e ""
echo -e "\033[0;32mCongrats... xplex is now installed! \033[0m"
echo -e ""
exit 0

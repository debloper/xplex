#!/bin/bash

# install dependencies
apt-get update
apt-get install -y gcc g++ perl-modules make wget

# create a temporary working directory
mkdir -p /tmp/xplex
cd /tmp/xplex

# download the source code for nginx, openssl, pcre, rtmp, and zlib
export v_NGINX=1.26.1
export vm_OSSL=1.1.1w
export vm_PCRE=8.45
export vm_RTMP=1.2.2
export vm_ZLIB=1.3.1

wget https://nginx.org/download/nginx-${v_NGINX}.tar.gz
wget https://www.openssl.org/source/openssl-${vm_OSSL}.tar.gz
wget https://sourceforge.net/projects/pcre/files/pcre/${vm_PCRE}/pcre-${vm_PCRE}.tar.gz
wget https://github.com/arut/nginx-rtmp-module/archive/v${vm_RTMP}.tar.gz
wget https://zlib.net/fossils/zlib-${vm_ZLIB}.tar.gz

# extract the source code
cat *.tar.gz | tar -izxvf -

# configure nginx with rtmp module
cd /tmp/xplex/nginx-${v_NGINX}

./configure \
    --with-openssl=../openssl-${vm_OSSL} \
    --with-pcre=../pcre-${vm_PCRE} \
    --with-zlib=../zlib-${vm_ZLIB} \
    --add-module=../nginx-rtmp-module-${vm_RTMP}

# compile and install nginx
make
make install

# update nginx configuration to use xplex
cp conf/*.conf /usr/local/nginx/conf/

# install nodejs
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# install xplex
mkdir -p /opt/xplex/
cp -r app/* /opt/xplex/
cd /opt/xplex/
npm install

# start xplex
nohup npm start &

# start nginx
/usr/local/nginx/sbin/nginx

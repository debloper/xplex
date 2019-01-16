#!/bin/sh

# Hoist variables
NGINX_CONFIG=/usr/local/nginx/conf/
NGINX_BINARY=/usr/local/nginx/sbin/nginx

# Setup multistreaming
if [ -n "$INGESTS" ]; then
  ingests=$(echo $INGESTS | tr " " "\n")
  for i in $ingests
  do
    echo "push $i;" >> ${NGINX_CONFIG}/xplex.conf
  done
fi

cat ${NGINX_CONFIG}/xplex.conf

# Leave webserver as is

# Start nginx
${NGINX_BINARY}

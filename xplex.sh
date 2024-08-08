#!/bin/sh

# Start xplex HQ dashboard
nohup npm start &

# Start nginx (daemon mode off)
/usr/local/nginx/sbin/nginx

#!/bin/bash

set -o errexit

if [[ ! -d /tmp ]]; then
  mkdir /tmp
fi
chmod 1777 /tmp

export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes
apt-get -y autoremove
apt-get -y autoclean

rm -rf /tmp/* /var/tmp/*
history -c
cat /dev/null > /root/.bash_history
unset HISTFILE
find /var/log -mtime -1 -type f -exec truncate -s 0 {} \;
rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????
rm -rf /var/lib/cloud/instances/*
rm -f /root/.ssh/authorized_keys /etc/ssh/*key*
touch /etc/ssh/revoked_keys
chmod 600 /etc/ssh/revoked_keys

printf "\n\033[0;32mSecure erasing file system:\033[0m\n"

dd if=/dev/zero of=/zerofile bs=4096 || rm /zerofile

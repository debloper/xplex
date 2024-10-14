#!/bin/sh

ufw limit ssh
ufw allow http
ufw allow https
ufw allow 1935

ufw --force enable
ufw status verbose

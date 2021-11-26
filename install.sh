#!/bin/bash - 
#===============================================================================
#
#          FILE: installer.sh
# 
#         USAGE: sh installer.sh 
# 
#   DESCRIPTION:
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: yedamao, 
#  ORGANIZATION: 
#       CREATED: 11/26/2021 14:21
#      REVISION:  ---
#===============================================================================
set -o nounset                              # Treat unset variables as an error

cat << EOF > ss-local.json
{
    "server":"$SERVER",
    "server_port":$SERVER_PORT,
    "local_port":$LOCAL_PORT,
    "password":"$PASSWORD",
    "timeout":$TIMEOUT,
    "method":"$METHOD"
}
EOF

cat << EOF > shadowsocks-libev-local.service
#  This file is part of shadowsocks-libev.
#
#  Shadowsocks-libev is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  This is a template unit file. Users may copy and rename the file into
#  config directories to make new service instances. See systemd.unit(5)
#  for details.

[Unit]
Description=Shadowsocks-Libev Custom Client Service
Documentation=man:ss-local(1)
After=network.target

[Service]
Type=simple
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
ExecStart=/usr/bin/ss-local -c /etc/shadowsocks-libev/ss-local.json

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > privoxy.config
listen-address 0.0.0.0:1087
toggle  1
enable-remote-toggle 1
enable-remote-http-toggle 1
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
forwarded-connect-retries  0
accept-intercepted-requests 0
allow-cgi-request-crunching 0
split-large-forms 0
keep-alive-timeout 5
socket-timeout 60

forward         192.168.*.*/     .
forward         10.*.*.*/        .
forward         127.*.*.*/       .
forward         [FE80::/64]      .
forward         [::1]            .
forward         [FD00::/8]       .
forward-socks5 / 127.0.0.1:1086 .

# Put user privoxy config line in this file.
# Ref: https://www.privoxy.org/user-manual/index.html
EOF

# install pkg
apt update && apt install -y vim zsh tmux shadowsocks-libev privoxy

# setup ss-local
cp ss-local.json /etc/shadowsocks-libev/
cp shadowsocks-libev-local.service /etc/systemd/system/
chmod 644 /etc/systemd/system/shadowsocks-libev-local.service
systemctl start shadowsocks-libev-local.service
systemctl enable shadowsocks-libev-local.service

# setup privoxy convert sock5 to http
cp privoxy.config /etc/privoxy/config
systemctl restart privoxy.service

# create user
useradd $CREATE_USER_NAME -m -s /bin/zsh
passwd $CREATE_USER_NAME
adduser $CREATE_USER_NAME sudo

su damao; cd;

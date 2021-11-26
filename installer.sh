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

# install pkg
apt update && apt install -y vim zsh tmux shadowsocks-libev privoxy

# setup ss-local
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

cp ss-local.json /etc/shadowsocks-libev/
cp shadowsocks/shadowsocks-libev-local.service /etc/systemd/system/
chmod 644 /etc/systemd/system/shadowsocks-libev-local.service
systemctl start shadowsocks-libev-local.service
systemctl enable shadowsocks-libev-local.service

# setup privoxy convert sock5 to http
cp privoxy/privoxy.config /etc/privoxy/config
systemctl restart privoxy.service

# create user
useradd $CREATE_USER_NAME -m -s /bin/zsh
passwd $CREATE_USER_NAME
adduser $CREATE_USER_NAME sudo

su damao; cd;

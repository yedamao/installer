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
set -e

command -v yum >/dev/null 2>&1 && PKG_MANAGER="yum"
command -v apt >/dev/null 2>&1 && PKG_MANAGER="apt"

if [ "$PKG_MANAGER" = "" ]; then
  echo "Neither yum nor apt found" && exit 1
fi

echo "PKG_MANAGER:" $PKG_MANAGER

# install zsh
$PKG_MANAGER update && $PKG_MANAGER install -y zsh curl

# Default settings
CREATE_USER_NAME=${CREATE_USER_NAME:-damao}

# create user
useradd $CREATE_USER_NAME -m -s /bin/zsh
passwd $CREATE_USER_NAME

# add USER to sudoers

# ubuntu
if [ "$PKG_MANAGER" = "apt" ]; then
  adduser $CREATE_USER_NAME sudo
fi
# centos
if [ "$PKG_MANAGER" = "yum" ]; then
  usermod -aG wheel $CREATE_USER_NAME
fi

su -c "$(curl -fsSL https://raw.githubusercontent.com/yedamao/installer/main/me.sh)" $CREATE_USER_NAME

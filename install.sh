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

PKG_MANAGER=$( command -v yum || command -v apt ) || ( echo "Neither yum nor apt found" && exit )

# install zsh
$PKG_MANAGER update && $PKG_MANAGER install -y zsh

# Default settings
CREATE_USER_NAME=${CREATE_USER_NAME:-damao}

# create user
useradd $CREATE_USER_NAME -m -s /bin/zsh
passwd $CREATE_USER_NAME
adduser $CREATE_USER_NAME sudo

su -c "$(curl -fsSL https://raw.githubusercontent.com/yedamao/installer/main/me.sh)" $CREATE_USER_NAME

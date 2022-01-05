#!/bin/bash - 
#===============================================================================
#
#          FILE: code-server.sh
# 
#         USAGE: ./code-server.sh 
# 
#   DESCRIPTION: setup code server
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: yedamao, 
#  ORGANIZATION: 
#       CREATED: 01/05/2022 16:22
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Default settings
VERSION=${CODE_SERVER_VERSION:-4.0.0}

curl -fOL https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server_${VERSION}_amd64.deb
sudo -S dpkg -i code-server_${VERSION}_amd64.deb
sudo systemctl enable --now code-server@$USER
sudo systemctl restart code-server@$USER

# install caddy
sudo -S apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

# caddy config
cat << EOF > Caddyfile
$CODE_SERVER_DOMAIN_NAME
reverse_proxy 127.0.0.1:8080
EOF

sudo cp Caddyfile /etc/caddy/Caddyfile
sudo systemctl reload caddy

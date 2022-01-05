#!/bin/bash - 
#===============================================================================
#
#          FILE: damao.sh
# 
#         USAGE: ./damao.sh
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: yedamao,
#  ORGANIZATION: 
#       CREATED: 11/26/2021 16:20
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

file_exists() {
  test -f "$@" || test -d "$@"
}

sudo -S apt install -y zsh cmake python3-dev build-essential

# golang
GO_VERSION=1.17.3
curl -o /tmp/go$GO_VERSION.linux-amd64.tar.gz -L https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo -S rm -rf /usr/local/go && sudo -S tar -C /usr/local -xzf /tmp/go$GO_VERSION.linux-amd64.tar.gz

# dotfiles
cd ~ && sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply yedamao

# install oh my zsh
if ! file_exists ~/.oh-my-zsh; then
  echo "install oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

source ~/.zshrc

# setup vim
plug_path=~/.vim/autoload/plug.vim
if ! file_exists $plug_path; then
  echo "setup vim"
  curl -fLo $plug_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'
  ~/.vim/plugged/youcompleteme/install.py --clang-completer --go-completer --force-sudo
fi

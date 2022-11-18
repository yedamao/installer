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

if command -v apt >/dev/null 2>&1; then
  sudo -S apt install -y zsh cmake python3-dev build-essential autojump ctags
fi

if command -v yum >/dev/null 2>&1; then
  sudo -S yum install -y zsh cmake python3-devel autojump ctags
  sudo -S yum group install -y "Development Tools"
fi


# golang
# Default GO_VERSION=1.19.3
GO_VERSION=${GO_VERSION:-1.19.3}
curl -o /tmp/go$GO_VERSION.linux-amd64.tar.gz -L https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
sudo -S rm -rf /usr/local/go && sudo -S tar -C /usr/local -xzf /tmp/go$GO_VERSION.linux-amd64.tar.gz

# install oh my zsh
if ! file_exists ~/.oh-my-zsh; then
  echo "install oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# dotfiles
cd ~ && sh -c "$(curl -fsLS git.io/chezmoi)" -- init yedamao --apply --purge --force
source ~/.zshrc

# tmux plugins manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# setup vim
plug_path=~/.vim/autoload/plug.vim
if ! file_exists $plug_path; then
  echo "setup vim"
  curl -fLo $plug_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c 'PlugInstall' -c 'qa!'
fi

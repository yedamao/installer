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

export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

# install oh my zsh
if ! file_exists ~/.oh-my-zsh; then
  echo "install oh my zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# dotfiles
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply yedamao

source ~/.zshrc

# setup vim
plug_path=~/.vim/autoload/plug.vim
if ! file_exists $plug_path; then
  echo "setup vim"
  curl -fLo $plug_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -c PlugInstall
  ~/.vim/plugged/youcompleteme/install.sh --clang-completer --go-completer
fi

install_code_server() {
  VERSION=3.12.0
  curl -fOL https://github.com/cdr/code-server/releases/download/v$VERSION/code-server_$VERSION_amd64.deb
  sudo dpkg -i code-server_$VERSION_amd64.deb
  sudo systemctl enable --now code-server@$USER

  # change bind addr
  sed -i.bak 's/bind-addr: 127.0.0.1:8080/bind-addr: 0.0.0.0:4096/' ~/.config/code-server/config.yaml
  sudo systemctl restart code-server@$USER
}

install_code_server

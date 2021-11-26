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

export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

# dotfiles
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply yedamao

# setup vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c PlugInstall

~/.vim/plugged/youcompleteme/install.sh --clang-completer --go-completer

# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#!/bin/bash - 
#===============================================================================
#
#          FILE: user.sh
# 
#         USAGE: sh user.sh
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

USERNAME=""
DEFAULT_USERNAME=damao

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

create_user() {
  useradd $USERNAME -m -s /bin/zsh
  passwd $USERNAME
}

# add USER to sudoers
add_sudo() {
  # ubuntu
  if command_exists apt; then
    adduser $USERNAME sudo

  # centos
  elif command_exists yum; then
    usermod -aG wheel $USERNAME
  fi
}

main() {

  while getopts "hu:" OPT; do
    case $OPT in
      h)
        echo "Usage: $0 [options]"
        echo "  -h, --help    Display this help message"
        echo "  -u, --user    Create username"
        exit 0
        ;;
      u)
        USERNAME_ARG=$OPTARG
        ;;
    esac
  done

  USERNAME=${USERNAME_ARG:-$DEFAULT_USERNAME}

  echo "Create user: $USERNAME"

  if ! command_exists zsh; then
    echo "zsh not found 😭 please install it first"
    exit 1
  fi

  create_user
  add_sudo

  echo "$USERNAME has been settled down successfully! 🎉"
}

main "$@"

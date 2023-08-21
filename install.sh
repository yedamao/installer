#!/bin/bash -
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh
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
set -e

# Default Options
SKIP_VIM_PLUG_INSTALL=${SKIP_VIM_PLUG_INSTALL:-no}

file_exists() {
  test -f "$@" || test -d "$@"
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

print_success() {
  printf "\e[0;32m  [✔] %s\e[0m\n" "$1 😄"
}

print_fail() {
  printf "\e[0;32m  [x] %s\e[0m\n" "$1 😭"
}

install_prerequire_pkg() {
  if command_exists apt; then
    sudo -S apt update && sudo -S apt install -y \
      curl git vim \
      zsh cmake python3-dev build-essential autojump universal-ctags \
      || exit 1
  fi

  if command_exists yum; then
    sudo -S yum install -y \
      curl git vim \
      zsh cmake python3-devel autojump ctags \
      && sudo -S yum group install -y "Development Tools" \
      || exit 1
  fi

  print_success "Prerequire packages installed successfully"
}

setup_golang() {
  # Default GO_VERSION
  LATEST_GO_VERSION=$(curl 'https://go.dev/VERSION?m=text' | head -n 1)
  GO_VERSION=${GO_VERSION:-$LATEST_GO_VERSION}

  printf "setup golang" "version: $GO_VERSION"

  curl -o /tmp/$GO_VERSION.linux-amd64.tar.gz -L https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz \
    && sudo -S rm -rf /usr/local/go && sudo -S tar -C /usr/local -xzf /tmp/$GO_VERSION.linux-amd64.tar.gz

  if [ $? -ne 0  ]; then
    print_fail "setup golang failed" 
    exit
  fi
   
  print_success "Go installed successfully"
}

setup_java() {

  JDK_VERSION=${JDK_VERSION:-17.0.8}
  MVN_VERSION=${MVN_VERSION:-3.9.4}

  curl -o /tmp/jdk-${JDK_VERSION}_linux-x64_bin.tar.gz -L "https://download.oracle.com/java/17/archive/jdk-${JDK_VERSION}_linux-x64_bin.tar.gz" && \
    sudo -S rm -rf /opt/jdk-${JDK_VERSION} && sudo -S tar -C /opt -xzf "/tmp/jdk-${JDK_VERSION}_linux-x64_bin.tar.gz"

  print_success "Java installed successfully"

  curl -o /tmp/apache-maven-${MVN_VERSION}-bin.tar.gz -L "https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz" && \
    sudo -S rm -rf /opt/apache-maven-${MVN_VERSION} && sudo -S tar -C /opt -xzf "/tmp/apache-maven-${MVN_VERSION}-bin.tar.gz"

  print_success "maven installed successfully"
}

setup_ohmyzsh() {
  # install oh my zsh
  if file_exists ~/.oh-my-zsh; then
    echo "ohmyzsh already setup"
    return
  fi

  echo "install oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  if [ $? -ne 0  ]; then
    print_fail "setup ohmyzsh failed"
    exit
  fi

  print_success "ohmyzsh installed successfully"
}

setup_dotfiles() {
  echo "setup dotfiles"
  cd ~ && sh -c "$(curl -fsLS git.io/chezmoi)" -- init yedamao --apply --purge --force
  if [ $? -ne 0  ]; then
    print_fail "setup dotfiles failed"
    exit
  fi

  print_success "dotfiles installed successfully"
}

setup_tmux() {

  if file_exists ~/.tmux/plugins/tpm; then
    echo "tmux already setup"
    return
  fi

  echo "setup tmux"

  # tmux plugins manager
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  print_success "tmux installed successfully"
}

setup_vim() {

  plug_path=~/.vim/autoload/plug.vim
  if file_exists $plug_path; then
    echo "vim already setup"
    return
  fi

  echo "setup vim"
  curl -fLo $plug_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  print_success "vim installed successfully"

  if [ "$SKIP_VIM_PLUG_INSTALL" = "yes" ]; then
    echo "skip vim plug install"
    return
  fi

  export PATH=/usr/local/go/bin:$PATH
  export GOPATH=$HOME/workspace/Go
  vim -c 'PlugInstall' -c 'qa!'

  print_success "vim plugins installed successfully"
}

main() {

  # Parse arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help)
        echo "Usage: $0 [options]"
        echo "  -h, --help    Display this help message"
        echo "  --skip-vim-plug-install skip install vim plug"
        exit 0
        ;;
      --skip-vim-plug-install) SKIP_VIM_PLUG_INSTALL=yes ;;
    esac
    shift
  done

  install_prerequire_pkg

  setup_golang

  setup_java

  setup_ohmyzsh

  setup_dotfiles

  setup_vim

  setup_tmux
}

main "$@"

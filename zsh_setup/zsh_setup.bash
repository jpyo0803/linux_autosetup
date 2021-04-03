#!/usr/bin/env bash

APP_NAME="zsh"
BASEDIR_ZSH=$(dirname "$0")

function config_zsh() {
  echo "configuring $APP_NAME"

  is_app_already_installed curl
  if [ $? -ne 1 ]; then
    echo "Installing curl"
    $SUDO apt install -y curl
  fi

  is_app_already_installed git
  if [ $? -ne 1 ]; then
    $BASEDIR_ZSH/../git_setup/git_setup.bash
  fi

  is_app_already_installed locales
  if [ $? -ne 1 ]; then
    echo "Installing locales"
    $SUDO apt install -y locales
    locale-gen en_US.UTF-8
  fi

  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  $SUDO apt install -y autojump
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  sed -i 's/robbyrussell/agnoster/g' ~/.zshrc
  sed -i 's/plugins=(git)/plugins=(git autojump zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

  git clone https://github.com/powerline/fonts.git $BASEDIR_ZSH/fonts
  $BASEDIR_ZSH/fonts/install.sh
  rm -rf $BASEDIR_ZSH/fonts

  $SUDO chsh -s `which zsh`
}

function install_zsh() {
  echo "Installing $APP_NAME"
  . $BASEDIR_ZSH/../common_utils.bash

  is_superuser_privileged
  if [ $? -eq 0 ]; then
    SUDO="sudo"
  fi

  change_locale_kr

  need_to_update_apt
  if [ $? -eq 1 ]; then
    $SUDO apt update
  fi

  is_app_already_installed $APP_NAME
  if [ $? -ne 1 ]; then
    $SUDO apt install -y $APP_NAME
  else
    echo "$APP_NAME is already installed"
  fi

  if typeset -f config_$APP_NAME > /dev/null; then
    config_$APP_NAME
  fi
}

install_zsh

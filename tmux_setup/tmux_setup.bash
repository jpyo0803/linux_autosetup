#!/usr/bin/env bash

APP_NAME="tmux"
BASEDIR_TMUX=$(dirname "$0")

function install_tmux() {
  echo "Installing $APP_NAME"
  . $BASEDIR_TMUX/../common_utils.bash

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

install_tmux

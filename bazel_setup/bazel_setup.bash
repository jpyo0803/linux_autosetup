#!/usr/bin/env bash

APP_NAME="bazel"
BASEDIR_BAZEL=$(dirname "$0")

function install_bazel() {
  echo "Installing $APP_NAME"
  . $BASEDIR_BAZEL/../common_utils.bash

  is_superuser_privileged
  if [ $? -eq 0 ]; then
    SUDO="sudo"
  fi

  change_locale_kr

  is_app_already_installed apt-transport-https
  if [ $? -ne 1 ]; then
    echo "Installing apt-transport-https"
    $SUDO apt install -y apt-transport-https
  fi

  is_app_already_installed curl
  if [ $? -ne 1 ]; then
    echo "Installing curl"
    $SUDO apt install -y curl
  fi

  is_app_already_installed gnupg
  if [ $? -ne 1 ]; then
    echo "Installing gnupg"
    $SUDO apt install -y gnupg
  fi

  curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg

  $SUDO mv bazel.gpg /etc/apt/trusted.gpg.d/

  echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | $SUDO tee /etc/apt/sources.list.d/bazel.list

  $SUDO apt update
  
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

install_bazel

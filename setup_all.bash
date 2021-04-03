#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

function install_all() {
  APT_APPS=(vim git zsh tmux bazel)
  for APT_APP in ${APT_APPS[@]}; do
    APT_APP_BASH_PATH="$BASEDIR/${APT_APP}_setup/${APT_APP}_setup.bash"
    if [ -f "$APT_APP_BASH_PATH" ]; then
      $APT_APP_BASH_PATH
    fi
  done
}

install_all



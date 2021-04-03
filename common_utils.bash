#!/bin/bash

function is_app_already_installed() {
	if command -v $1 &> /dev/null; then
		return 1
	else
		return 0
	fi
}

function is_superuser_privileged() {
	if [ $EUID -ne 0  ]; then
    return 0
	else
		return 1
	fi
}

function need_to_update_apt() {
	LAST_APT_UPDATED=$(stat -c %y /var/lib/apt/periodic/update-success-stamp)
	LAST_APT_UPDATED_DATE=${LAST_APT_UPDATED:0:10}
	NOW_DATE=$(date '+%Y-%m-%d')
	if [ $NOW_DATE != $LAST_APT_UPDATED_DATE ]; then
		return 1
	else
		return 0
	fi
}

function change_locale_kr() {
	is_superuser_privileged
	if [ $? -eq 0 ]; then
    SUDO="sudo"
  fi
	$SUDO sed -i 's/\/\/archive.ubuntu.com/\/\/mirror.kakao.com/g' /etc/apt/sources.list
}
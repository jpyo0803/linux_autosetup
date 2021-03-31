#!/bin/bash

main() {

echo "Running linux autosetup"

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

# change locale to South Korea
$SUDO sed -i 's/\/\/archive.ubuntu.com/\/\/kr.archive.ubuntu.com/g' /etc/apt/sources.list

APT_APPS=(vim git zsh)

$SUDO apt update 

for APT_APP in ${APT_APPS[@]}; do
	is_app_exist ${APT_APP}
	if [[ $? == 1 ]]; then
		echo "${APT_APP} already exist, skipping..."
		continue
	fi

	echo "Installing: ${APT_APP}"
	$SUDO apt install -y ${APT_APP}
	if typeset -f ${APT_APP}_config > /dev/null; then
		echo "Calling ${APT_APP}_config"
		${APT_APP}_config
	else
		echo "${APT_APP}_config does not exist"
	fi
done

}

function git_config() {
	echo "Configuring git"

	git config --global user.email "gch99517@gmail.com"
	git config --global user.name "Jinwon Pyo"
	git config --global alias.co checkout
	git config --global alias.br branch
	git config --global alias.ci commit
	git config --global alias.st status
	git config --global alias.pick cherry-pick

	is_app_exist vim
	if [[ $? == 0 ]]; then
		echo "Installing vim"
		$SUDO apt install -y vim
		echo "Configuring default text editor for git to vim"
		git config --global core.editor "vim"
	fi
}

function zsh_config() {
	echo "Configuring zsh"
	
	$SUDO chsh -s `which zsh`
	is_app_exist curl
	if [[ $? == 0 ]]; then
		echo "Installing curl"
		$SUDO apt install -y curl
	fi
	is_app_exist git
	if [[ $? == 0 ]]; then
		echo "Installing git"
		$SUDO apt install -y git
	fi
	is_app_exist locales
	if [[ $? == 0 ]]; then
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

	git clone https://github.com/powerline/fonts.git
	./fonts/install.sh
	rm -rf fonts
}

function is_app_exist() {
	if command -v $1 &> /dev/null; then
		return 1
	else
		return 0
	fi
}

main "$@"

